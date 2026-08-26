# Witness project instructions

## Mission

Build and publish the smallest exceptional native iOS app that can credibly win the RevenueCat Shipathon 2026 Peace Prize on impact and feasibility.

## Product invariant

The core loop is: meet one species -> read a short sourced story -> tap Witness -> see an honest collective count -> take one credible action -> optionally share.

## Working principles

- Lead with a working vertical slice and evidence, not a broad unfinished feature set.
- Use native SwiftUI unless a recorded decision changes the stack.
- Preserve a quiet, memorial, editorial tone. Do not use fear, guilt, tragedy porn, manipulative urgency, competitive leaderboards, or fabricated scarcity.
- The weekly featured species, sourced story, Witness action, and conservation action remain free (weekly cadence per D-016).
- Never describe witness counts, shares, streaks, link opens, or self-reported actions as conservation outcomes.
- Every species fact, status, story claim, action link, and media asset must have provenance, review status, and a last-verified date.
- Never copy IUCN Red List API data into a commercial app without an appropriate license or written permission. A citation is not a license.
- Never ship an image whose commercial reuse terms and required attribution have not been verified per file.
- Treat `DailyArt ios Jan 2025/` as visual-flow research only. Do not ship, crop, trace, redistribute, or present any DailyArt/Mobbin screenshot or asset as Witness work.
- Do not expose exact sensitive-species locations.
- Public user-generated memories are out of MVP scope. Private on-device reflections are allowed.
- Avoid account creation in v1. Use a privacy-preserving installation identifier only if the backend requires idempotency.
- Keep secrets out of source control. Release builds must never contain sandbox or test-store keys.
- External writes, hosted data mutations, App Store releases, purchases, account changes, and public posts require explicit approval.

## Engineering guardrails

- Minimum target: iOS 17; primary target: iPhone.
- Separate stable domain models and repositories from SwiftUI presentation.
- Use dependency-injected protocols for clock/date, catalog, witness events, notification scheduling, purchases, and analytics.
- Bundle a reviewed launch catalog so the weekly ritual works offline. Remote services enhance counts and content but must not blank the core experience.
- Model witness submission as an idempotent event. The client must not increment counters optimistically without reconciling the server response.
- Keep RevenueCat entitlement logic behind a purchase service. Treat UI state as presentation, not authorization.
- Accessibility, reduced motion, Dynamic Type, VoiceOver labels, contrast, and graceful offline states are release requirements.
- Prefer deterministic unit tests for date assignment, streaks, entitlements, catalog validation, and witness idempotency.
- Keep simulator/build validation separate from physical-device, Sandbox purchase, backend, and App Store evidence.

## Required delivery format for changes

For each meaningful change, report:

1. Outcome.
2. Files changed.
3. Validation run and exact result.
4. Known gaps or unverified gates.
5. Safest next action.

Do not call the app production-ready until every release blocker in `docs/COMPETITION_AND_RELEASE_GATES.md` has evidence.

Before implementing or reviewing presentation work, read `docs/VISUAL_REFERENCE_AUDIT.md` and inspect the relevant source screenshots at full size. Preserve the Witness-specific adaptations and anti-copy boundaries recorded there.
