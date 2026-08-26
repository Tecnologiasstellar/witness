-- Witness events and server-derived aggregates.
-- The client never writes an aggregate; submission is an idempotent,
-- rate-limited RPC that returns the authoritative count.
-- Rollback: drop function submit_witness, tables witness_aggregates,
-- witness_events.

create table public.witness_events (
    id uuid primary key,
    species_id text not null,
    assigned_period text not null,
    installation_subject uuid not null,
    event_version integer not null check (event_version > 0),
    occurred_at timestamptz not null,
    received_at timestamptz not null default now(),
    idempotency_key text not null unique
);

create index witness_events_subject_recent_idx
    on public.witness_events (installation_subject, received_at desc);

create table public.witness_aggregates (
    species_id text not null,
    assigned_period text not null,
    witness_count bigint not null default 0 check (witness_count >= 0),
    updated_at timestamptz not null default now(),
    primary key (species_id, assigned_period)
);

alter table public.witness_events enable row level security;
alter table public.witness_aggregates enable row level security;

-- Aggregates are the only publicly readable community data.
create policy witness_aggregates_public_read on public.witness_aggregates
    for select using (true);

-- No policy on witness_events: individual events are never client-readable
-- or client-writable. All writes flow through submit_witness.

-- Idempotent submission. Requires an authenticated (anonymous-auth) subject;
-- the subject comes from the JWT, never from the payload. Returns the
-- authoritative aggregate for the species/period.
create or replace function public.submit_witness(
    event_id uuid,
    species text,
    period text,
    occurred timestamptz,
    version integer default 1
)
returns bigint
language plpgsql
security definer
set search_path = public
as $$
declare
    subject uuid;
    recent_count bigint;
    inserted boolean := false;
    current_count bigint;
begin
    subject := auth.uid();
    if subject is null then
        raise exception 'authentication required' using errcode = '42501';
    end if;

    if species is null or length(species) = 0 or length(species) > 128
        or period is null or length(period) = 0 or length(period) > 32
        or version < 1 then
        raise exception 'invalid witness event' using errcode = '22023';
    end if;

    -- Rate limit: a subject records at most 30 events per hour. The free
    -- ritual needs roughly one per day; this only stops abuse.
    select count(*) into recent_count
    from public.witness_events
    where installation_subject = subject
      and received_at > now() - interval '1 hour';
    if recent_count >= 30 then
        raise exception 'rate limit exceeded' using errcode = '54000';
    end if;

    insert into public.witness_events (
        id, species_id, assigned_period, installation_subject,
        event_version, occurred_at, idempotency_key
    )
    values (
        event_id, species, period, subject, version, occurred,
        species || '|' || period || '|' || subject::text
    )
    on conflict (idempotency_key) do nothing;
    inserted := found;

    if inserted then
        insert into public.witness_aggregates (species_id, assigned_period, witness_count, updated_at)
        values (species, period, 1, now())
        on conflict (species_id, assigned_period) do update
            set witness_count = public.witness_aggregates.witness_count + 1,
                updated_at = now();
    end if;

    select witness_count into current_count
    from public.witness_aggregates
    where species_id = species and assigned_period = period;

    return coalesce(current_count, 0);
end;
$$;

-- Only authenticated subjects may call the RPC.
revoke execute on function public.submit_witness from public, anon;
grant execute on function public.submit_witness to authenticated;

-- Aggregates are the only client-readable community table. witness_events
-- gets no client grant at all: reads and writes both fail at the privilege
-- layer before RLS is even consulted.
grant select on public.witness_aggregates to anon, authenticated;
