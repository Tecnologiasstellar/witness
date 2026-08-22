# Implementation Status

Last updated: August 21, 2026

This file records implementation evidence. It does not replace the release gates in `COMPETITION_AND_RELEASE_GATES.md`.

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
