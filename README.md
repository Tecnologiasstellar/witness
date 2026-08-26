# Witness

> Each week, witness one species on the edge of disappearance—and join a global archive of memory and action.

Witness is a native iOS weekly ritual about threatened and extinct species. In one or two minutes, a person meets the week’s species, reads a short sourced story, records an act of witness, and is offered one credible action.

The immediate goal is to publish a working App Store MVP and compete for first place in the RevenueCat Shipathon 2026 Peace Prize.

## Product promise

- One species. No feed and no decision fatigue.
- Beauty that earns attention without turning extinction into spectacle.
- Every factual claim and visual has traceable provenance.
- A witness count measures attention, not conservation impact.
- A concrete action closes the loop without guilt or false promises.
- The weekly experience remains free. Paid features support depth and continuity.

## Current status

Weekend Zero local ritual is implemented: an iOS 17 SwiftUI project, schema-validated bundled Vaquita prototype record, Atlas Today/Cabinet/Notes presentation, idempotent on-device Witness persistence, restored Witnessed plate, private reflection, streak logic, and original share preview. The app is offline-first and has no production hosted service. Build and device-install evidence is recorded in [Implementation status](docs/IMPLEMENTATION_STATUS.md); release gates remain open until they have dated production evidence.

Build the checked-in Xcode project:

```sh
xcodebuild -project Witness.xcodeproj -scheme Witness -destination 'generic/platform=iOS' CODE_SIGNING_ALLOWED=NO build
```

`project.yml` is the editable project specification. Run `xcodegen generate --spec project.yml` after changing targets, source paths, build settings, or schemes, then inspect the generated project diff.

Run the domain tests:

```sh
cd Packages/WitnessCore
swift test
```

## Canonical documents

- [Access and commerce source of record](docs/ACCESS_AND_COMMERCE_SOURCE_OF_RECORD.md)
- [Long-haul paid-elements execution prompt](docs/LONG_HAUL_PAID_ELEMENTS_EXECUTION_PROMPT.md)
- [Product strategy](docs/PRODUCT_STRATEGY.md)
- [MVP specification](docs/MVP_SPEC.md)
- [Four-week execution plan](docs/FOUR_WEEK_EXECUTION_PLAN.md)
- [Competition and release gates](docs/COMPETITION_AND_RELEASE_GATES.md)
- [Content, trust, and rights policy](docs/CONTENT_TRUST_AND_RIGHTS.md)
- [DailyArt visual-reference audit](docs/VISUAL_REFERENCE_AUDIT.md)
- [Design-system brief and Claude Design prompt](docs/DESIGN_SYSTEM_BRIEF_AND_CLAUDE_PROMPT.md)
- [Master build prompt](docs/MASTER_BUILD_PROMPT.md)
- [Decision log](docs/DECISIONS.md)
- [Architecture](docs/ARCHITECTURE.md)
- [Contribution guide](CONTRIBUTING.md)
- [Implementation status](docs/IMPLEMENTATION_STATUS.md)

## Target dates

- Build start: August 21, 2026
- Internal release candidate: September 14, 2026
- App Store submission: September 15, 2026
- Internal public-release target: September 17, 2026
- Shipathon deadline: September 30, 2026 at 11:45 p.m. PDT

The gap between September 17 and September 30 is a review, repair, release, traction, and submission buffer—not planned feature time.
