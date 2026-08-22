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

## Pull-request standard

- State the vertical outcome, assumptions, affected files, validation result, unverified gates, and rollback.
- Add or update deterministic tests with domain behavior changes.
- Keep UI changes accessible in Dynamic Type, VoiceOver, reduced motion, light/dark appearances, and offline states.
- Do not claim conservation outcomes for Witness events, shares, or action opens.
