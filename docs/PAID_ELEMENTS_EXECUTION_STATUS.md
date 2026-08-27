# Paid-elements execution status

Restart-safe ledger for the paid-enabled Witness 0.2.0 goal. Read this first on every continuation, verify the last claimed evidence, and resume the current vertical outcome.

## Objective

Deliver Witness 0.2.0 as a paid-enabled iOS release candidate implementing free Witness access, permanent Field Season ownership, one Atlas entitlement with six-month and annual billing, and a no-entitlement Support Witness consumable, together with the secure backend, content gates, accessibility, privacy, tests, and release evidence defined in `docs/ACCESS_AND_COMMERCE_SOURCE_OF_RECORD.md`.

## Non-negotiables (summary)

- Free ritual stays complete and uninterrupted; no commerce before the first Witness.
- Three authorization facts only: free, `ownsFieldSeasonOne`, one `atlas_access` state.
- Both Atlas durations grant identical access; Support grants nothing.
- No hardcoded production prices; live store values only.
- No five-tier wall, badges, donor roll, guilt copy, or commerce tab.
- Private reflections never leave the device. Fail closed on PENDING/rights/unknown.
- Release builds must reject test keys and local StoreKit configuration.
- External mutations (ASC, RevenueCat, Supabase prod, signing, commits, releases) need founder approval.

## Current phase

**Phase 4 — Supabase foundation and honest community count** (core delivered and evidenced; remaining: catalog manifest endpoint client, hosted project [founder-blocked]).

## Phase 4 delivered (2026-08-26)

Backend (all local, migration-controlled, no hosted project touched):

- `supabase/` initialized; `config.toml` enables anonymous sign-ins (documented as silent infrastructure identity).
- Migrations: content catalog + fail-closed release gate; witness events/aggregates + idempotent rate-limited `submit_witness` RPC; purchase mirror + `has_current_entitlement` + entitled premium read policies. SELECT-only client grants; `witness_events`/`purchase_events`/`support_events` have no client grants.
- `supabase/tests/rls_and_idempotency_test.sql` + `run-tests.sh` → **ALL BACKEND TESTS PASSED** (2026-08-26, local stack): anon sees released+free only; PENDING fails closed; anon/client writes denied; field-season entitlement ≠ atlas access; sandbox rows never grant production; clients cannot self-grant or read others' entitlements; submit_witness is authenticated-only and idempotent (duplicate does not increment; second subject increments; aggregates public and correct).
- End-to-end HTTP verification with curl against the local stack: anonymous `/auth/v1/signup` (is_anonymous true), RPC idempotent (returns 1 twice), unauthenticated RPC denied 42501.

Client:

- `WitnessCore/Community/WitnessEventOutbox.swift`: `PendingWitnessEvent` (no free-text field — enforced by test), `ReconciledWitnessCount`, `RemoteWitnessEventService` (+count), durable idempotent outbox with exponential backoff, `FakeRemoteWitnessEventService`. Core suite now 42 tests, 0 failures.
- `WitnessApp/Services/SupabaseCommunityService.swift`: plain-URLSession adapter (no SDK) — silent anonymous session in Keychain (`KeychainSessionStore`, AfterFirstUnlockThisDeviceOnly), token refresh, `submit_witness` RPC, public aggregate read. Config via untracked `SupabaseConfig.plist` (gitignored; loader rejects secret-key shapes).
- `CommunityModel`: localOnly/pending/reconciled/unavailable states; server response, never optimistic UI, sets the count; flush on witness, on foreground, and on Notes view.
- UI: Today caption stays "NO PUBLIC COUNT" in local-only builds and becomes "COUNTED ANONYMOUSLY" when a backend is configured; Witnessed plate shows the reconciled/pending/unavailable count line (`witnessed.communityCount`).
- `CommunityCountUITests` 2/2 passed (fake service reconciled count; local-only shows no count and keeps the private promise). `AccessSurfacesUITests` 3/3 passed after adding a settle-retry for a launch-animation tap flake (see defects).
- Accessibility: `today.contents`/`today.privateNote` now have real 44pt hit/accessibility frames — clears the audit's "hit area too small" finding.
- `supabase/README.md`: local setup, schema map, rules, reinstall behavior, not-yet-implemented list.

## Phase 3 — RevenueCat adapter, safe local portion (2026-08-26)

Implemented:

- `project.yml`: RevenueCat SPM package pinned `exactVersion: 5.87.0` (purchases-ios-spm); project regenerated and diff inspected.
- `WitnessApp/Commerce/RevenueCatPurchaseAdapter.swift`: full `PurchaseService` implementation — offering `witness_access_v1`, allow-list-ordered product mapping (decimal price + currency), CustomerInfo→snapshot at the boundary, pending (Ask to Buy) and cancel handling, restore with nothing-found detection. Configured once via `RevenueCatPurchaseAdapter.configure(apiKey:)` in the composition root only.
- `RevenueCatSnapshotMapper` + `EntitlementFacts`: provider-neutral mapping (active/cancelled-but-paid/grace/billing-retry/expired) that is deterministic and unit-tested without SDK object construction.
- `CommerceConfiguration`: untracked `RevenueCatConfig.plist` (gitignored) supplies the public Apple SDK key; validation rejects `sk_` everywhere and `test_` in Release; missing config disables commerce without touching the free ritual.
- Composition: Debug order = fake (UI tests) → RevenueCat (if configured) → local StoreKit harness; Release = RevenueCat (validated key) → `UnavailablePurchaseService`. Foreground `scenePhase` refresh re-verifies access.

Validation (2026-08-26): `WitnessAppTests/RevenueCatMappingTests` 12/12 passed on simulator; Debug simulator build and unsigned generic Release build both BUILD SUCCEEDED with the SDK linked.

Blocked externally (founder): RevenueCat account/project creation, Test Store offering + entitlement configuration, Test Store purchase/restore/renewal/expiry evidence, delegate-stream push updates (worth adding with the first configured key).

## Phase 2 validation results (2026-08-26)

- `cd Packages/WitnessCore && swift test` → 36 tests, 9 suites, 0 failures.
- `xcodegen generate` → project + scheme + test plan regenerated; diff inspected.
- Unsigned Debug simulator build → BUILD SUCCEEDED. Unsigned **Release** generic build → BUILD SUCCEEDED (proves the non-DEBUG composition with `UnavailablePurchaseService` compiles; no StoreKit test infrastructure in Release).
- `WitnessUITests/AccessSurfacesUITests` (fake purchase service) on iPhone 17 Pro sim → 3/3 passed: no commerce before first Witness; overview → Field Season purchase → owned state; Support tip quiet thanks without unlock language; Atlas sheet two equal durations + restore + manage.
- `WitnessAppTests/StoreKitPurchaseAdapterTests` → **environment-blocked** (see below); 3 non-mutating cases pass, 9 blocked by the iOS 26.5 SKTestSession runtime defect.
- `WitnessUITests/WitnessRitualUITests` → 2 failures, **reproduced identically on a clean HEAD (363ad14) worktree** → pre-existing host/runtime defect, not a commerce regression. Logged as open defect; spawned follow-up task chip.

## Phase 2 implementation (landed 2026-08-26)

- `Witness.storekit`: four products, one `Witness Atlas Access` group (P6M + P1Y at one level). Local test prices only.
- `Packages/WitnessCore/Sources/WitnessCore/Commerce/FileAccessRepository.swift`: atomic, versioned access cache; corrupt/future-schema cache degrades to nil. Tests in `FileAccessRepositoryTests.swift` (36 core tests total pass).
- `CommerceProduct` gained `price: Decimal?`/`currencyCode` and `pricePerMonth`; `isBetterMonthlyValue` is the only permitted basis for a `Best value` claim.
- `WitnessApp/Commerce/`: `StoreKitPurchaseAdapter` (Debug-only, `#if DEBUG`, maps subscription-group status to active/grace/billingRetry/expired/revoked), `UnavailablePurchaseService` (Release until RevenueCat), `CommerceModel` (products/snapshot/purchase/restore phases; cache-then-verify; unknown fails safe).
- `WitnessApp/Features/Access/`: shared quiet components, `FieldSeasonPreviewView`, `AtlasAccessSheet`, `SupportWitnessView`; Access section integrated into `SettingsView` (Index). No new tab; no commerce before first Witness.
- Both preview surfaces carry an explicit "in production, not yet on sale" notice so no unbuilt deliverable is promised.
- `project.yml`: `WitnessAppTests` unit-test target (StoreKitTest + bundled `.storekit`), scheme test action extended, run action carries `storeKitConfiguration` (Debug dev runs only; archives never carry it).
- Tests: `WitnessAppTests/StoreKitPurchaseAdapterTests.swift` (products, fresh state, purchase, refund, both durations equal, expiry-keeps-owned-season, tip repeatability, Ask-to-Buy pending, failure, restore both ways, unknown product); `WitnessUITests/AccessSurfacesUITests.swift` (no commerce before first Witness, overview + purchase + support flow, Atlas sheet duration parity) using the fake service.

## Completed work with dated evidence

### 2026-08-26 — Phase 0: reconcile and baseline

- D-013 recorded in `docs/DECISIONS.md` (status: proposed for approval). README and `docs/MASTER_BUILD_PROMPT.md` point at the commerce source of record. Cadence decision explicitly left open.
- Legacy conflicts identified: `Witness+`/monthly language in `PRODUCT_STRATEGY.md`, `MVP_SPEC.md`, D-004, and the abandoned `.claude/worktrees/witness-ios-app-320d04` experiment (contains `PlusEntitlements.swift`; superseded, untouched).
- Baseline: 21 pre-existing core tests passing before commerce work.

### 2026-08-26 — Phase 1: provider-neutral access domain

- Added `Packages/WitnessCore/Sources/WitnessCore/Commerce/`: `AccessModels.swift`, `ContentAccessPolicy.swift`, `PurchaseService.swift`, `WitnessProductCatalog.swift`, `FakePurchaseService.swift`.
- Added tests `ContentAccessPolicyTests.swift`, `FakePurchaseServiceTests.swift`.
- Evidence: `swift test` in `Packages/WitnessCore` — 31 tests, 8 suites, 0 failures. Grep proves no SwiftUI/StoreKit/RevenueCat/Supabase import in core. `xcodegen generate` + unsigned simulator `xcodebuild` — BUILD SUCCEEDED.
- Naming note: spec sample case `oceanEdgeSeasonOne` implemented as `fieldSeasonOne` (raw `field_season_1`) to match product/entitlement/database naming.
- Access rule proven: grace period grants Atlas access; billing retry, expired, revoked, unknown fail closed for paid content; free always authorized.

## Files and migrations changed

See git status; all work is uncommitted by design (commits need founder approval). No backend migrations exist yet.

## Test commands and exact results

- `cd Packages/WitnessCore && swift test` → 31 tests, 8 suites, 0 failures (2026-08-26).
- `xcodebuild -project Witness.xcodeproj -scheme Witness -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build` → BUILD SUCCEEDED (2026-08-26).

## External environments actually verified

None. No App Store Connect, RevenueCat, Supabase, TestFlight, or Sandbox environment exists or was touched.

## Privacy, rights, and data changes

None so far. No new SDK, network call, identifier, or stored user field.

## Environment-blocked gate: StoreKitTest on this host (2026-08-26)

`WitnessAppTests/StoreKitPurchaseAdapterTests` is written and compiles, and its non-mutating cases pass (`testFreshStateHasNoEntitlements`, `testFailedTransactionReportsFailureWithoutUnlock`, `testUnknownProductFailsClosed`). Every case that needs `SKTestSession` to serve or mutate the local store fails with `SKInternalErrorDomain Code=3` ("Error saving configuration file" at session init; `Product.products(for:)` returns []).

Root cause: a documented iOS 26.5 simulator-runtime defect — `xcodebuild test` from the CLI does not sync the `.storekit` configuration into the simulator's `storekitd`, so `SKTestSession` mutations fail. Attempted mitigations, both still failing with Code=3: attaching the config to the scheme run action, and attaching it to the test action via `Witness.xctestplan`. This host has only the iOS 26.5 runtime installed.

Unblock options (founder choice):
1. Install an older iOS simulator runtime (multi-GB download) and run the suite there.
2. Run the suite once from the Xcode IDE (Cmd+U) — the IDE path syncs the configuration; CI/CLI remains broken until Apple fixes the runtime.
3. Accept the gate as blocked-with-evidence until the RevenueCat Test Store phase provides overlapping coverage.

References: Apple Developer Forums StoreKit Test tag; flutter/flutter#184678 (same Code=3 on 26.x runtimes).

## Open defects and risks

- **Pre-existing ritual UI test flake + Dynamic Type audit finding** (open): root cause identified — the launch animation makes early synthesized taps land on stale frames (a failure screenshot showed the Witness tap opening the Specimen sheet). Partial mitigations applied (44pt header targets fixed the "hit area" audit finding; test now waits for settle/retries and follows the real witness→Notes flow) but `testDurableLocalRitualAndSharePreview` still fails later in its flow, and the audit now reports "Dynamic Type font sizes are unsupported" (fixed-size AtlasType fonts). Reproduced at clean HEAD — predates commerce work. Follow-up task chip `task_e26a5a61` carries the full diagnosis.
- Grace-period-grants / billing-retry-denies policy is codified in D-015 (proposed); founder may want the opposite for billing retry (low risk, one switch case).
- Paywall-before-content risk: production purchases must stay unavailable until Phase 7 content gates pass.
- The `Best value` badge currently renders in Debug local-store runs from test prices; production correctness depends on live prices (calculation is decimal-based and currency-guarded).

## Cadence decision resolved (2026-08-26)

Founder chose a **weekly ritual** (D-016, accepted). Implemented same day:

- `WitnessPeriodKey` produces ISO 8601 week keys (`2026-W35`), local time zone; `WeeklySpeciesSelector` replaces `DailySpeciesSelector` (folder renamed `Daily` → `Scheduling`); one Witness per species per week; `WitnessStreakCalculator` counts consecutive weeks derived from record timestamps, so legacy day-keyed records count without migration.
- `WitnessRecord.localDay` renamed to `assignedPeriod` in code with the JSON key kept as `localDay` — old archives load unchanged (proven by a legacy-archive test).
- UI copy: tab `TODAY` → `THIS WEEK` (identifiers unchanged), Cabinet badge, Witnessed/Reflection copy, and the community count line now say week. Backend needs no change (`assigned_period` was already generic).
- Evidence: core suite 47 tests, 0 failures (includes week-boundary, week-key format incl. ISO week-year edge, legacy-archive, and weekly-streak cases); app build succeeded; access + community UI suites re-run below.

## Founder approvals received 2026-08-26 (evening)

1. **Product IDs and names approved** (now D-020 in the merged decision log): `com.avp.witness.fieldseason1`, `.atlas.sixmonth`, `.atlas.annual`, `.support.once`.
2. **Launch shape confirmed**: no free trial; ONE Support tip at **$9.99 USD** (price is App Store Connect configuration, never hardcoded; the local `.storekit` test price mirrors it); subscription group display name `Witness Atlas`.
3. **Weekly cadence confirmed** (D-023).
4. Apple/RevenueCat accounts already exist with the earlier `witness_plus_monthly/annual` + `plus` entitlement + 7-day annual trial and uploaded 0.1.0 builds. These contradict the approved model → the old `Witness+` code was removed in the port; dashboard retirement of old products and creation of the new four products/entitlements/offering remains an external step to do with the founder.
5. **Commit approved** once today's work is done.
6. Requested: install the updated build on the founder's iPhone (devicectl id `6E022C55-0F6D-5809-8F16-39091774726A`).

## Base reconciliation and port (2026-08-26 evening)

Discovered local `main` was stale at 363ad14 while `origin/main` (f81b011) carried the launch app (30 approved cards, icon, uploaded 0.1.0 builds, Witness+ paywall, live Supabase counts). Actions:

- Safety branch `commerce-weekly-stale-base` (commit 6261742) preserves all stale-base work; `main` fast-forwarded to f81b011; port executed on branch `commerce-port`.
- Merged the five-choice commerce system and weekly cadence onto the real app. Decision renumbering: five choices = D-020, StoreKit harness = D-021, grace policy = D-022, weekly cadence = D-023; their D-016 (Witness+) marked superseded by D-020.
- **Witness+ removed in code**: `PlusEntitlements.swift` and `WitnessPlusPaywall.swift` deleted; Index `WITNESS+` section replaced by the ACCESS section; Cabinet ARCHIVE gate now `ArchiveAccessPolicy` (weekly: current + previous ISO week free, older requires Atlas) presenting the Atlas sheet; locked cards badge `ATLAS`.
- Weekly on the real app: `WeeklySpeciesSelector` (+ weekly `featuredHistory`/`FeaturedPlate.period`), weekly streaks, `THIS WEEK` tab/badges, weekly reminder (Mondays, weekly copy), hero tally line now `· COLLECTIVE COUNT` (their per-species total; "UPDATED TODAY" removed), Witness caption states anonymous counting honestly.
- Live counts kept: `WitnessSync`/`WitnessCounts` remain the operating backend (wire field `day` now carries the week key, making server idempotency per install/species/week without schema change). The parallel app-side CommunityModel/SupabaseCommunityService from the stale base was **dropped** to keep exactly one count system; the provider-neutral `WitnessCore/Community` outbox + the new `supabase/` schema stay as the Phase-5 target (coexisting with their `backend/` migrations until a deliberate backend consolidation).
- Evidence: merged core suite **60 tests / 14 suites, 0 failures** (their catalog/helping/sync suites + commerce/outbox/weekly/gate suites); app build SUCCEEDED with RevenueCat pinned 5.87.0; UI + mapping suites run below.

## Blockers requiring founder action

1. Retire `witness_plus_monthly`/`witness_plus_annual`/`plus`/trial in App Store Connect + RevenueCat and create the four approved products, `field_season_1_access`/`atlas_access` entitlements, and `witness_access_v1` offering (external dashboards — do together).
2. Decide the fate of the legacy `backend/` Supabase schema vs the new `supabase/` schema (deliberate consolidation phase).
3. Approvals for push/PR, signing, upload, TestFlight, or release beyond the approved commit.

## Rollback notes

- Phase 1: delete `Packages/WitnessCore/Sources/WitnessCore/Commerce/` + the two test files, rerun `xcodegen generate`.
- Phase 2 (when landed): delete `WitnessApp/Commerce/`, `WitnessApp/Features/Access/`, `Witness.storekit`, revert `project.yml` scheme/test-target changes, regenerate. User-authored data untouched in both.

## Port completion evidence (2026-08-26 evening)

- Merged suite on the launch app: 60 core tests / 14 suites, 12 RevenueCat mapping tests, 3 access UI tests, ritual durability test (passes in isolation; first-tap flake under suite load remains tracked), and the full accessibility audit — all green on iPhone 17 Pro simulator. Debug and device builds SUCCEEDED.
- Committed: `commerce-weekly-stale-base` (6261742, safety snapshot), `commerce-port` (7303b8f), merged to local `main` (148637d). **Push to origin was blocked by session permissions** — founder runs `git push origin main` or grants the permission.
- Installed and launched on the founder's iPhone 12 via devicectl (2026-08-26 ~16:58).
- Environment note: iCloud Documents sync repeatedly creates "name 2" conflict copies inside the repo (cleaned twice); recommend moving the repo out of iCloud-synced Documents or excluding it.

## Webhook doorman evidence (2026-08-26, D-024)

- Built `supabase/functions/revenuecat-webhook` + migration `20260826140000_revenuecat_ingest.sql` (`ingest_revenuecat_event`: idempotent per event ID, monotonic snapshot projection, service_role-only).
- Truth correction vs the earlier plan: RevenueCat does **not** HMAC-sign webhooks; its security model is a shared-secret `Authorization` header. Implemented constant-time secret comparison (fail-closed 503 without a ≥16-char secret) instead of fictional HMAC. Recorded as D-024.
- Verified locally against the running stack: `supabase/tests/webhook-test.sh` → **ALL WEBHOOK TESTS PASSED (28 checks)** covering: 405 on GET, 401 on missing/wrong secret, 400 on garbage JSON / future-dated event / unknown environment, TEST ping acknowledged, retired `witness_plus` product acknowledged-but-stored-nothing, valid Atlas purchase recorded once, replay reported `duplicate` with no second row, sandbox rows granting nothing under the production `has_current_entitlement`, expiration flipping access off, an older replayed grant unable to resurrect access, Field Season permanent (no expiry) with refund revocation, tip recorded in `support_events` with zero entitlement rows, and raw transaction IDs never stored (SHA-256 only).
- Existing adversarial RLS suite re-run after the migration: **ALL BACKEND TESTS PASSED**.
- Secret hygiene: `supabase/functions/.env` gitignored and confirmed ignored; production secret goes in `supabase secrets set RC_WEBHOOK_AUTH=...` and the same value in the RevenueCat dashboard webhook Authorization field. Never in the repo, the app, or chat.
- Not yet claimed: no hosted deployment, no real RevenueCat-delivered event processed (needs the dashboard reconciliation + hosted Supabase, both founder-gated).

## Field Season content evidence (2026-08-26, Phase 6 begun)

- Chapter 1 of 8 drafted: `content/field-season-1/chapter-01-vaquita.md` ("Little Cow of the Upper Gulf") — the standard-setting sample. Free record ships unchanged from the approved `vaquita.json`; the premium dossier adds 930 words (spec: 600–1,200) across field note, five-link threat chain, nine-entry evidence-backed timeline, known/unknown, one reflective prompt, nine sources, credits.
- Fact-checked 2026-08-26 against NOAA, CITES, Marine Mammal Commission, IUCN-CSG, the September 2025 survey report (7–10 individuals, 1–2 calves, three consecutive years without substantial decline), and Robinson et al. 2022 (*Science*). Every claim carries a source ID; timeline carries a last-verified date; sensitive locations stay generalized.
- Status: `draft-for-founder-review` — the frontmatter forbids shipping/selling until the founder flips it to approved. Reading edition published for review at https://claude.ai/code/artifact/247f98a6-9044-40d9-88af-265eb1370f1a (embeds the approved vaquita plate, downscaled).
- Revision 2 (founder notes 2026-08-26): warmer storytelling tone; restructured into The Past / The Present / The Future blocks (threat chain lives inside The Past, known/unknown inside The Present, odds-improving levers in The Future); dossier now 1,132 words (still under the 1,200 cap). Artifact republished at the same URL.
- Narration decided: synthetic voice via AWS Polly on the Lullable AWS account with strict separation (dedicated `witness-audio` S3 prefix, founder-run commands, credentials never in repo/chat). `content/field-season-1/audio/chapter-01-vaquita.ssml` + synthesis runbook committed; the app must disclose the synthetic voice; per-chapter audio rights record required before shipping. No "complete narrated edition" promise until every chapter has audio.

## Reader + chapter production evidence (2026-08-26 night)

- **In-app reading/listening screen SHIPPED** (commit eb4e84d): WitnessCore FieldSeason models + fail-closed loader (edition JSON bundled from the approved chapter 1; 63 core tests / 15 suites green), FieldSeasonView chapter list with honest "in production" rows, ChapterReaderView (plate, sections, timeline, prompt), ChapterAudioPlayer (AVAudioPlayer, play/pause/scrub, mandatory synthetic-voice disclosure), gated entry from the owned/included Field Season states. Proven end-to-end by new UI test (fake purchase → open edition → chapter 1 → disclosure) — 4/4 access UI tests pass; JSON + chapter-1 mp3 verified inside the built app bundle.
- **Chapter 2 drafted** (kākāpō, "Every Kākāpō Has a Name", 1,169 words, status draft-for-founder-review) from a web-verified fact pack; review artifact https://claude.ai/code/artifact/6974eeb1-5c35-494e-936e-0539ab3da660. Star fact: 2026 is the biggest kākāpō breeding season on record (95+ chicks by April, DOC/Mongabay).
- **Fact packs banked** for chapters 3 (Javan rhino) and 4 (red wolf) in `content/field-season-1/research/` — dramatic, verified, with count-conflict cautions.

## Chapter production complete-in-draft (2026-08-27)

- **All eight chapters now exist.** Approved + narrated: ch.1 vaquita (6:45), ch.2 kākāpō (7:15, audio rendered, rights filed, bundled in-app, added to edition JSON). Drafted awaiting founder review: ch.3 Javan rhino, ch.4 red wolf, ch.5 ʻalalā, ch.6 Wollemi pine, ch.7 Amur leopard, ch.8 axolotl — all to the approved Past/Present/Future template, every claim sourced from web-verified fact packs (banked in `content/field-season-1/research/`), dossiers 1,007–1,169 words (spec 600–1,200). Review binder artifact: https://claude.ai/code/artifact/cf4922d7-49ed-48f4-8af3-8fb033a3cbd9
- Core suite 63/63 green after moving the SPM scratch path outside the repo (`--scratch-path /private/tmp/witness-spm-scratch`).
- **iCloud sync is now actively corrupting builds** ("input file was modified during the build" on source and object files, three separate occurrences 2026-08-26/27; a zombie xcodebuild held the package lock for hours). Workaround in place for SPM; xcodebuild still builds from the synced tree. Escalated recommendation: move the repo out of iCloud-synced Documents, or `brctl exclude` it.
- Remaining FS1 deliverables beyond chapters: opening field letter, two system interludes, ecosystem plate, closing synthesis, field album/PDF export, return note; narration for ch.3–8 after founder approval.

## Next highest-leverage action

With the founder, retire the old Witness+ products and create the approved four products + entitlements + `witness_access_v1` offering in App Store Connect and RevenueCat, then drop a production `RevenueCatConfig.plist` into the app for the first Test Store/Sandbox purchase. Remaining Phase 5 safe local portion: the premium signed-URL authorization path. In parallel, founder decisions in the Blockers section unblock RevenueCat Test Store evidence and hosted Supabase.
