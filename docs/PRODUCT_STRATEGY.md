# Witness product strategy

Last updated: 2026-08-20

## Goal

Publish a beautiful, trustworthy, repeatable iOS ritual that produces measurable attention and credible action for threatened and extinct species, and submit it as the strongest feasible candidate for first place in the RevenueCat Shipathon 2026 Peace Prize.

## Assumptions

- One solo founder and Codex will build the MVP over four focused weeks.
- A paid Apple Developer account and control of App Store Connect are available or can be made available immediately.
- RevenueCat and backend accounts can be created during week one.
- English is the launch language. Localization follows after the first public release unless it fits without jeopardizing the release gate.
- A sustainable content cadence is more important than a large launch catalog.
- The app is commercial because it contains an in-app purchase; noncommercial data and media licenses therefore cannot be assumed to fit.

## Recommended approach

### Positioning

Witness is not an encyclopedia, donation marketplace, social network, or doom feed. It is a one-minute daily act of attention that turns a distant biodiversity crisis into a specific relationship with one living—or lost—species.

### The winning loop

1. **Meet:** one full-screen species portrait and one unforgettable line.
2. **Understand:** a 45–75 second editorial story with an evidence drawer.
3. **Witness:** one deliberate press records attention once per species/day.
4. **Join:** the app returns a real, deduplicated collective witness count.
5. **Act:** one source-backed, achievable action opens in context.
6. **Remember:** the card enters a private Witness Deck and may include a local reflection.
7. **Carry:** a rights-safe share card spreads the species, source, and app.

### Experience model

DailyArt is the primary reference for pacing and information hierarchy: a single dominant image, an overlapping editorial sheet, restrained navigation, a readable long-form story, full-screen image inspection, and a deeper visual archive. Witness adopts that grammar but changes the emotional and behavioral arc:

- the primary action is a deliberate act of Witness, not a lightweight favorite;
- the story reveals evidence and one credible action, not only cultural context;
- the visual tone is an archive at dusk rather than a white gallery with a red commerce accent;
- notification permission and monetization follow the first completed ritual rather than interrupting onboarding;
- the interface uses four focused destinations: Today, Archive, Witnessed, and Settings.

The detailed mapping and anti-copy boundary are recorded in `docs/VISUAL_REFERENCE_AUDIT.md`.

### The core strategic correction

The original concept is emotionally strong, but awareness alone is a weak impact claim. The MVP must visibly separate three layers:

- **Attention:** verified witness events.
- **Engagement:** action-link opens, shares, return rate, and private saves.
- **Outcome:** only partner-verified or otherwise defensible real-world results, if any exist.

Until outcome evidence exists, the app must not imply that tapping Witness saved an animal, funded conservation, or changed policy.

### Impact thesis

Witness benefits society by making biodiversity loss understandable, memorable, and actionable without overwhelming the user. Its proof during the contest should be:

- people complete the daily ritual;
- people return;
- people open a relevant conservation action;
- people share a species story;
- users report greater understanding through a short optional survey;
- at least one conservation or subject-matter advisor reviews the action/content model.

These are leading indicators, not ecological outcomes. That honesty is part of the trust proposition.

### Revenue model

The free tier contains the entire ethical promise:

- today's species;
- the story and sources;
- Witness;
- the daily action;
- the last seven days;
- basic Witness Deck;
- sharing and local reminders.

`Witness+` funds continued editorial work and adds ongoing value:

- complete archive;
- narrated stories where audio rights are verified;
- thematic collections;
- expanded field notes;
- custom high-resolution memorial cards;
- monthly personal reflection report.

Recommended launch offer: monthly and annual subscriptions, with a seven-day introductory trial on annual. Final pricing is a week-two decision after a small willingness-to-pay test. Do not claim that subscription revenue is donated to conservation unless a formal, auditable program exists.

## Product principles

- **One, not many:** focus is the feature.
- **Reverence, not spectacle:** beauty should invite attention, not aestheticize suffering.
- **Evidence is visible:** sources and verification dates are part of the interface.
- **Action is specific:** one small, relevant action beats a generic list.
- **Progress is gentle:** streaks are private and forgiving; there are no leaderboards.
- **Privacy is a feature:** no account or public profile in v1.
- **Access before monetization:** do not paywall the moral act.
- **Image first, meaning second:** earn attention visually, then reveal story, evidence, and action in a calm scroll.
- **Progressive depth:** the first screen works in seconds; sources, related species, and collections reward curiosity without cluttering the ritual.

## Risks and mitigations

| Risk | Why it matters | MVP response |
|---|---|---|
| Awareness without impact | Weak Peace Prize case | Add one credible action and transparent engagement metrics |
| Copyright or data-license breach | Can block submission and damage trust | Per-record provenance and rights gate; no unlicensed IUCN API use |
| Public Memory Bank abuse | Requires moderation, reporting, blocking, support, and account deletion | Keep reflections private/on-device for v1 |
| False social proof | Fabricated or double-counted witnesses destroy credibility | Idempotent server events; label cached/unavailable counts honestly |
| Scope overload | Four weeks is too short for catalog, social network, CMS, audio, and moderation | Ship a narrow vertical slice, then expand only after gates pass |
| Paywall feels exploitative | Conflicts with mission and harms conversion | Keep daily ritual and action free; sell depth, personalization, and audio |
| App Review delay | Store publication is mandatory | Submit by September 15 and preserve a two-week buffer |
| Content becomes the bottleneck | Every daily card needs research, copy, art, and rights | Use a locked content card and accept only reviewed records |
| Sensitive location disclosure | Can endanger species | Use generalized ranges and exclude precise coordinates |

## Simple version

The safest winning candidate:

- native SwiftUI app;
- 14 fully reviewed species bundled for launch;
- daily card, story, sources, Witness, count, action, archive, share, local notification;
- private local reflections;
- anonymous Supabase witness aggregation;
- RevenueCat-powered Witness+ subscription with full archive and two premium collections;
- no accounts, public UGC, voice notes, uploads, CMS, live chat, or in-app donations.

## More ambitious version

Add only after the simple version is in TestFlight and the release gates are green:

- 30 launch species;
- narrated stories for a verified subset;
- bilingual English/Spanish content;
- conservation-partner reviewed actions;
- monthly impact/reflection report;
- lightweight editorial dashboard;
- public Memory Bank with full moderation, identity, report/block, support, and deletion systems.

## Recommendation

Build the simple version and make it exceptional. The more ambitious version is a controlled expansion queue, not the week-one scope.
