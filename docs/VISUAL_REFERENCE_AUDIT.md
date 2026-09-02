# DailyArt visual-reference audit for Witness

Reference set: `DailyArt ios Jan 2025/`, screenshots 0–111  
Reviewed: 2026-08-20

## Purpose and boundary

The supplied screenshots are a high-quality reference for flow, hierarchy, density, pacing, and interaction states. They are not production assets and are not a mandate to reproduce DailyArt pixel for pixel.

Do not ship, crop, trace, redistribute, or include any DailyArt artwork, logo, copy, icon, screenshot, Mobbin watermark, or distinctive brand treatment in Witness or its submission. Witness must remain independently designed.

## What the reference does exceptionally well

### 1. It makes one item feel sufficient

Screens 7, 21, 25–26, 44, and 98–99 dedicate most of the initial viewport to a single artwork. A rounded editorial sheet overlaps the image and makes title and metadata feel like a physical catalog card. This creates focus without making the app feel empty.

**Witness adaptation:** one species portrait dominates the screen; the story surface rises from it. The first fold contains identity, status wording, the hook, and the primary Witness action.

### 2. It layers depth instead of crowding the first screen

Screens 16–19 show long-form text, metadata, translation, tags, and related material after the visual hook. Screens 22–24 offer a separate full-screen image experience.

**Witness adaptation:** Today remains calm. Story, evidence, action, credits, and related species appear progressively. Full-screen image mode exposes credit and depiction type.

### 3. It turns a daily item into an archive

Screens 29–38 and 52–74 demonstrate entity pages, collections, grids, lists, filters, search, and empty/filled personal collections. This makes a one-item daily product feel deep over time.

**Witness adaptation:** Archive houses past species and curated collections; Witnessed is the personal deck. Search is inside Archive rather than a dedicated MVP tab.

### 4. It handles states, not only ideal screens

The set includes skeletons, loading, empty, selected, successful purchase, purchase failure, sign-in, delete/cancel confirmations, notification on/off, and light/dark variants.

**Witness adaptation:** Weekend Zero must include intentional loading, empty, offline, pending-Witness, confirmed-Witness, and reduced-motion states. Production work must cover purchase and backend failures explicitly.

### 5. It uses editorial typography to create value

Display serif headings, quiet sans-serif body text, thin rules, large whitespace, image-led cards, and minimal chrome make the content feel curated rather than scraped.

**Witness adaptation:** start with system serif display type and system sans body/interface text. Use warm paper and ink with a restrained natural accent. Avoid importing a font before its license, performance, and Dynamic Type behavior are accepted.

## Flow mapping

| DailyArt reference | Pattern worth keeping | Witness adaptation | Do not copy |
|---|---|---|---|
| 0–6 | Short onboarding, notification primer, time selection | Two short context screens, first species, then reminder intent and system prompt | Art-lover copy, collage, account creation, widget step |
| 8–15 | Clear subscription benefits, live selection state, restore/redeem | Mission-aligned Witness+ at an earned premium boundary | Onboarding paywall, red palette, patron language, pricing/copy |
| 7, 21, 25–26, 44, 98 | Hero image plus overlapping editorial card | Species portrait plus evidence-aware story sheet and Witness CTA | Exact proportions, red accents, heart interaction, artwork/title layout |
| 16–19, 99 | Long-form readable narrative with compact sticky header | Species story with evidence, action, and last-verified state | Text structure or taxonomy labels verbatim |
| 22–24 | Immersive image view and save/share feedback | Full-screen species depiction with credits and depiction label | Their controls, icons, toast styling, or save behavior |
| 28 | Share preview with multiple formats | Witness card preview optimized for image and link sharing | Facebook-specific presentation and artwork reuse |
| 29–38, 42–43 | Entity profile, tabs, grid/list, filters | Species detail and later curated taxon/region collections | Museum/artist structure as the domain model |
| 52–66 | Featured collections and visual discovery | Archive collections such as Island Species and Lost in Our Lifetime | Dense launch catalog and identical card mosaics |
| 66–70 | Search states and categorized entry points | Search inside Archive after the core ritual is stable | Separate Search tab in MVP |
| 71–74 | Empty/filled personal collection | Witnessed empty state and private deck | “Favorites” framing; Witnessed records deliberate attention |
| 75–97 | Clear settings, notification controls, light/dark | Reminders, appearance, accessibility, legal, support, credits, purchases | Account/password/deletion flows while v1 has no accounts |
| 100–111 | Dark mode and authentication states | Archival dark appearance; no v1 authentication | Black inversion without tonal tuning; login flows |

## Witness-specific visual direction

### Concept: Archive at dusk

The app should feel like a living field archive encountered at the edge of daylight: reverent, tactile, lucid, and contemporary. It is neither a museum clone nor an environmental-alert dashboard.

### Starting palette for prototype exploration

- Warm bone paper: `#F2EFE7`
- Deep ink: `#161815`
- Lichen: `#7C8663`
- Mineral mist: `#D5D8D0`
- Living clay accent: `#B8644B`
- Night archive: `#0E100F`

These are prototype tokens, not locked brand colors. Status categories should rely on language and hierarchy rather than red/amber/green coding.

### Typography

- Display: SwiftUI system serif, high contrast, generous line breaks.
- Body/interface: SwiftUI system sans, comfortable reading width and leading.
- Scientific name: italic treatment with correct accessibility pronunciation metadata where practical.
- Small labels: concise uppercase with tracking used sparingly.

### Shape and spacing

- One large-radius editorial sheet, not many floating cards.
- Fine dividers and spacious vertical rhythm.
- Image-led archive cells with consistent ratios.
- Controls use native affordances and minimum accessible targets.
- Bottom bar is quiet and stable; the Witness button carries the primary emphasis.

### Motion

- Slow image-to-sheet continuity during scroll.
- Witness confirmation uses a subtle expanding ring, tonal shift, and haptic.
- Full-screen image enters/exits with restrained continuity.
- Reduce Motion replaces transformations with opacity and state changes.
- Never use confetti, shaking alerts, streak flames, or theatrical loss imagery.

## Recommended onboarding

> Superseded 2026-09-02 by D-026 and `WitnessApp/Features/Onboarding/OnboardingView.swift`: six skippable pages on the weekly cadence (D-023), reminder intent recorded in the introduction, iOS prompt still only after the first Witness. The copy below is kept as the original daily-worded reference.

### Screen 1 — Why

Hero: an original Witness composition or approved flagship image.  
Headline: `Some species disappear before most of us ever know their names.`  
Support: `Witness gives one species your attention each day—and one honest way to act.`  
CTA: `Begin witnessing`

### Screen 2 — The ritual

Three restrained steps:

- Meet one species.
- Read for one minute.
- Witness, then choose one action.

CTA: `Meet today's species`

### First-value sequence

Open directly into Today. After the first confirmed Witness, offer:

`Would you like tomorrow's species to find you?`

Then present Morning, Midday, Evening, and Choose a time before invoking the iOS permission prompt.

## Weekend Zero review checklist

- The DailyArt influence is recognizable as product grammar, not copied brand expression.
- Today is visually dominant and understandable in under five seconds.
- The Witness action is more prominent and meaningful than favorite/share.
- Story text remains readable with large Dynamic Type.
- Evidence and credits are discoverable without cluttering the first fold.
- The transition after Witness naturally reveals action, reflection, and share.
- Archive and Witnessed have intentional empty states.
- Light, dark, offline, loading, pending, completed, and Reduce Motion states are designed.
- No supplied reference screenshot or artwork appears in the app build or share output.

## Deferred patterns

- Widget onboarding.
- Account creation and cross-device sync.
- Translation selector.
- Multi-dimensional filters.
- Separate discovery and search destinations.
- Tip jar and patron tier.
- Public collections built from user content.

These may be reconsidered only after the core ritual, App Store release, and Peace Prize evidence are secure.
