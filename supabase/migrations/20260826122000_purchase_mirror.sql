-- RevenueCat purchase mirror: operational truth for server-side premium
-- authorization. Only the service-role webhook path writes these tables;
-- a client can read nothing except its own entitlement projection.
-- Rollback: drop function has_current_entitlement, my_entitlements,
-- tables support_events, entitlement_snapshots, purchase_events, and the
-- premium read policies created here.

create table public.purchase_events (
    provider_event_id text primary key,
    app_user_id uuid,
    product_id text not null check (product_id in (
        'com.avp.witness.fieldseason1',
        'com.avp.witness.atlas.sixmonth',
        'com.avp.witness.atlas.annual',
        'com.avp.witness.support.once'
    )),
    event_type text not null,
    environment text not null check (environment in ('sandbox', 'production')),
    transaction_id_hash text,
    occurred_at timestamptz not null,
    received_at timestamptz not null default now(),
    payload_redacted jsonb not null default '{}'::jsonb
);

create index purchase_events_user_idx
    on public.purchase_events (app_user_id, occurred_at desc);

create table public.entitlement_snapshots (
    app_user_id uuid not null,
    entitlement_id text not null check (entitlement_id in ('field_season_1_access', 'atlas_access')),
    is_active boolean not null,
    product_id text,
    expires_at timestamptz,
    will_renew boolean,
    environment text not null check (environment in ('sandbox', 'production')),
    provider_updated_at timestamptz not null,
    updated_at timestamptz not null default now(),
    primary key (app_user_id, entitlement_id, environment)
);

create index entitlement_snapshots_active_idx
    on public.entitlement_snapshots (app_user_id, entitlement_id)
    where is_active;

create table public.support_events (
    provider_transaction_key text primary key,
    app_user_id uuid,
    product_id text not null check (product_id = 'com.avp.witness.support.once'),
    environment text not null check (environment in ('sandbox', 'production')),
    occurred_at timestamptz not null
);

alter table public.purchase_events enable row level security;
alter table public.entitlement_snapshots enable row level security;
alter table public.support_events enable row level security;

-- A subject may read only its own entitlement projection. purchase_events
-- and support_events have no client policies at all.
create policy entitlement_snapshots_own_read on public.entitlement_snapshots
    for select using (app_user_id = auth.uid());

-- Grants: entitlement projection is readable by authenticated subjects only
-- (RLS narrows to the caller's own rows). The purchase and support mirrors
-- get no client grants whatsoever.
grant select on public.entitlement_snapshots to authenticated;

-- Server-side entitlement check for premium authorization. Sandbox rows
-- never grant access outside a sandbox deployment: the deployment's
-- environment is fixed by app.settings.environment (default production).
create or replace function public.has_current_entitlement(entitlement text)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
    select exists (
        select 1
        from public.entitlement_snapshots s
        where s.app_user_id = auth.uid()
          and s.entitlement_id = entitlement
          and s.is_active
          and (s.expires_at is null or s.expires_at > now())
          and s.environment = coalesce(
              nullif(current_setting('app.settings.environment', true), ''),
              'production'
          )
    )
$$;

revoke execute on function public.has_current_entitlement from public, anon;
grant execute on function public.has_current_entitlement to authenticated;

-- Premium catalog reads become possible only through a current entitlement.
create policy content_items_entitled_read on public.content_items
    for select to authenticated using (
        public.content_item_is_released(content_items)
        and (
            (access_requirement = 'field_season_1'
                and (public.has_current_entitlement('field_season_1_access')
                     or public.has_current_entitlement('atlas_access')))
            or (access_requirement = 'atlas'
                and public.has_current_entitlement('atlas_access'))
        )
    );

create policy media_assets_entitled_read on public.media_assets
    for select to authenticated using (
        commercial_use_state = 'approved'
        and (
            (access_requirement = 'field_season_1'
                and (public.has_current_entitlement('field_season_1_access')
                     or public.has_current_entitlement('atlas_access')))
            or (access_requirement = 'atlas'
                and public.has_current_entitlement('atlas_access'))
        )
    );
