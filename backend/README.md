# Witness backend

Two Supabase projects (D-018):

| Environment | Project | URL |
|---|---|---|
| Staging (Debug builds) | `apnwougtcnewgyvnphva` | https://apnwougtcnewgyvnphva.supabase.co |
| Production (TestFlight / App Store) | `hozkcgfajvollyobitmz` | https://hozkcgfajvollyobitmz.supabase.co |

## Applying migrations

Migrations are ordered SQL files in `migrations/`. Apply each file **to staging first** via the Supabase dashboard SQL editor (SQL Editor → paste file → Run), verify behavior, then apply the identical file to production. Never edit an applied migration; write a new numbered file. Destructive migrations carry their rollback commands in the file header.

## Keys

The app uses only the publishable **anon key** per environment, checked into `WitnessApp/Services/BackendConfig.swift`. The service-role key stays in the Supabase dashboard and must never enter this repository, the app, CI, or chat.

## Data model

- `witness_events` — one row per (install, species, local day); the unique constraint makes writes idempotent. Insert-only for anon; never readable by clients.
- `events` — plain analytics (D-017). Insert-only for anon; never readable by clients.
- `species_witness_counts` — aggregate view; the only client-readable surface.
