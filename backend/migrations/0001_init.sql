-- 0001_init.sql — witness counts and analytics (D-015, D-017)
-- Apply to witness-staging first, verify, then witness-prod (D-018).
-- Rollback:
--   drop view if exists species_witness_counts;
--   drop table if exists witness_events;
--   drop table if exists events;

create table if not exists witness_events (
  id bigint generated always as identity primary key,
  install_id uuid not null,
  species_id text not null,
  day date not null,
  created_at timestamptz not null default now(),
  constraint witness_events_once_per_day unique (install_id, species_id, day)
);

create table if not exists events (
  id bigint generated always as identity primary key,
  install_id uuid not null,
  name text not null,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

alter table witness_events enable row level security;
alter table events enable row level security;

-- Anonymous clients may only insert. No select policy exists, so raw rows
-- (install ids, per-device behavior) are never readable from the app.
create policy witness_events_insert on witness_events
  for insert to anon with check (true);
create policy events_insert on events
  for insert to anon with check (true);

-- Aggregate counts are the only public read surface. The view intentionally
-- runs with owner rights (Supabase flags this); it exposes nothing but
-- species_id and a count.
create view species_witness_counts as
  select species_id, count(*)::bigint as witness_count
  from witness_events
  group by species_id;

grant select on species_witness_counts to anon;
