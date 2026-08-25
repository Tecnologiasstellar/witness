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

## D-013 — Higgsfield-generated original artwork is the sole visual source

- Status: accepted (owner direction, 2026-08-22)
- Date: 2026-08-22
- Decision: All species artwork and animal cards are generated with the owner's Higgsfield.ai account under one locked style-prompt template. Each asset gets a rights record with state `ai_generated_owned` including the generation prompt, model, date, and account. The app discloses artwork as original illustration; it is never presented as documentary photography. Every asset must pass a basic species-accuracy review before production use.
- Reason: One controlled generation source gives consistent visual identity, unlimited coverage of species with no usable photography, and a clean commercial-rights story without per-file Commons license archaeology.
- Tradeoff: Depends on the accuracy review to prevent plausible-but-wrong depictions. Open verification item: confirm the active Higgsfield plan grants commercial usage rights for generated output before App Store submission.

## D-014 — 100-species backlog, 30 launch-ready cards

- Status: accepted
- Date: 2026-08-22
- Decision: The editorial backlog defines at least 100 endangered or extinct species (`docs/SPECIES_BACKLOG.md`, all facts marked unverified until carded). The v1 App Store build ships with 30 fully reviewed production cards — a month of daily ritual. Remaining species are produced post-launch through the card pipeline (D-019).
- Reason: 100 reviewed cards before September 15 is not achievable by one person at the required trust bar; 30 covers the launch window with margin, and the backlog removes selection work from the production loop.
- Tradeoff: Early adopters exhaust novel content after ~30 days if post-launch production stalls.

## D-015 — Supabase is the only backend; catalog stays bundled in v1

- Status: accepted
- Date: 2026-08-22
- Decision: Supabase (free tier) provides the entire backend: an idempotent `witness_events` table keyed by `(install_id, species_id, day)`, an aggregate per-species count view exposed read-only, and a plain `events` analytics table. No user accounts in v1 — an anonymous install UUID generated on first launch identifies a device. The species catalog remains bundled in the app binary and ships via app updates; remote catalog delivery is deferred until post-launch publishing cadence demands it.
- Reason: Smallest system that yields honest global witness counts and measurable behavior. Accounts add auth, deletion, and support obligations with no v1 payoff; the App Store already delivers content updates.
- Tradeoff: New cards require an app release in v1. Count sync needs an offline queue with honest "count unavailable" states. Cost: $0/mo at launch scale; failure mode is stale or unavailable counts, never a blocked ritual.

## D-016 — Witness+ paywall logic

- Status: accepted
- Date: 2026-08-22
- Decision: Free forever: today's ritual, story, sources, action, witness, streak, private reflection, share card, reminders, and the last 7 days of the archive. Witness+ (RevenueCat entitlement `plus`): the full archive and complete Cabinet back to day one, plus future depth features (narration, collections). Products: monthly at USD 2.99 and annual at USD 19.99 with a 7-day free trial on annual. The paywall appears only at the premium boundary — tapping into archive content older than 7 days — never during onboarding (per D-008). Restore purchases is always reachable from the Index.
- Reason: Depth-and-continuity is the honest thing to sell; the social-good core stays free per D-004. Annual-with-trial is the primary offer because a daily ritual's value compounds.
- Tradeoff: Revenue depends on archive value, so archive presentation quality is monetization work. Prices adjust later in App Store Connect without code changes.

## D-017 — Analytics is a plain events table

- Status: accepted
- Date: 2026-08-22
- Decision: Product analytics is the Supabase `events` table (`name`, `install_id`, `metadata`, `timestamp`) written from a small client queue, plus RevenueCat's built-in purchase metrics. No third-party analytics SDK. Launch event vocabulary: `ritual_completed`, `witness_recorded`, `action_opened`, `reflection_saved`, `share_created`, `paywall_shown`, `trial_started`, `archive_opened`.
- Reason: One table answers the launch questions (return rate, ritual completion, action opens, conversion) at $0 with a truthful privacy label.
- Tradeoff: Charts are SQL, not dashboards. Event writes must never block or degrade the offline ritual.

## D-018 — Staging and production environments

- Status: accepted
- Date: 2026-08-22
- Decision: Two Supabase projects, `witness-staging` and `witness-prod`. Debug and simulator builds target staging; TestFlight and App Store builds target production. The Supabase URL and anon key are injected per build configuration via xcconfig (anon keys are publishable; the service-role key never leaves the Supabase dashboard and never enters the repo or app). Schema migrations live as ordered SQL files in `backend/migrations/`, are applied to staging first, verified, then applied to production; destructive migrations record their rollback command.
- Reason: Real purchase and sync testing must not pollute production counts, and prod schema changes need a rehearsal target. Two free-tier projects cost $0.
- Tradeoff: Two dashboards to manage and a small config seam in the app.

## D-019 — Card production pipeline

- Status: accepted
- Date: 2026-08-22
- Decision: Every animal card is produced through the fixed pipeline in `docs/CARD_PRODUCTION_PIPELINE.md`: backlog selection → sourced research → schema-valid JSON record → Higgsfield artwork with rights record → species-accuracy review → editorial review → `CatalogValidator` in CI → merge → ship in the next release. A card that fails any stage stays in `prototype`/`draft` state and is rejected by production validation.
- Reason: Content is product infrastructure (per the trust policy); a fixed pipeline makes 100+ cards producible by one person at a constant quality bar.
- Tradeoff: Throughput is bounded by review honesty — roughly 3–5 cards per focused day, which the 30-card launch scope respects.
