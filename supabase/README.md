# Witness backend (Supabase)

Migration-controlled Postgres schema, RLS policies, and functions for the
Witness community count and (later) premium authorization. The mobile app
never depends on this service being reachable: the bundled ritual works
offline, and remote failure degrades to honest cached/unavailable states.

## Local development

Requirements: Docker Desktop, the Supabase CLI.

```sh
supabase start          # starts the local stack and applies ./migrations
supabase db reset       # reapplies all migrations from scratch
supabase/tests/run-tests.sh   # adversarial RLS + idempotency suite
```

The test suite runs in one rolled-back transaction and must print
`ALL BACKEND TESTS PASSED`.

`supabase start` prints local demo credentials (safe, identical for every
local install). To point the iOS app at the local stack, create an untracked
`WitnessApp/SupabaseConfig.plist` (gitignored):

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>url</key>
    <string>http://127.0.0.1:54321</string>
    <key>anonKey</key>
    <string>(ANON_KEY from `supabase status`)</string>
</dict>
</plist>
```

Only the anon (publishable) key ever enters the app. Service-role keys and
webhook secrets live exclusively in server secret stores.

## Schema overview

| Migration | Contents |
|---|---|
| `20260826120000_content_catalog.sql` | `catalog_releases`, `content_items`, `content_collections`, `content_collection_items`, `media_assets`; fail-closed release gate (`content_item_is_released`); public read = released + free + approved only |
| `20260826121000_witness_events.sql` | `witness_events`, `witness_aggregates`, idempotent rate-limited `submit_witness` RPC (authenticated only); aggregates are the only public community data |
| `20260826122000_purchase_mirror.sql` | `purchase_events`, `entitlement_snapshots`, `support_events`; `has_current_entitlement`; entitled premium read policies; sandbox/production separation |
| `20260826140000_revenuecat_ingest.sql` | `ingest_revenuecat_event`: atomic, idempotent (event-ID PK), monotonic entitlement projection; service_role-only execute |

Rules:

- Every schema change is a migration in this directory; production is never
  edited by hand.
- RLS is enabled on every table; client roles have SELECT-only grants and
  only where a policy exists. `witness_events`, `purchase_events`, and
  `support_events` have no client grants at all.
- Only the service role (webhook/editorial tooling) writes purchase or
  editorial state. Clients cannot self-grant entitlements — proven by
  `supabase/tests/rls_and_idempotency_test.sql`.
- Anonymous sign-ins are enabled (`config.toml`) as silent pseudonymous
  infrastructure for idempotent witness events. There is no visible account.
  Reinstalling the app creates a new anonymous subject; the old subject's
  events remain as anonymous aggregate history and are not linked to the new
  install.

## RevenueCat webhook (D-024)

`supabase/functions/revenuecat-webhook` is the only writer of the purchase
mirror. RevenueCat authenticates webhooks with a shared-secret
`Authorization` header (it does not HMAC-sign payloads); the function
verifies it in constant time, rejects future-dated events, allow-lists the
four D-020 product IDs, and writes atomically/idempotently through
`ingest_revenuecat_event`. The secret lives in `supabase/functions/.env`
locally (gitignored; created by the test script) and in
`supabase secrets set RC_WEBHOOK_AUTH=...` in production — the same value
goes in the RevenueCat dashboard webhook Authorization field.

```sh
supabase/tests/webhook-test.sh   # adversarial suite; serves the function and attacks it
```

Must print `ALL WEBHOOK TESTS PASSED`.

## Not yet implemented

- Premium media signed-URL authorization path (Phase 5).
- Catalog release manifest endpoint and last-known-good client fallback
  (client fallback logic exists for the bundled catalog).
- Hosted (production) project — external action requiring founder approval.
