# Contributing to Witness

## Before opening a change

1. Read `AGENTS.md`, [architecture](docs/ARCHITECTURE.md), the relevant product document, and the release gates.
2. Keep product facts, action links, media, and visual references within the rights and provenance rules in `docs/CONTENT_TRUST_AND_RIGHTS.md`.
3. Do not add DailyArt reference assets, signing material, secrets, or local user data to Git.

## Local checks

```sh
xcodebuild -project Witness.xcodeproj -scheme Witness -destination 'generic/platform=iOS' CODE_SIGNING_ALLOWED=NO build
cd Packages/WitnessCore && swift test
```

Use a temporary DerivedData or SwiftPM cache path when your environment restricts the defaults. A successful local build is not evidence of physical-device, Sandbox purchase, backend, or App Store readiness.

## Run in the simulator with debug flags

The four launch flags below are `#if DEBUG` only. The UI tests set them through `launchEnvironment`; from the command line, prefix each with `SIMCTL_CHILD_` after building for a booted simulator:

```sh
SIMCTL_CHILD_WITNESS_COMMERCE=fake \
SIMCTL_CHILD_WITNESS_FORCE_SPECIES=kakapo \
SIMCTL_CHILD_WITNESS_ONBOARDING=force \
xcrun simctl launch --console booted com.avp.witness
```

| Flag | Values | Effect |
|---|---|---|
| `WITNESS_TEST_ARCHIVE` | any name | Redirects the witness archive, helping store and access cache into per-run files under `Application Support/WitnessUITests/`; also marks onboarding as seen unless `WITNESS_ONBOARDING` says otherwise. |
| `WITNESS_COMMERCE` | `fake` | Deterministic `FakePurchaseService` instead of StoreKit/RevenueCat. Anything else falls through to RevenueCat (if a key is configured), then the StoreKit adapter. Note: `Witness.storekit` only attaches through the Xcode scheme, so a `simctl`-launched build without this flag hits the real sandbox. |
| `WITNESS_FORCE_SPECIES` | a catalog `id` | Pins the featured card to that species instead of the ISO-week rotation (also honored on foreground refresh). |
| `WITNESS_ONBOARDING` | `force` / `real` | `force` resets first-run state (onboarding flag and reminder primer) so the introduction renders fresh; `real` honors the stored flag. |

## Card drafts outside the bundle

New cards are staged in `content/cards/drafts/` until they have five plates and founder approval, so the bundle, the catalog count test and the production gate stay untouched. Check a draft with:

```sh
python3 tools/validate_card.py content/cards/drafts/<id>.json
python3 tools/check_links.py --all --dir content/cards/drafts --only <id>
```

## Pull-request standard

- State the vertical outcome, assumptions, affected files, validation result, unverified gates, and rollback.
- Add or update deterministic tests with domain behavior changes.
- Keep UI changes accessible in Dynamic Type, VoiceOver, reduced motion, light/dark appearances, and offline states.
- Do not claim conservation outcomes for Witness events, shares, or action opens.
