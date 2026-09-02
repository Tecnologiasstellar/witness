# Witness MVP specification

Last updated: 2026-08-20

## Launch outcome

A first-time user can open the app, understand the ritual, meet today's species, read its sourced story, witness it exactly once, see the reconciled collective count, open one credible action, and find the card in a personal deck—even after relaunching or going offline.

## Primary user

A curious, emotionally engaged adult who cares about nature but does not want a dense science product or an endless distressing feed.

## Required screens

### 1. First launch

- A six-page introduction (D-026), one idea per page, SKIP on every page: why Witness exists · one species a week · bear witness · the acts · a weekly reminder (intent only) · the works and the Index. Readable again from INDEX › COLOPHON › HOW WITNESS WORKS, without the reminder page.
- Continue directly into this week's species. Do not ask for sign-in, notifications, or payment before the user can experience the ritual: the reminder page records a preferred time and never invokes the system prompt.
- After the first completed Witness, offer a reminder-time primer with Morning, Midday, Evening, and Choose a time — pre-filled as a one-tap confirm when the introduction named a time. Invoke the system notification prompt only after explicit intent.
- No account requirement.
- No paywall, price, or purchase control in the introduction; Field Season and the Atlas appear as named doors only.

### 2. Today

- Full-bleed species artwork occupying roughly the upper 55–62% of the initial viewport, extending under the safe area.
- A warm-paper editorial sheet overlaps the image with a generous top radius and scrolls as one continuous story.
- The overlap begins with `TODAY`, status wording, confirmed witness count, and share controls, followed by common name, italic scientific name, generalized range, and one-line hook.
- Primary `Witness` control is visible without a long scroll and uses a restrained haptic plus a reduced-motion alternative.
- After Witness is confirmed, the control becomes a quiet completed state and reveals the next layer: collective count, one action, reflection, and share.
- The story uses short editorial paragraphs, generous leading, and optional pull-quote or fact treatment rather than dense encyclopedia sections.
- Server-reconciled witness count and explicit offline/unavailable state.
- One action card with source organization, effort/time cue, and external destination.
- `Evidence & credits` drawer with factual sources, status wording, media credit/license, correction contact, and last-verified date.
- A full-screen image mode supports close inspection, visible credit access, and a clean dismiss gesture. It must not imply an illustration is documentary photography.

### 3. Witness moment

- A brief, restrained transition—not confetti.
- Confirmation that the event was recorded or queued offline.
- Collective count.
- Optional private reflection prompt.
- Share card preview.
- Avoid confetti, badges, fireworks, competitive comparison, or artificial urgency.

### 4. Witness Deck

- Grid of witnessed species.
- Private streak and total witnessed count.
- Empty/loading/offline states.
- Seven-day archive for free users; full archive for Witness+.
- Filled state supports a compact list and image-led grid. The empty state explains the ritual and returns directly to Today.

### 5. Species detail

- Revisit the story, action, sources, and private reflection.
- Clear distinction between extinct, extinct in the wild, and threatened statuses.
- Compact sticky header after the hero scrolls away.
- Related-species row may appear only when it is curated and does not distract from the daily action.

### 6. Witness+

- Mission-aligned paywall explaining that the daily ritual stays free.
- Live App Store prices, terms, privacy link, restore purchases, and manage subscription path.
- RevenueCat entitlement state; no hardcoded access override in Release.

### 7. Settings

- Reminder time and notification state.
- Appearance and reduced-motion respect.
- Restore purchases.
- Privacy policy, terms, support, acknowledgements, content corrections contact.
- Export/delete local reflections and reset local history.

## Primary information architecture

The MVP uses four bottom destinations:

1. **Today** — the daily ritual and the only default launch destination.
2. **Archive** — past species, curated collections, and search when available.
3. **Witnessed** — the user's private deck, streak, stats, and reflections.
4. **Settings** — reminders, appearance, accessibility, purchases, legal, support, and credits.

Do not create separate Discover and Search tabs in the MVP. Search lives inside Archive when implemented. Action remains part of the species story rather than becoming a detached task list.

## Visual system direction

- Editorial rather than dashboard-like.
- System serif for display titles and system sans serif for body/interface text during the first prototype; external fonts require a later rights/performance decision.
- Warm bone paper, near-black ink, muted lichen, mineral gray, and one restrained living accent. Do not inherit DailyArt's brand red.
- Status appears primarily as language and hierarchy, not alarming traffic-light color.
- Large species imagery, rounded editorial surfaces, fine dividers, quiet iconography, and substantial whitespace.
- Light and dark appearance share the same structure; dark mode feels archival rather than purely inverted.
- Motion reinforces the transition from seeing to understanding: slow image-to-sheet continuity, subtle Witness confirmation, and no decorative spectacle.

## MVP data contracts

### Species record

- stable ID and schema version;
- common and scientific names;
- normalized status plus display wording;
- generalized region/range;
- one-line hook;
- 120–220 word story;
- one action record;
- hero asset ID;
- publish date;
- factual sources;
- review state and reviewer;
- last fact-check date.

### Media record

- stable asset ID;
- local and/or remote path;
- creator and rights holder;
- source URL;
- license identifier and license URL;
- attribution string;
- derivative status;
- commercial-use status;
- verification date and evidence note.

### Action record

- title and 1–2 sentence rationale;
- action type;
- effort/time cue;
- destination URL and destination organization;
- geographic applicability;
- source/reviewer;
- last-verified date;
- measurement type: `opened`, `self_reported`, or `partner_verified`.

### Witness event

- species ID;
- app-assigned publish date;
- privacy-preserving installation ID;
- event version;
- created-at timestamp;
- unique idempotency key.

The public counter exposes aggregates only. It never exposes installation IDs or individual histories.

## Architecture

- Native SwiftUI application targeting iOS 17+.
- Feature-oriented source layout with stable domain and service protocols.
- Bundled, validated JSON catalog for offline-first launch content.
- Supabase for anonymous idempotent witness events, daily aggregate counts, and remotely published catalog updates after launch.
- Local persistence for onboarding, deck, streak, reminder preferences, queued witness events, and private reflections.
- RevenueCat SDK behind a `PurchaseService` abstraction with separate Test Store/Debug and App Store/Release configuration.
- Local notifications for the daily ritual.
- Native `ImageRenderer`/Core Image composition for share cards; each card carries required media attribution or uses an owned derivative permitted by the source license.
- Privacy-respecting product analytics limited to the funnel needed to evaluate feasibility and impact.

## Acceptance criteria

- Today's species is deterministic by app calendar policy and does not change unexpectedly with relaunch.
- Catalog validation fails closed for missing sources, rights, action, or required copy.
- Witness can be recorded once per species/date per installation and syncs after offline use.
- Count never fabricates success; pending, cached, error, and confirmed states are visually distinct.
- Streak logic passes timezone, daylight-saving, missed-day, and date-change tests.
- Free and premium entitlements pass fresh-install, purchase, cancel/expire, restore, offline-cache, and error states.
- Core ritual is usable with VoiceOver, Dynamic Type, Reduce Motion, high contrast, and no network.
- No exact sensitive-species coordinates are shipped.
- Release configuration contains no test keys, placeholder legal URLs, or unverified content/assets.

## Explicitly out of scope for v1

- Public user memories, comments, voice notes, or uploads.
- User accounts, profiles, following, messaging, leaderboards, and public streaks.
- Direct fundraising, donation claims, or conservation-outcome claims.
- Live IUCN API calls.
- AI-generated facts at runtime.
- Android/iPad-specific layouts, widgets, watch app, or web app.
- A large CMS or automated editorial pipeline.
