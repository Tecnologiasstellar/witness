-- Witness content catalog: released operational truth only.
-- RLS is deny-by-default; policies below grant the narrow public reads.
-- Rollback: drop tables content_collection_items, content_collections,
-- media_assets, content_items, catalog_releases and the helper functions.

create table public.catalog_releases (
    id uuid primary key default gen_random_uuid(),
    version text not null unique,
    schema_version integer not null check (schema_version > 0),
    manifest jsonb not null,
    status text not null check (status in ('draft', 'reviewed', 'released', 'withdrawn')),
    released_at timestamptz,
    created_at timestamptz not null default now(),
    constraint released_requires_timestamp
        check (status <> 'released' or released_at is not null)
);

create table public.content_items (
    id text primary key,
    content_type text not null check (content_type in (
        'species_record', 'field_letter', 'dossier', 'interlude',
        'synthesis', 'dispatch', 'return_note'
    )),
    access_requirement text not null check (access_requirement in ('free', 'field_season_1', 'atlas')),
    payload jsonb not null,
    payload_checksum text not null,
    editorial_state text not null check (editorial_state in (
        'prototype', 'pending', 'approved', 'rejected', 'withdrawn'
    )),
    rights_state text not null check (rights_state in (
        'pending', 'approved', 'rejected', 'not_applicable'
    )),
    sensitive_location_state text not null check (sensitive_location_state in (
        'pending', 'approved', 'rejected', 'not_applicable'
    )),
    last_verified_at date,
    published_at timestamptz,
    updated_at timestamptz not null default now()
);

create table public.content_collections (
    id text primary key,
    title text not null,
    kind text not null check (kind in ('field_season', 'atlas_path', 'dispatch_series')),
    access_requirement text not null check (access_requirement in ('free', 'field_season_1', 'atlas')),
    status text not null check (status in ('draft', 'reviewed', 'released', 'withdrawn')),
    metadata jsonb not null default '{}'::jsonb
);

create table public.content_collection_items (
    collection_id text not null references public.content_collections (id),
    content_item_id text not null references public.content_items (id),
    position integer not null check (position >= 0),
    available_at timestamptz,
    primary key (collection_id, content_item_id),
    unique (collection_id, position)
);

create table public.media_assets (
    id text primary key,
    content_item_id text references public.content_items (id),
    storage_path text not null,
    media_type text not null check (media_type in ('image', 'audio', 'transcript', 'pdf')),
    byte_size bigint not null check (byte_size >= 0),
    checksum text not null,
    creator text,
    rights_holder text,
    license_id text,
    source_url text,
    required_attribution text,
    commercial_use_state text not null check (commercial_use_state in ('pending', 'approved', 'rejected')),
    verified_at date,
    access_requirement text not null check (access_requirement in ('free', 'field_season_1', 'atlas')),
    constraint approved_media_is_verified
        check (commercial_use_state <> 'approved' or verified_at is not null)
);

create index catalog_releases_released_idx
    on public.catalog_releases (status, released_at desc);
create index content_items_published_idx
    on public.content_items (access_requirement, published_at)
    where published_at is not null;
create index content_collection_items_order_idx
    on public.content_collection_items (collection_id, position);
create index media_assets_content_item_idx
    on public.media_assets (content_item_id);

-- A content item is publicly deliverable only when every release gate is
-- explicitly approved (or not applicable) and it is published. PENDING and
-- null fail closed.
create or replace function public.content_item_is_released(item public.content_items)
returns boolean
language sql
immutable
as $$
    select item.published_at is not null
        and item.editorial_state = 'approved'
        and item.rights_state in ('approved', 'not_applicable')
        and item.sensitive_location_state in ('approved', 'not_applicable')
$$;

alter table public.catalog_releases enable row level security;
alter table public.content_items enable row level security;
alter table public.content_collections enable row level security;
alter table public.content_collection_items enable row level security;
alter table public.media_assets enable row level security;

-- Public (anon and authenticated) may read released catalog metadata and
-- released FREE content only. Premium metadata requires an entitlement
-- check that arrives with the purchase-mirror migration; no premium read
-- policy exists until then, so premium rows are unreadable.
create policy catalog_releases_public_read on public.catalog_releases
    for select using (status = 'released');

create policy content_items_free_read on public.content_items
    for select using (
        access_requirement = 'free'
        and public.content_item_is_released(content_items)
    );

create policy content_collections_public_read on public.content_collections
    for select using (status = 'released');

create policy content_collection_items_public_read on public.content_collection_items
    for select using (
        exists (
            select 1 from public.content_collections c
            where c.id = collection_id and c.status = 'released'
        )
    );

create policy media_assets_free_read on public.media_assets
    for select using (
        access_requirement = 'free'
        and commercial_use_state = 'approved'
    );

-- No insert/update/delete policies: only the service role (which bypasses
-- RLS) may write editorial data.

-- Explicit table grants: SELECT only, for client roles; RLS then restricts
-- rows. Write privileges are never granted to client roles.
grant select on public.catalog_releases to anon, authenticated;
grant select on public.content_items to anon, authenticated;
grant select on public.content_collections to anon, authenticated;
grant select on public.content_collection_items to anon, authenticated;
grant select on public.media_assets to anon, authenticated;
