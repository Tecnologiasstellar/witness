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

## D-013 — Five engagement choices, three authorization facts

- Status: proposed for approval
- Date: 2026-08-26
- Decision: Offer exactly five user-facing engagement choices: free Witness access, permanent Field Season access, Atlas for six months, Atlas annually, and a consumable Support Witness tip. Implement only permanent Field Season ownership and one shared Atlas entitlement; free access is the default and Support grants no entitlement. Both Atlas products provide identical access at the same subscription level and differ only by billing duration and price.
- Reason: This preserves the complete ethical free ritual, gives users a non-subscription purchase and a continuing membership, and prevents five commercial choices from becoming five confusing user ranks or a generic tier engine.
- Tradeoff: Field Season and Atlas require especially clear permanent-versus-active access copy, while the Support program cannot use access, badges, or status as a conversion incentive.
- Source of record: `docs/ACCESS_AND_COMMERCE_SOURCE_OF_RECORD.md` supersedes older `Witness+`, monthly-subscription, trial, and premium-packaging language wherever it conflicts. The content release cadence remains a separate unresolved decision and must not be changed implicitly during commerce work.

## D-014 — Debug-only local StoreKit harness behind PurchaseService

- Status: accepted for the commerce build phase
- Date: 2026-08-26
- Decision: The local `Witness.storekit` configuration and a `#if DEBUG` StoreKit 2 adapter (`StoreKitPurchaseAdapter`) provide deterministic purchase execution for development, StoreKitTest automation, and UI states. Release builds compile `UnavailablePurchaseService`, which purchases nothing and invents no price, until the RevenueCat production adapter lands. Verified access snapshots are cached locally by `FileAccessRepository` so entitled content works offline; the cache is presentation input, never authorization proof, and unknown or corrupt state degrades to the default free snapshot.
- Reason: Every purchase state can be exercised and regression-tested locally before any external account exists, while structurally guaranteeing that no test store path can ship in Release.
- Tradeoff: Two purchase-execution paths exist during the build phase; the Debug harness must remain behaviorally honest (no optimistic unlock) so it does not mask production-adapter defects.

## D-016 — Weekly ritual cadence

- Status: accepted by founder
- Date: 2026-08-26
- Decision: The ritual is weekly, not daily. One species card is featured per ISO 8601 week (Monday start, evaluated in the user's local time zone). A person can Witness each featured species once per week; the collective aggregate, streak, and reminder logic count weeks. The assigned period key format is `YYYY-Www` (for example `2026-W35`).
- Reason: Founder decision 2026-08-26. A weekly rhythm matches a sustainable solo editorial cadence — one deeply produced species per week beats seven thin ones — and gives every species a full week of collective attention.
- Tradeoff: Fewer ritual touchpoints per user per month; streaks accrue slowly (a 4-streak means a month of attention). Existing day-keyed local records remain valid history; weekly streaks are derived from record timestamps so no migration or data loss occurs.
- Supersedes: daily-cadence language in `PRODUCT_STRATEGY.md`, `MVP_SPEC.md`, `AGENTS.md`, `README.md`, and earlier scheduling code (`DailySpeciesSelector`) wherever they conflict. The backend schema already uses a generic `assigned_period` key and needs no migration.

## D-015 — Grace period grants Atlas access; billing retry does not

- Status: proposed for approval
- Date: 2026-08-26
- Decision: `StandardContentAccessPolicy` treats an Atlas subscription in Apple's grace period as access-granting and a billing-retry period after grace as access-denying. Expired, revoked, inactive, and unknown states deny paid access. Free content is always authorized regardless of provider state.
- Reason: Grace period is Apple's mechanism for continuing service while payment recovers; denying during it punishes a paying member for a card hiccup. Billing retry after grace means the paid period genuinely lapsed.
- Tradeoff: A founder preference for more or less leniency in billing retry requires changing one policy case and its tests.
