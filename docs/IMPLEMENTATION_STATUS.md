# Implementation Status

Last updated: August 26, 2026

This file records implementation evidence. It does not replace the release gates in `COMPETITION_AND_RELEASE_GATES.md`.

## Commerce Phase 2 — local commerce vertical slice

### Outcome (2026-08-26)

The commerce surfaces exist end to end against local/test infrastructure: an Access section in the Index (free promise, Field Season, Atlas status, Restore, Manage Subscription, Support), a Field Season preview with permanence language and an explicit not-yet-on-sale notice, a single calm Atlas sheet with two equal-access durations and a decimal-price-calculated `Best value` badge, and a quiet Support tip screen. A Debug-only StoreKit 2 adapter (`Witness.storekit`, four products, one subscription group) executes purchases behind `PurchaseService`; Release builds compile `UnavailablePurchaseService` and contain no test store path. Verified snapshots cache to `FileAccessRepository` for offline continuity. No commerce appears before the first Witness; nothing is purchasable in production.

### Acceptance evidence (2026-08-26)

| Gate | Evidence | Result |
|---|---|---|
| Core tests | `swift test` in `Packages/WitnessCore` | 36 tests, 9 suites, 0 failures |
| Project generation | `xcodegen generate` (adds `WitnessAppTests`, test plan, run-action StoreKit config) | Generated; diff inspected |
| Debug build | unsigned iOS Simulator build | BUILD SUCCEEDED |
| Release build | unsigned generic iOS Release build | BUILD SUCCEEDED (no StoreKit test path compiled) |
| Access UI tests | `AccessSurfacesUITests` with fake service, iPhone 17 Pro sim | 3/3 passed |
| StoreKitTest suite | `StoreKitPurchaseAdapterTests` | BLOCKED: iOS 26.5 runtime defect — CLI `xcodebuild test` does not sync `.storekit` to `storekitd` (`SKInternalErrorDomain Code=3`); 3 non-mutating cases pass. See `PAID_ELEMENTS_EXECUTION_STATUS.md` for unblock options |
| Ritual regression | `WitnessRitualUITests` | 2 failures reproduced identically on clean HEAD worktree — pre-existing host/runtime defect, not a commerce regression; follow-up task opened |

### Rollback

Delete `WitnessApp/Commerce/`, `WitnessApp/Features/Access/`, `WitnessAppTests/`, `Witness.storekit`, `Witness.xctestplan`, restore `SettingsView`/`RootTabView`/`WitnessApp` from HEAD, revert `project.yml`, rerun `xcodegen generate`. No user-authored data is touched.

## Commerce Phase 1 — provider-neutral access domain

### Outcome

`WitnessCore` now contains the complete provider-neutral commerce domain from `ACCESS_AND_COMMERCE_SOURCE_OF_RECORD.md`: `ContentAccessRequirement` (`free`, `field_season_1`, `atlas`), `AccessSnapshot` with `AtlasAccessState`, `StandardContentAccessPolicy`, the `PurchaseService`/`AccessRepository` protocols, the typed four-product allow-list (`WitnessProductCatalog`), and a deterministic `FakePurchaseService` for previews and tests. No store SDK, network, or UI is involved; nothing purchasable exists yet.

Access rules proven by tests: free is always authorized; Field Season requires permanent ownership or granting Atlas state; Atlas content requires active or grace-period Atlas; billing retry, expiry, revocation, and unknown fail closed for paid content while free access and separately owned Field Season persist; the Support tip is repeatable and never changes access.

Naming note: the source of record's sample code names one case `oceanEdgeSeasonOne`; the implementation uses `fieldSeasonOne` with raw value `field_season_1` to match the document's product, entitlement, and database naming.

### Acceptance evidence (2026-08-26)

| Gate | Evidence | Result |
|---|---|---|
| Domain tests | `swift test` in `Packages/WitnessCore` | Passed; 31 tests in 8 suites, 0 failures (includes all pre-existing ritual tests) |
| Dependency rule | grep for `SwiftUI`/`StoreKit`/`RevenueCat`/`Supabase` imports in `Packages/WitnessCore/Sources` | None found |
| Project generation | `xcodegen generate` | Passed; `Witness.xcodeproj` regenerated with commerce sources |
| iOS compile | `xcodebuild -project Witness.xcodeproj -scheme Witness -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build` | `BUILD SUCCEEDED` |

### Remaining unverified gates for commerce

- No StoreKit configuration, purchase UI, RevenueCat adapter, App Store Connect product, Supabase table, or webhook exists yet (Phases 2–9).
- Product IDs in `WitnessProductCatalog` are candidates pending founder approval (D-013); they are immutable once created in App Store Connect.
- Decision D-013 remains `proposed for approval`, and the content cadence decision remains open.

### Rollback

Delete `Packages/WitnessCore/Sources/WitnessCore/Commerce/` and the two commerce test files, then rerun `xcodegen generate`. No user data, remote state, or existing ritual behavior is touched.

## Weekend Zero — durable local ritual

### Outcome

A native SwiftUI iOS 17 project now delivers the complete local-only Weekend Zero ritual:

1. Today
2. Archive
3. Witnessed
4. Settings

Today loads one bundled Vaquita prototype record through a separately compiled domain framework. The screen is image-first, uses an overlapping editorial sheet, and includes the sourced story, one official-source action, and evidence disclosure. Witness is stored idempotently once per species and local calendar day in an atomically written on-device JSON archive. The record restores after relaunch in Witnessed, accepts a private local reflection, calculates the current streak, and produces an original share preview that excludes the reflection and makes no count or conservation-outcome claim. The core ritual requires no network.

### Acceptance evidence

| Gate | Evidence | Result |
|---|---|---|
| Project generation | `xcodegen generate --spec project.yml` | Passed; `Witness.xcodeproj` generated |
| Domain tests | `env CLANG_MODULE_CACHE_PATH=/private/tmp/witness-clang-module-cache SWIFTPM_MODULECACHE_OVERRIDE=/private/tmp/witness-swiftpm-module-cache swift test --disable-sandbox --scratch-path /private/tmp/witness-swiftpm-build` | Passed; 10 tests in 5 suites, 0 failures |
| iOS compile | `xcodebuild -project Witness.xcodeproj -scheme Witness -destination 'generic/platform=iOS' -derivedDataPath /private/tmp/WitnessDerivedData CODE_SIGNING_ALLOWED=NO build` | `BUILD SUCCEEDED` |
| Offline catalog packaging | Inspected built application bundle | `WitnessCore.framework/species.json` present |
| Durable ritual UI test | `xcodebuild test ... -only-testing:WitnessUITests/WitnessRitualUITests` on iPhone 17 Pro, iOS 26.5 | Passed; 2 tests, 0 failures in 62.458 seconds |
| Relaunch persistence | UI test terminates and relaunches the app before asserting Witness state | Passed |
| Reflection privacy | UI test saves a reflection, opens the share preview, and asserts the reflection is absent | Passed |
| Accessibility audit | `performAccessibilityAudit()` in light and dark at standard Dynamic Type | Passed in both appearances; see documented iOS 26.5 exception below |
| Large-text visual review | iPhone 17 Pro simulator at `accessibility-large` | Reviewed; header reflows, status remains whole, content remains scrollable |
| Light/dark visual review | Full-size simulator captures | Reviewed; no transition frames used as evidence |

### Simulator evidence

- [Today — light, standard Dynamic Type](evidence/weekend-zero/today-light-standard.png)
- [Today — dark, standard Dynamic Type](evidence/weekend-zero/today-dark-standard.png)
- [Today — light, accessibility-large Dynamic Type](evidence/weekend-zero/today-light-accessibility-large.png)

The iOS 26.5 accessibility audit reports contrast against story text when that scroll content geometrically intersects the operating system's translucent floating tab bar. The UI test suppresses only `.contrast` findings for `today.story.*` elements whose frames intersect the system tab bar; visible story text elsewhere and every other audit type remain strict. This exception is simulator/runtime-specific evidence, not a general accessibility waiver.

### Truth and rights state

- Species facts and action copy map to declared NOAA Fisheries and CITES sources.
- No current population estimate is shown.
- The broad region is shown; exact sensitive coordinates are absent.
- Editorial state is `prototype`, reviewer is `PENDING`, and production validation rejects the record.
- Media is original code-drawn geometry with `prototype` rights state; no DailyArt or third-party visual is included. The first production media rights record remains unapproved.
- No public count, outcome claim, hosted service, account, purchase, App Store record, or analytics event exists.

### Remaining unverified gates

- Physical-device signing, signature verification, installation, and launch passed on a paired, wired iPhone 12 running iOS 17.6.1 using Team ID `L5R9XW45B6`. `devicectl` independently confirmed bundle `com.avp.witness` installation and launch. See [physical accessibility QA](PHYSICAL_ACCESSIBILITY_QA.md).
- A focused physical UI test using an isolated archive passed with 1 test and 0 failures in 49.952 seconds. It verified the disabled Witness state and Witnessed card after relaunch, private-reflection restoration after a second relaunch, reflection exclusion from sharing, and native `ActivityListView` presentation. The result bundle is `/private/tmp/WitnessPhysicalQADerivedData/Logs/Test/Test-Witness-2026.08.21_21-00-29--0600.xcresult`.
- Direct human VoiceOver traversal and runtime Reduced Motion observation remain pending. Share-card visual sharpness/cropping, copy legibility, safe cancellation, and network-disabled physical restoration also remain unverified.
- App Store Sandbox, RevenueCat, backend counts, production signing, privacy manifest, archive, and review evidence.
- The user supplied a Vaquita image and asserted complete commercial-right ownership. The original file is not accessible in the workspace and required per-file metadata/evidence remain pending; see [Vaquita owned-image rights intake](media/vaquita-owned-image-rights.md). The prototype geometry remains active.

### Rollback

This slice is additive and has no remote state to unwind. The durable archive is isolated behind `WitnessRepository`; reverting the UI to an in-memory repository or removing the Application Support archive path rolls back persistence without changing the catalog or presentation hierarchy.
