# Witness decision log

Decisions remain active until explicitly superseded. Record the reason, tradeoff, and evidence whenever one changes.

## D-001 — Native SwiftUI

- Status: proposed for approval
- Date: 2026-08-20
- Decision: Build the MVP as a native SwiftUI iPhone app targeting iOS 17+.
- Reason: Best fit for a design-led iOS experience, native sharing/notifications/accessibility, straightforward RevenueCat integration, and App Store delivery.
- Tradeoff: No Android launch during the four-week MVP.

## D-002 — Release-first four-week scope

- Status: proposed for approval
- Date: 2026-08-20
- Decision: Internal public-release target is September 17; September 18–30 is reserved for App Review recovery, traction, and submission.
- Reason: A published store app is an eligibility requirement and review can take multiple days.
- Tradeoff: Feature freeze begins in week three.

## D-003 — Public Memory Bank deferred

- Status: proposed for approval
- Date: 2026-08-20
- Decision: Reflections are private and stored on-device in v1. Public text, audio, photo, and drawing submissions are post-launch.
- Reason: Public UGC requires identity, filtering, report/block, moderation, support, privacy, and deletion operations that are too risky for a solo four-week release.
- Tradeoff: The “global archive” initially means the collective species archive and aggregate acts of witness, not a public user-comment feed.

## D-004 — Ethical free core

- Status: proposed for approval
- Date: 2026-08-20
- Decision: Today, story, sources, Witness, action, seven-day archive, basic deck, sharing, and reminders stay free. Witness+ sells depth and continuity.
- Reason: The social-good action should not be held behind a paywall; the subscription must fund ongoing value.
- Tradeoff: Monetization depends on the value of archive, narration, collections, and personalization.

## D-005 — No live IUCN API dependency

- Status: proposed for approval
- Date: 2026-08-20
- Decision: Do not use or cache IUCN Red List API data in the commercial MVP without written permission or an appropriate license.
- Reason: The API explicitly forbids commercial use and flags mobile-app use as potentially restricted.
- Tradeoff: Editorial fact-checking uses independently permitted primary sources and manual review.

## D-006 — Honest measurement

- Status: proposed for approval
- Date: 2026-08-20
- Decision: Separate attention, engagement, self-report, and partner-verified outcome metrics in product copy and submission claims.
- Reason: Witness events are meaningful but are not direct conservation outcomes.
- Tradeoff: Early impact claims will be narrower but more credible.

## D-007 — DailyArt as interaction reference, not a visual template

- Status: accepted from supplied reference set
- Date: 2026-08-20
- Decision: Use DailyArt's image-first daily ritual, overlapping editorial surface, readable long-form detail, full-screen image inspection, and visual archive as reference patterns. Build a distinct Witness identity and do not reuse or trace supplied screenshots/assets.
- Reason: The reference proves a strong one-item-per-day information hierarchy while Witness needs its own memorial, evidence, and action language.
- Tradeoff: Some familiar structural patterns remain, but brand color, typography behavior, iconography, microcopy, motion, and the Witness progression must be original.

## D-008 — Deliver value before permissions or monetization

- Status: accepted from visual-flow review
- Date: 2026-08-20
- Decision: Let a new user experience and complete the first Witness before the notification primer. Do not show Witness+ during onboarding; present it only at a premium-value boundary after the free ritual is understood.
- Reason: This better matches the trust required by a social-good product and avoids an extractive first impression.
- Tradeoff: Subscription exposure occurs later, so the archive and premium prompts must communicate value clearly.

## D-009 — Four-tab MVP information architecture

- Status: accepted from visual-flow review
- Date: 2026-08-20
- Decision: Use Today, Archive, Witnessed, and Settings. Search lives inside Archive; actions live inside species stories.
- Reason: It preserves DailyArt's clear navigation model while removing redundant destinations and keeping the core ritual dominant.
- Tradeoff: Advanced discovery and standalone action browsing are deferred.

## D-010 — Atlas three-destination presentation

- Status: accepted from the approved Atlas redesign handoff
- Date: 2026-08-21
- Decision: The current presentation uses custom Today, Cabinet, and Notes destinations. Settings lives behind the Contents mark as an Index sheet; species evidence opens from Today and Cabinet rather than becoming a fourth destination.
- Reason: This preserves a quiet, plate-like ritual and gives the private deck more semantic weight without adding navigation chrome.
- Tradeoff: Existing four-tab planning language is superseded for the current UI. Reminder, purchase, legal, and support settings must remain reachable through Index and be re-evaluated before release if their volume outgrows that surface.

## D-011 — Core-first repository boundary and CI

- Status: accepted
- Date: 2026-08-22
- Decision: `WitnessCore` owns stable models, catalog validation, deterministic daily assignment, local persistence, streaks, and provider-neutral share copy. `WitnessApp` owns SwiftUI presentation, platform composition, and future concrete adapters. GitHub Actions runs core tests and an unsigned iOS build on every pull request and push to `main`.
- Reason: The offline ritual stays testable and provider-independent while future backend, RevenueCat, notifications, and analytics integrations can be introduced behind narrow protocols.
- Tradeoff: A provider SDK cannot be imported directly into core or feature views; initial integration work includes an adapter and tests.

## D-012 — Public repository content boundary

- Status: accepted
- Date: 2026-08-22
- Decision: The public repository excludes DailyArt research assets, local temporary artifacts, signing material, secrets, device archives, and unverified production media. Dated product evidence and rights records may be tracked when they are safe to publish.
- Reason: Public version control must improve collaboration without redistributing reference assets, exposing credentials, or implying unverified content readiness.
- Tradeoff: A contributor needs local access to excluded research and signing material; those files are never restored from Git.
