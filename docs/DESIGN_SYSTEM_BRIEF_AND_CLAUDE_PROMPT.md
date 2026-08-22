# Witness Design System Brief

Status: Design-system source brief v0.1  
Date: August 21, 2026  
Platform: Native SwiftUI, iOS 17+, iPhone-first  
Working concept: **Archive at dusk**

## 1. Design mandate

Witness should feel like a living field archive encountered at the edge of daylight: reverent, tactile, lucid, intimate, and contemporary. It is not an environmental dashboard, encyclopedia, social feed, museum clone, or fundraising funnel.

The experience must make one species feel sufficient. Beauty earns attention; editorial clarity builds understanding; a deliberate Witness action creates memory; evidence earns trust; one credible action offers agency.

DailyArt is a reference for product grammar only:

- one dominant daily subject;
- an image-first opening;
- a large editorial surface overlapping the image;
- progressive depth below the first fold;
- quiet native navigation;
- strong empty, loading, success, and dark-mode states;
- a daily item that compounds into a personal archive.

Never copy DailyArt typography, red accent, icon treatments, layouts, proportions, copy, artwork, screenshots, or brand expression. No DailyArt or Mobbin asset may appear in Witness output.

## 2. Non-negotiable premises

### Emotional premises

1. **Reverence, not spectacle.** Never aestheticize suffering or use tragedy porn.
2. **Attention before action.** The user first sees, then understands, then Witnesses, then acts.
3. **Quiet urgency.** The subject matters; the interface does not shout.
4. **Dignity over cuteness.** Species are presented as lives and lineages, not mascots.
5. **Hope without false reassurance.** Agency is specific and honest, never sentimental or inflated.
6. **Memory, not gamification.** Continuity and private accumulation replace points, flames, rankings, or confetti.

### Product premises

1. One species is the entire daily focus.
2. The daily story, sources, Witness action, and conservation action stay free.
3. The Witness control is more important than favorite, share, streak, or purchase controls.
4. Evidence is part of the designed experience, not legal text hidden at the bottom.
5. The core ritual works offline; remote failure never blanks the species or story.
6. No accounts or public user content in v1.
7. Private reflections remain visibly private and on-device.
8. Counts measure witnessed attention, never conservation outcomes.
9. Every media and content state must distinguish prototype, pending review, approved, unavailable, and error.
10. Accessibility and dark mode are first-class variants of every component.

### Native implementation premises

1. Design for SwiftUI and native iOS behavior, not a web canvas inside an iPhone frame.
2. Prefer `TabView`, `NavigationStack`, `List`, `ScrollView`, `ShareLink`, sheets, disclosures, and SF Symbols where they express the intended pattern.
3. Use semantic Dynamic Type styles for the app UI. Fixed type sizes are allowed only in rendered share artifacts with a separate accessible description.
4. Use semantic colors and light/dark tokens. Do not embed arbitrary per-screen hex values.
5. Preserve 44-point minimum interactive targets; primary actions should normally be at least 54 points high.
6. Avoid absolute positioning that breaks Dynamic Type, localization, or safe areas.

## 3. Visual thesis

### Archive at dusk

The visual world combines:

- field-journal intimacy;
- archival paper and fine rules;
- deep marine and forest tones;
- large, rights-safe species imagery;
- serif identity and sans-serif clarity;
- subtle layers rather than a collection of floating cards;
- darkness with tonal depth, not pure-black inversion.

The result should feel premium because it is edited and intentional—not because it is glossy, dense, or ornamental.

### Desired adjectives

Reverent, editorial, quiet, memorable, trustworthy, tactile, spacious, natural, precise, dignified, contemporary.

### Rejected adjectives

Cute, alarming, activist-poster, gamified, corporate-ESG, encyclopedic, social, childish, luxurious-for-its-own-sake, apocalyptic, ornamental, dashboard-like.

## 4. Foundation tokens

These colors are the **current coded prototype baseline**, not a locked final brand palette. Any change requires contrast evidence, light/dark comparison, and a migration mapping back to semantic SwiftUI tokens.

### Semantic color system

| Token | Light | Dark | Use |
|---|---:|---:|---|
| `canvas` / `paper` | `#F5F1E8` | `#171B19` | Primary editorial background |
| `surfaceRaised` | `#FFFCF5` | `#212623` | Action, reflection, and elevated content surfaces |
| `textPrimary` / `ink` | `#17201D` | `#EEF1EC` | Primary text and high-emphasis icons |
| `textSecondary` | `#5C6762` | `#AEB8B1` | Metadata, captions, supporting copy |
| `borderSubtle` / `rule` | `#D7D2C7` | `#39413C` | Fine dividers and quiet outlines |
| `actionPrimary` / `lichenDeep` | `#315C50` | `#A8C9B8` | Witness action, links, selected navigation |
| `statusEmphasis` / `livingClay` | `#8B4938` | `#E2A18E` | Restrained status emphasis and recoverable errors |
| `mediaDeep` | `#173D4A` | `#0A222A` | Prototype media depth and image fallback |
| `mediaMist` | `#88BFC3` | `#376C76` | Prototype media atmosphere and image fallback |

Rules:

- Status must always be written in words; color is secondary.
- Do not use red/amber/green as a threat-severity scale.
- Do not place text on translucent color unless contrast is measured in both appearances.
- Never lower text opacity to create hierarchy; use `textSecondary` or a semantic tertiary token.
- System alerts, destructive actions, and links should retain native expectations unless a tested Witness token is clearer.
- Claude may propose one refined palette, but must provide old-to-new token mapping, measured contrast, and visual evidence before recommending adoption.

### Typography

Use Apple system typography until an external font passes licensing, performance, localization, and Dynamic Type review.

| Role | SwiftUI intent | Character |
|---|---|---|
| Species display | `.largeTitle`, system serif, semibold | Memorable identity; never all caps |
| Screen title | Native large navigation title or `.largeTitle` | Clear location, no ornamental custom chrome |
| Editorial hook | `.title3`, medium | One strong, readable sentence |
| Section title | `.title2` or `.title3`, semibold | Sparse structural emphasis |
| Body story | `.body`, regular, generous line spacing | Calm 45–75 second reading |
| Interface emphasis | `.headline` | Buttons and decisive controls |
| Metadata | `.subheadline` | Range, date, organization, continuity |
| Eyebrow | `.caption`, semibold, tracked sparingly | `TODAY`, `ONE CREDIBLE ACTION`, `PRIVATE REFLECTION` |
| Scientific name | `.body` or `.subheadline`, italic | Taxonomic identity with correct reading order |
| Footnote/evidence | `.footnote` / `.caption` | Provenance and privacy explanation |

Typography rules:

- Prefer semantic styles and natural wrapping.
- Do not cap Dynamic Type for essential content.
- At accessibility sizes, convert horizontal metadata rows to vertical stacks.
- Remove or reduce letter spacing at accessibility sizes if it damages legibility.
- Keep story measure comfortable: approximately 45–70 characters per line where the device width allows.
- Use serif for identity and editorial emphasis, never for every interface label.

### Spacing

Use a 4-point base rhythm:

`4, 8, 12, 16, 20, 24, 32, 40, 48, 64, 96`

Preferred patterns:

- Screen horizontal margin: `20–24`.
- Editorial sheet horizontal padding: `24`.
- Body paragraph separation: `12–16`.
- Major section separation: `28–40`.
- Compact component internal padding: `12–16`.
- Editorial/elevated component padding: `18–24`.
- Use whitespace to establish hierarchy before adding containers or rules.

### Shape

| Token | Value | Use |
|---|---:|---|
| `radiusSmall` | `12` | Compact fields and small state containers |
| `radiusControl` | `16` | Primary/secondary controls |
| `radiusCard` | `22–24` | Action, reflection, and archive cards |
| `radiusModal` | `28` | Share preview and major modal surfaces |
| `radiusEditorial` | `32` top corners | Today image-to-story overlap |
| `capsule` | Full | Status wording and rare compact filters only |

One dominant editorial sheet is preferred to many cards. Shadows are reserved for real elevation: sheets, share artifacts, or full-screen media controls. Use rules, tonal surfaces, and whitespace elsewhere.

### Iconography

- Use SF Symbols by semantic name.
- Default to simple outline/monochrome symbols.
- Pair unfamiliar icons with text.
- Use `eye` for Witnessed, `books.vertical` for Archive, and conventional system symbols for share, settings, retry, lock, globe, source, and close.
- Never use a heart as the primary Witness metaphor.
- Do not create a bespoke icon set before the app identity and production media direction are approved.

### Imagery

1. Hero media occupies roughly 55–62% of the initial Today viewport and may extend under the top safe area.
2. The species must remain the focal subject; avoid dramatic suffering, graphic death, or human-centered spectacle.
3. Documentary photography, scientific illustration, reconstruction, AI-assisted illustration, and abstract placeholder art must each be labeled truthfully in metadata.
4. Every asset needs creator, rights holder, source, license, commercial-use state, attribution, verification date, and evidence note.
5. Never expose exact sensitive-species coordinates through images, maps, captions, or metadata.
6. Never crop away required attribution or alter an asset beyond its license.
7. Archive cards should use consistent image ratios; recommended exploration baseline is `4:5` portrait with an alternate `16:10` compact row crop.
8. Share artifacts use the existing `4:5` ratio (`360 × 450` logical points) as a baseline.

### Motion and haptics

- Motion explains continuity from seeing to understanding.
- Hero-to-sheet scroll may use restrained depth or scale continuity, never theatrical parallax.
- Witness confirmation: subtle ring or tonal expansion, check/eye state transition, and one restrained success haptic.
- Saving/queued states use calm progress, not pulsing urgency.
- Typical transitions should feel immediate-to-gentle, approximately 180–450 ms depending on distance and meaning.
- Reduce Motion removes transforms, parallax, and expanding geometry; retain opacity/state changes and meaning.
- Never use confetti, streak flames, shaking, flashing, celebratory explosions, or loss countdowns.
- Sound is off by default. Do not introduce ambient wildlife audio as decoration or imply that an unrelated recording is the featured species.

## 5. Core component library

Every component requires light, dark, accessibility-large, loading, disabled, and relevant error/offline variants.

### Navigation and structure

1. `WitnessAppShell`
   - Four native tabs: Today, Archive, Witnessed, Settings.
   - Today is the default launch destination.
   - Stable labels and SF Symbols; no custom floating navigation for v1.
2. `WitnessNavigationHeader`
   - Native large title or compact inline state after scroll.
3. `EditorialSheet`
   - One large top-radius surface overlapping hero media.
   - Scrolls continuously with the story.
4. `SectionEyebrow`
   - Short uppercase editorial labels used sparingly.
5. `FineRule`
   - One-pixel semantic divider with generous vertical breathing room.

### Species identity and story

6. `SpeciesHeroMedia`
   - Image, placeholder, loading, unavailable, full-screen affordance, depiction type, credit access.
7. `SpeciesStatusLabel`
   - Written status, no traffic-light semantics, single-line where possible, vertical reflow at large text.
8. `SpeciesIdentityBlock`
   - Common name, italic scientific name, generalized range, hook.
9. `StoryParagraph`
   - Source-mapped editorial text with generous leading.
10. `EditorialFact` / `PullQuote`
   - Optional, rare emphasis; must remain sourced and never sensational.
11. `EvidenceDisclosure`
   - Sources, editorial state, reviewer, last verified, media rights/credit, corrections contact.
12. `SourceRow`
   - Organization, title, verified date, external-link affordance.

### Ritual and action

13. `WitnessControl`
   - States: ready, saving, queued offline, confirmed local, confirmed remote, retryable error, unavailable.
   - Minimum 54-point height; text carries meaning, not icon/color alone.
14. `WitnessCount`
   - States: confirmed server value, cached value with timestamp, unavailable, syncing, error.
   - Never increments optimistically or implies outcome.
15. `WitnessConfirmation`
   - Quiet transition and explicit recorded/queued wording.
16. `CredibleActionCard`
   - Title, concise rationale, effort cue, organization, geographic applicability, last verified, external destination.
17. `ActionOpenState`
   - Opened means engagement only; never “impact achieved.”

### Personal memory

18. `WitnessedSpeciesCard`
   - Image-led grid and compact list variants.
19. `ContinuitySummary`
   - Private, forgiving language such as “3-day continuity”; no flame or competitive framing.
20. `PrivateReflectionEditor`
   - Privacy label, character count, save/saving/saved/error states, export/delete affordances later.
21. `WitnessedEmptyState`
   - Quiet explanation and direct path to Today.

### Sharing

22. `SharePreviewSheet`
   - Preview first, privacy/outcome disclaimer, then native share action.
23. `WitnessShareCard`
   - Rights-safe image or owned derivative, species identity, hook, Witness mark, truthful carry line.
   - Never includes private reflection, fabricated count, outcome claim, or unsafe location.
24. `SharePreparationState`
   - Preparing, ready, failure with retry.

### System and commerce

25. `OfflineNotice`
   - Calm, compact, specific; never blocks bundled content.
26. `InlineRetryState`
   - Explains what was not saved/synced and preserves local state.
27. `SkeletonSpeciesCard`
   - Tonal, restrained, Reduce Motion compatible.
28. `SettingsSection` and `SettingsRow`
   - Native list behavior for reminders, appearance, accessibility, privacy, legal, support, content corrections, and purchases.
29. `ReminderPrimer`
   - Appears only after first Witness; intent selection before system permission.
30. `WitnessPlusBoundary` (deferred until purchase work)
   - Daily ethical promise remains free; pricing is live; restore and terms are visible.

## 6. Required screen and state matrix

### MVP screens

1. Onboarding — Why.
2. Onboarding — The ritual.
3. Today — loading bundled content.
4. Today — ready, not witnessed.
5. Today — saving locally.
6. Today — confirmed locally/offline.
7. Today — confirmed with reconciled collective count.
8. Today — witness retry/error.
9. Today — count unavailable but story usable.
10. Today — full-screen media with depiction type and credits.
11. Witness moment — confirmation, action, reflection, share.
12. Archive — empty, populated grid, compact list, search, no results, offline.
13. Witnessed — empty and populated.
14. Species detail — revisited story, action, evidence, reflection.
15. Reflection — editing, saving, saved, error.
16. Share preview — preparing, ready, failure.
17. Reminder primer and reminder-time selection.
18. Settings — normal, notifications denied, offline, purchase unavailable.
19. Witness+ — loading products, live products, restore, purchase success/failure, entitlement active/expired.

### Appearance matrix

Every required screen must be reviewed in:

- light;
- dark;
- standard Dynamic Type;
- at least one accessibility Dynamic Type category;
- Reduce Motion;
- increased contrast where available;
- offline and error states where relevant.

## 7. Interaction and content rules

### Voice

- Calm, exact, human, and short.
- Prefer: “Witness this species,” “Recorded on this device,” “Count unavailable,” “Open official source.”
- Avoid: “Save this species,” “You made an impact,” “Only X remain” unless the exact wording is approved and sourced, “Act now,” or guilt-based prompts.
- Never present an approximate or stale count as live.
- Use “private reflection,” not “public memory,” in v1.

### Progressive disclosure

First fold:

- species image;
- Today label;
- written status;
- common and scientific names;
- generalized range;
- one-line hook;
- clear path toward Witness.

Deeper scroll:

- story;
- Witness state and honest count;
- one credible action;
- private reflection;
- share;
- sources, rights, and corrections.

Do not force every trust detail into the first fold, but never hide it behind settings or legal copy.

## 8. Accessibility acceptance rules

1. VoiceOver order follows image description → Today/status → identity → range/hook → story → Witness → count → action → reflection/share → evidence.
2. Decorative shapes are hidden; meaningful media has a truthful description and depiction type.
3. Controls have explicit labels and hints where the consequence is not obvious.
4. No essential information depends on color, animation, sound, gesture, or spatial position alone.
5. Text/background contrast must meet WCAG AA; non-text controls and focus indicators need at least 3:1.
6. At accessibility sizes, no essential label is truncated, clipped, or forced into a horizontal row.
7. The system tab bar must not make critical actions unreachable; scroll content needs bottom clearance.
8. External links identify their destination or organization.
9. Reduced Motion preserves completion meaning without transforms.
10. Test with long scientific names, long status wording, Spanish expansion, and unavailable/error copy even though English ships first.

## 9. Design QA and anti-patterns

Reject a design if it:

- looks like a direct DailyArt reskin;
- uses a red brand accent or heart as the core ritual;
- makes the count more prominent than the species;
- looks like a metrics dashboard;
- hides sources or media state;
- implies ecological impact from a tap, share, streak, or link open;
- uses multiple competing cards in the first fold;
- adds public profiles, comments, likes, rankings, or feeds;
- asks for notification, account, or payment before first value;
- fails without network;
- clips at accessibility text sizes;
- uses unverified species media, exact sensitive locations, or DailyArt assets;
- invents content, counts, partner endorsements, rights, or production readiness.

## 10. Deliverables for a full design-system engagement

### Simple version — required now

1. One-page design principles and anti-copy boundary.
2. Semantic color variables for light/dark and increased contrast.
3. Native type-role specification with Dynamic Type behavior.
4. Spacing, radius, border, elevation, icon, imagery, motion, and haptic rules.
5. Component library for the 24 core non-commerce components above, with relevant variants.
6. Today, Witness moment, Witnessed, share preview, Archive empty, and Settings screens.
7. Loading, offline, saving, confirmed, unavailable, empty, and error states.
8. Standard and accessibility-large light/dark review frames.
9. SwiftUI implementation annotations: native container, semantic token, state inputs, accessibility behavior, and SF Symbol name.
10. A decision log listing retained current patterns, proposed changes, rationale, risk, and migration impact.

### Ambitious version — only after the simple system is approved and TestFlight is stable

1. Full onboarding and reminder flow.
2. Populated Archive grid/list/search and curated collections.
3. Full-screen media inspection.
4. Witness+ purchase and entitlement state system.
5. Spanish layouts and localization stress testing.
6. Motion prototypes with Reduce Motion alternates.
7. Monthly reflection report and narrated-story surfaces.
8. Public Memory Bank only after moderation and account requirements are explicitly reopened.

## 11. Working protocol for Claude Design

1. Begin each task by reading the canonical product, MVP, visual-audit, trust/rights, decision, and implementation-status documents plus the current SwiftUI views and theme.
2. State the exact vertical outcome, assumptions, screens/components affected, acceptance evidence, principal risk, and rollback.
3. Make the narrowest reasonable assumption unless a choice materially changes scope, rights, privacy, cost, public state, or native architecture.
4. Work in one reviewable vertical slice at a time: foundations → core components → one complete flow → states → accessibility → documentation.
5. Treat current code as an implemented baseline, not an untouchable visual specification. Propose changes additively and show token/component migration.
6. Never claim a screen is final without light, dark, accessibility-large, offline/error, and rights/content-state evidence relevant to it.
7. Maintain a visible assumptions and decisions log. Mark every artifact `exploration`, `candidate`, `approved`, or `rejected`.
8. Do not edit production Swift code unless the current task explicitly authorizes implementation.

---

# Copy-ready master prompt for Claude Design

You are the principal iOS product designer and native design-system architect for **Witness**.

## Mission

Create the smallest exceptional native iOS experience that can credibly win first place in the RevenueCat Shipathon 2026 Peace Prize on impact, trust, emotional power, and feasibility.

Witness in one sentence:

> Every day, witness one species on the edge of disappearance—and join a global archive of memory and action.

The invariant loop is:

> Meet one species → read a short sourced story → tap Witness → see an honest collective count → take one credible action → optionally share → retain the card privately.

## Product character

The governing visual concept is **Archive at dusk**: a living field archive at the edge of daylight—reverent, tactile, lucid, intimate, and contemporary. It must feel editorial and emotionally memorable, never like an environmental dashboard, doom feed, encyclopedia, museum clone, social network, or donation funnel.

Use DailyArt only as a reference for product grammar: one dominant daily subject, an image-first opening, an overlapping editorial surface, progressive depth, quiet navigation, excellent state design, and a daily object that compounds into an archive. Never copy its layouts, proportions, red accent, typography, icons, copy, artwork, screenshots, Mobbin marks, or brand expression. Never include any DailyArt asset in output.

Witness changes the grammar in essential ways:

- Witness is a deliberate moral-memory action, not a favorite.
- Evidence, rights, and last-verified states are visible product elements.
- One credible action follows understanding without guilt or false promises.
- Reflections are private and on-device.
- Counts measure attention, not conservation outcomes.
- The daily ritual remains free.

## Platform and implementation constraints

- Native SwiftUI, iOS 17+, iPhone-first.
- Use native iOS structures and SF Symbols wherever appropriate.
- Four tabs: Today, Archive, Witnessed, Settings.
- No accounts or public user-generated content in v1.
- Offline-first core ritual.
- No unverified media, exact sensitive-species locations, unlicensed IUCN API data, fabricated counts, invented partners, or unsupported impact claims.
- Accessibility, Dynamic Type, VoiceOver, contrast, Reduce Motion, privacy, and rights are acceptance criteria.
- The current semantic SwiftUI theme and implemented vertical slice are the baseline. Changes must include a token/component migration mapping.

## Required design principles

1. One, not many.
2. Reverence, not spectacle.
3. Image first, meaning second.
4. Evidence is visible.
5. Action is specific and honest.
6. Memory replaces gamification.
7. Privacy is a feature.
8. Access precedes monetization.
9. Progressive depth beats first-screen density.
10. Native behavior beats decorative invention.

## Visual foundations

Start from these coded semantic tokens, treating them as a candidate baseline rather than final brand colors:

- Paper: light `#F5F1E8`, dark `#171B19`
- Raised surface: light `#FFFCF5`, dark `#212623`
- Primary ink: light `#17201D`, dark `#EEF1EC`
- Secondary ink: light `#5C6762`, dark `#AEB8B1`
- Rule: light `#D7D2C7`, dark `#39413C`
- Primary action/lichen: light `#315C50`, dark `#A8C9B8`
- Restrained clay emphasis: light `#8B4938`, dark `#E2A18E`
- Media fallback: `#173D4A` → `#88BFC3` in light; `#0A222A` → `#376C76` in dark

Use system serif for species identity/editorial display and system sans for body/interface copy. Use semantic Dynamic Type styles. Use a 4-point spacing rhythm, 20–24 point screen margins, 44-point minimum targets, approximately 54-point primary controls, one 32-point top-radius editorial sheet, and restrained 16/22/28-point radii for controls/cards/modals.

Status must be written in language, never communicated by color alone. Do not use red/amber/green threat coding. Dark mode should feel archival and tonal, not inverted.

## Component and screen scope

Build the semantic component system for:

- app shell and navigation;
- species hero media and full-screen media state;
- overlapping editorial sheet;
- Today/status/identity/range/hook/story;
- Witness control in ready, saving, queued offline, confirmed local, confirmed remote, retry, and unavailable states;
- truthful count in live, cached, syncing, unavailable, and error states;
- one credible action card;
- evidence disclosure, source rows, media credit, and correction path;
- Witnessed grid/list card, continuity summary, empty state, and species detail;
- private reflection editor and all save states;
- share preview, share card, preparing, ready, and failure states;
- Archive empty/grid/list/search/no-results/offline states;
- reminders and Settings;
- loading skeletons, offline notices, inline retry, and unavailable states.

Then design the complete vertical flow:

1. Today before Witness.
2. Saving/queued state.
3. Confirmed Witness and honest count.
4. Credible action.
5. Private reflection.
6. Share preview.
7. Restored card in Witnessed.

## Accessibility and trust requirements

- Provide light and dark variants.
- Provide standard and accessibility-large Dynamic Type variants.
- Specify VoiceOver reading order and labels.
- Provide Reduce Motion alternatives for every motion concept.
- Preserve readable contrast and 44-point targets.
- Reflow horizontal metadata at large type rather than truncating.
- Keep story content scrollable above native navigation.
- Every depiction has a truthful type and credit state.
- Every factual/action element has source, review state, and last-verified behavior.
- Never include private reflection in share output.
- Never describe a tap, count, streak, share, or link open as conservation impact.

## Working method

Before designing, inspect:

- `AGENTS.md`
- `README.md`
- `docs/PRODUCT_STRATEGY.md`
- `docs/MVP_SPEC.md`
- `docs/FOUR_WEEK_EXECUTION_PLAN.md`
- `docs/COMPETITION_AND_RELEASE_GATES.md`
- `docs/CONTENT_TRUST_AND_RIGHTS.md`
- `docs/VISUAL_REFERENCE_AUDIT.md`
- `docs/DECISIONS.md`
- `docs/IMPLEMENTATION_STATUS.md`
- `docs/DESIGN_SYSTEM_BRIEF_AND_CLAUDE_PROMPT.md`
- the current SwiftUI views and `WitnessTheme.swift`

Inspect only the relevant DailyArt screenshots at full size. They are research references, never source assets.

At the start of every work cycle, state:

1. Exact vertical outcome.
2. Assumptions.
3. Screens, components, and tokens affected.
4. Acceptance evidence.
5. Principal risk.
6. Rollback or migration path.

Work one reviewable vertical slice at a time. Maintain an assumptions/decisions log and label every artifact `exploration`, `candidate`, `approved`, or `rejected`. Ask only when a missing decision materially changes scope, rights, privacy, cost, public state, or native architecture.

Do not modify production Swift code unless explicitly authorized. Do not claim anything is final or production-ready without dated evidence.

## First assignment

Create **Witness Design System v0.1** and the first complete high-fidelity ritual flow.

Deliver:

1. Principles and anti-copy boundary.
2. Semantic light/dark color variables with contrast results.
3. Native typography, spacing, radius, border, elevation, icon, imagery, motion, and haptic specifications.
4. Components and variants required for the vertical flow.
5. High-fidelity Today, Witness confirmation, action, reflection, share preview, and restored Witnessed screens.
6. Standard and accessibility-large variants in light and dark.
7. Loading, offline, saving, confirmed, count-unavailable, retry, and error states.
8. SwiftUI implementation notes for every component: native container, semantic tokens, state inputs, accessibility behavior, SF Symbol names, and responsive rules.
9. A gap report comparing the design candidate with the current app, ranked by user impact and implementation effort.
10. A final self-review against emotional tone, anti-copy boundary, truth/rights, accessibility, offline resilience, and solo-founder feasibility.

Do not begin with a broad moodboard. Begin with foundations and one complete vertical ritual that can be reviewed and implemented.

## Ongoing assignment template

After the first assignment, keep the master prompt fixed and append only this block for each design cycle:

```text
CURRENT DESIGN TASK

Outcome: [one concrete vertical outcome]
In scope: [screens, components, and states]
Out of scope: [explicit exclusions]
Acceptance evidence: [light/dark, Dynamic Type, state, accessibility, and implementation annotations required]
Stop point: [the exact review boundary; do not continue into code or another flow]

Use the approved Witness foundations and components. If a new token or component is necessary, propose it explicitly with rationale and migration impact before using it. Return outcome first, artifacts changed, validation performed, unresolved risks, and the single highest-leverage next design action.
```

If the design environment produces React, CSS, or absolute-positioned visual code, treat it as a disposable structural preview—not implementation. The implementation source of truth remains semantic native SwiftUI.
