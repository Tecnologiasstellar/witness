-- Adversarial RLS and idempotency tests for the Witness backend.
-- Run against a local stack with: supabase/tests/run-tests.sh
-- Every scenario raises an exception (failing the script) when a rule is
-- violated. The script leaves no data behind: it runs in one rolled-back
-- transaction.

begin;

-- ---------------------------------------------------------------------------
-- Fixtures (written as service role / table owner, bypassing RLS)
-- ---------------------------------------------------------------------------
insert into public.catalog_releases (version, schema_version, manifest, status, released_at)
values ('1.0.0-test', 1, '{}'::jsonb, 'released', now()),
       ('1.1.0-draft', 1, '{}'::jsonb, 'draft', null);

insert into public.content_items
    (id, content_type, access_requirement, payload, payload_checksum,
     editorial_state, rights_state, sensitive_location_state, last_verified_at, published_at)
values
    ('sp.test.free', 'species_record', 'free', '{}'::jsonb, 'x',
     'approved', 'approved', 'approved', current_date, now()),
    ('sp.test.pendingrights', 'species_record', 'free', '{}'::jsonb, 'x',
     'approved', 'pending', 'approved', current_date, now()),
    ('ch.test.premium', 'dossier', 'field_season_1', '{}'::jsonb, 'x',
     'approved', 'approved', 'approved', current_date, now()),
    ('at.test.premium', 'dispatch', 'atlas', '{}'::jsonb, 'x',
     'approved', 'approved', 'approved', current_date, now());

-- Two subjects: one entitled (production), one with only a sandbox row.
insert into public.entitlement_snapshots
    (app_user_id, entitlement_id, is_active, product_id, expires_at, will_renew, environment, provider_updated_at)
values
    ('11111111-1111-1111-1111-111111111111', 'field_season_1_access', true,
     'com.avp.witness.fieldseason1', null, null, 'production', now()),
    ('22222222-2222-2222-2222-222222222222', 'atlas_access', true,
     'com.avp.witness.atlas.annual', now() + interval '30 days', true, 'sandbox', now());

-- ---------------------------------------------------------------------------
-- Helpers
-- ---------------------------------------------------------------------------
create or replace function pg_temp.impersonate(role_name text, subject uuid)
returns void language plpgsql as $$
begin
    execute format('set local role %I', role_name);
    perform set_config('request.jwt.claims',
        json_build_object('sub', subject, 'role', role_name)::text, true);
end $$;

create or replace function pg_temp.reset_role() returns void language plpgsql as $$
begin
    reset role;
    perform set_config('request.jwt.claims', '', true);
end $$;

-- ---------------------------------------------------------------------------
-- 1. Anonymous catalog reads: released+free only
-- ---------------------------------------------------------------------------
do $$
declare n bigint;
begin
    perform pg_temp.impersonate('anon', null);

    select count(*) into n from public.catalog_releases;
    assert n = 1, 'anon must see only released catalog rows, saw ' || n;

    select count(*) into n from public.content_items;
    assert n = 1, 'anon must see only released free content, saw ' || n;

    select count(*) into n from public.content_items where id = 'sp.test.pendingrights';
    assert n = 0, 'pending rights must fail closed';

    select count(*) into n from public.content_items where access_requirement <> 'free';
    assert n = 0, 'anon must never see premium metadata';

    perform pg_temp.reset_role();
end $$;

-- ---------------------------------------------------------------------------
-- 2. Anonymous writes are denied everywhere
-- ---------------------------------------------------------------------------
do $$
begin
    perform pg_temp.impersonate('anon', null);
    begin
        insert into public.catalog_releases (version, schema_version, manifest, status)
        values ('evil', 1, '{}'::jsonb, 'released');
        raise exception 'anon insert into catalog_releases must be denied';
    exception when insufficient_privilege then null;
    end;
    begin
        update public.witness_aggregates set witness_count = 999999;
        raise exception 'anon update of aggregates must be denied';
    exception when insufficient_privilege then null;
    end;
    perform pg_temp.reset_role();
end $$;

-- ---------------------------------------------------------------------------
-- 3. Entitled premium reads; sandbox rows never grant production access
-- ---------------------------------------------------------------------------
do $$
declare n bigint;
begin
    -- Entitled production subject reads the Field Season dossier.
    perform pg_temp.impersonate('authenticated', '11111111-1111-1111-1111-111111111111');
    select count(*) into n from public.content_items where id = 'ch.test.premium';
    assert n = 1, 'entitled subject must read the premium dossier';
    select count(*) into n from public.content_items where id = 'at.test.premium';
    assert n = 0, 'field season entitlement must not unlock atlas content';
    perform pg_temp.reset_role();

    -- Sandbox-only subject gets nothing in production.
    perform pg_temp.impersonate('authenticated', '22222222-2222-2222-2222-222222222222');
    select count(*) into n from public.content_items where access_requirement <> 'free';
    assert n = 0, 'sandbox entitlement must not grant production access';
    perform pg_temp.reset_role();

    -- Unentitled subject sees only free content.
    perform pg_temp.impersonate('authenticated', '33333333-3333-3333-3333-333333333333');
    select count(*) into n from public.content_items;
    assert n = 1, 'unentitled subject sees only free content, saw ' || n;
    perform pg_temp.reset_role();
end $$;

-- ---------------------------------------------------------------------------
-- 4. Clients cannot write purchase state; can read only their own row
-- ---------------------------------------------------------------------------
do $$
declare n bigint;
begin
    perform pg_temp.impersonate('authenticated', '33333333-3333-3333-3333-333333333333');
    begin
        insert into public.entitlement_snapshots
            (app_user_id, entitlement_id, is_active, environment, provider_updated_at)
        values ('33333333-3333-3333-3333-333333333333', 'atlas_access', true, 'production', now());
        raise exception 'client self-grant of entitlement must be denied';
    exception when insufficient_privilege then null;
    end;
    select count(*) into n from public.entitlement_snapshots;
    assert n = 0, 'subject must not read others'' entitlements';
    perform pg_temp.reset_role();

    perform pg_temp.impersonate('authenticated', '11111111-1111-1111-1111-111111111111');
    select count(*) into n from public.entitlement_snapshots;
    assert n = 1, 'subject must read exactly its own entitlement row';
    begin
        select count(*) into n from public.purchase_events;
        raise exception 'purchase_events must not be client-readable';
    exception when insufficient_privilege then null;
    end;
    perform pg_temp.reset_role();
end $$;

-- ---------------------------------------------------------------------------
-- 5. Witness submission: idempotent, authenticated-only, server-counted
-- ---------------------------------------------------------------------------
do $$
declare c bigint;
begin
    -- Unauthenticated submission is refused.
    perform pg_temp.impersonate('anon', null);
    begin
        perform public.submit_witness(gen_random_uuid(), 'sp.test.free', '2026-08-26', now());
        raise exception 'anon submit_witness must be denied';
    exception when insufficient_privilege then null;
    end;
    perform pg_temp.reset_role();

    -- First submission counts once.
    perform pg_temp.impersonate('authenticated', '44444444-4444-4444-4444-444444444444');
    select public.submit_witness(gen_random_uuid(), 'sp.test.free', '2026-08-26', now()) into c;
    assert c = 1, 'first submission must yield count 1, got ' || c;

    -- A duplicate (same subject/species/period, new event id) does not increment.
    select public.submit_witness(gen_random_uuid(), 'sp.test.free', '2026-08-26', now()) into c;
    assert c = 1, 'duplicate submission must not increment, got ' || c;
    perform pg_temp.reset_role();

    -- A different subject increments.
    perform pg_temp.impersonate('authenticated', '55555555-5555-5555-5555-555555555555');
    select public.submit_witness(gen_random_uuid(), 'sp.test.free', '2026-08-26', now()) into c;
    assert c = 2, 'second subject must increment to 2, got ' || c;

    -- Direct event table access is denied to clients.
    begin
        select count(*) into c from public.witness_events;
        raise exception 'witness_events must not be client-readable';
    exception when insufficient_privilege then null;
    end;
    begin
        insert into public.witness_events
            (id, species_id, assigned_period, installation_subject, event_version, occurred_at, idempotency_key)
        values (gen_random_uuid(), 'x', 'p', gen_random_uuid(), 1, now(), 'forged');
        raise exception 'direct witness_events insert must be denied';
    exception when insufficient_privilege then null;
    end;
    perform pg_temp.reset_role();

    -- Aggregates are publicly readable and correct.
    perform pg_temp.impersonate('anon', null);
    select witness_count into c from public.witness_aggregates
    where species_id = 'sp.test.free' and assigned_period = '2026-08-26';
    assert c = 2, 'public aggregate must be 2, got ' || c;
    perform pg_temp.reset_role();
end $$;

select 'ALL BACKEND TESTS PASSED' as result;

rollback;
