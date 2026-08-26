# Witness architecture

Last updated: 2026-08-22

## Intent

Witness is an offline-first native iOS application. The repository is deliberately structured so that the weekly ritual works from a reviewed bundled catalog, while future hosted counts, purchases, reminders, and analytics can be introduced behind explicit interfaces without destabilizing the core experience.

## Dependency rule

`WitnessApp` may depend on `WitnessCore`. `WitnessCore` must not depend on SwiftUI, StoreKit, RevenueCat, a backend SDK, or a particular analytics provider.

```text
WitnessApp (composition, SwiftUI, platform adapters)
        ↓
WitnessCore (domain contracts, catalog, local ritual logic, tests)
        ↓
Foundation / system APIs only where a local repository needs them
```

No hosted service is part of the current runtime. A remote failure must never make Today blank or invalidate a completed local Witness.

## Repository map

| Path | Responsibility | May depend on |
|---|---|---|
| `WitnessApp/App` | App composition root, dependency assembly, root navigation, observable presentation state | `WitnessCore`, SwiftUI, platform frameworks |
| `WitnessApp/DesignSystem` | Atlas tokens, type, icon marks, paper/plate primitives | SwiftUI only |
| `WitnessApp/Features` | Feature views and presentation-only mappings | `WitnessCore`, design system, SwiftUI |
| `Packages/WitnessCore/Models` | Stable species, action, source, media, and Witness-event value types | Foundation |
| `Packages/WitnessCore/Catalog` | Bundled catalog loading and fail-closed validation | Models, Foundation |
| `Packages/WitnessCore/Scheduling` | Deterministic weekly assignment policy (D-016) | Models, Foundation |
| `Packages/WitnessCore/Persistence` | Local records, reflection limits, idempotency, and repository protocol | Models, Foundation |
| `Packages/WitnessCore/Streak` | Pure streak calculation | Models, Foundation |
| `Packages/WitnessCore/Sharing` | Truthful, provider-neutral share copy | Models, Foundation |
| `Packages/WitnessCore/Tests` | Deterministic unit tests for domain behavior | `WitnessCore` |
| `WitnessUITests` | End-to-end local ritual and accessibility coverage | App target |
| `docs` | Product decisions, release gates, rights records, and dated evidence | No runtime dependency |
| `.github` | Continuous integration and contribution guardrails | Repository files only |

## Composition and future seams

The app composition root owns concrete implementations. Feature views receive observable state and actions; stable core models stay free of presentation formatting.

When a capability is introduced, add a narrow protocol before adding an SDK:

| Future capability | Contract boundary | Rule |
|---|---|---|
| Remote witness aggregation | `WitnessEventService` | Submit idempotently; the server response, not optimistic UI, determines the collective count. |
| Remote catalog updates | `CatalogRepository` | Validate remotely supplied records before replacing a retained bundled fallback. |
| Notifications | `NotificationScheduler` | Ask only after a completed first ritual and persist intent locally. |
| Purchases | `PurchaseService` | RevenueCat stays behind the service; Release cannot use Test Store keys. |
| Analytics | `AnalyticsService` | Track only documented, privacy-respecting funnel events; never infer outcomes. |

Do not add those SDKs, credentials, or hosted configuration until their respective product and release gates are scheduled. Protocols should arrive with the first concrete use case and deterministic tests, not as empty scaffolding.

## Content and privacy boundaries

- Bundled content is a reviewed offline fallback, never an unverified cache.
- Every production media asset needs a per-file rights record. The current abstract specimen drawing remains a prototype and is intentionally not documentary media.
- Exact sensitive-species coordinates, DailyArt research assets, signing material, secrets, simulator output, and private local archives are excluded from Git.
- Private reflections remain on-device in v1. Public user-generated content and accounts are out of scope.

## Project generation and CI

`project.yml` is the editable Xcode project specification. `Witness.xcodeproj` is checked in so a fresh clone can build without requiring XcodeGen first.

Whenever target, source-path, build-setting, or scheme configuration changes:

1. Update `project.yml`.
2. Run `xcodegen generate --spec project.yml` locally when XcodeGen is available.
3. Inspect the resulting project diff.
4. Build the app and run the focused tests.

GitHub Actions verifies the core package and an unsigned iOS build. It does not prove simulator behavior, physical-device behavior, signing, rights, hosted services, or App Store readiness.

## Change rules

- Keep domain changes additive and covered by deterministic tests.
- Keep feature-specific presentation types in the feature folder, not in stable core models.
- Avoid a global service locator; assemble dependencies at `WitnessApp/App`.
- Never commit generated content, credentials, DailyArt reference material, or unverified media.
- Update `docs/DECISIONS.md` before superseding an accepted product or architecture decision.
