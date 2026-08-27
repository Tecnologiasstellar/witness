# Professional prompt — build Witness’s one-page website

> Archived v1 build prompt. The website it requested has been superseded by the implemented multi-route experience. Do not execute this prompt or reuse its old product-state claims.

Copy everything below into your preferred design/build agent. Supply this `witness_web` folder as its source material.

---

You are a senior editorial web designer, brand strategist, accessibility engineer, and pragmatic launch-page developer. Build the first public one-page website for **Witness**.

## Design read

Reading this as: an editorial project showcase for trust-sensitive, design-conscious early supporters, conservation advisors, and Shipathon judges, with a quiet archival language leaning toward a contemporary field notebook—not a generic environmental campaign or app-marketing template.

```text
DESIGN_VARIANCE: 6
MOTION_INTENSITY: 3
VISUAL_DENSITY: 3
```

## Objective

Create a responsive one-page project showcase that makes the Witness idea emotionally clear and technically credible in under 30 seconds. It should explain the ritual, demonstrate the ethical product boundary, and link to the public GitHub project.

This is **not** an App Store landing page yet. Do not invent a download, waitlist, payment, newsletter, public community, live count, partner, or impact metric.

## Product truth

**Pitch:** “Every day, witness one species on the edge of disappearance—and join a global archive of memory and action.”

Witness is a native iOS daily ritual. A person meets one threatened species, reads a short sourced story, records a private act of Witness, and opens one credible action. A Witness measures attention, never conservation impact.

The current iOS MVP is in development. It has one bundled Vaquita prototype record, offline-first local persistence, private reflection, streak logic, and a share-plate preview. It does not yet have a public App Store release, a backend, live collective counts, RevenueCat, public accounts, production-cleared species media, or conservation partnerships.

## Non-negotiable constraints

1. Use the supplied `witness_web` documents as factual source of truth.
2. Do not use DailyArt/Mobbin screenshots, artwork, copy, layouts, icons, or visual identity. They are research-only.
3. Do not use the user-provided Vaquita image; it is unavailable to the workspace and pending per-file rights metadata.
4. Use an original abstract Vaquita specimen study made from CSS/canvas/SVG geometry, or use no species image. Label it: `Abstract prototype depiction — not documentary media.`
5. Never show a population estimate, a live Witness count, a precise map, a sensitive location, a conservation outcome claim, a fake testimonial, or fabricated traction.
6. Do not make this look like an NGO donation page, a climate dashboard, an AI startup, or an environmentally themed SaaS page.
7. No external webfont or stock asset unless its license and loading path are explicitly verified. Start with system font stacks.
8. Make all primary interactions keyboard accessible and WCAG AA compliant. Respect `prefers-reduced-motion` and `prefers-reduced-transparency`.
9. Build a static site first. No database, login, tracking, email collection, CMS, payment, or backend.

## Visual direction — Atlas at dusk

The page feels like a public reading room for a living field archive: parchment, fine engraved rules, direct-on-paper figures, restrained taxonomy marks, generous space, and technical clarity.

Use this semantic palette consistently:

```css
--paper: #F1E8D5;
--paper-aged: #E9DCC1;
--paper-fresh: #F7F1E3;
--ink: #25231F;
--sepia: #624936;
--ink-muted: #6B6157;
--earth: #8A684A;
--sage: #65745A;
--hairline: #81796E; /* decorative rules only */
--paper-dark: #15130F;
--ink-dark: #EFE6D2;
```

This parchment palette is valid because it is already Witness’s Atlas identity, not because warm beige is a generic luxury default. Keep it precise and archival: no brass gradients, no clay/orange commerce CTAs, no glossy cards, and no black drop shadows.

Use `ui-serif` / Georgia-class display type for editorial headings and scientific names; use `ui-sans-serif` / system UI for body, navigation, metadata, and controls. Do not use Inter by default. Use one accent only: sage for focus/interactive emphasis.

## Required page sequence and exact starter copy

### Header

- Left: `Witness` wordmark.
- Right: `The ritual`, `Built with care`, `View project ↗`.
- Link `View project ↗` to `https://github.com/Tecnologiasstellar/witness`.
- Keep one desktop line; create an accessible compact mobile menu if needed.

### Hero

- Small label: `A DAILY PRACTICE OF ATTENTION`
- H1: `Meet one species. Remember what is still here.`
- Support: `A quiet iPhone ritual for seeing, understanding, and taking one honest action.`
- Primary CTA: `Explore the ritual` → anchor to the ritual section.
- Secondary text link: `View project ↗` → GitHub.
- Right-side/dominant visual: original abstract Vaquita specimen plate directly on parchment, not in a rounded-image card. Include common name, italic scientific name, hairline scale motif labelled `SCALE UNAVAILABLE`, and the honest prototype caption.

The initial viewport must contain the complete hero message and primary CTA. At desktop, use an asymmetric split layout; under 768 px, stack copy before the figure.

### Proposition

- H2: `The biodiversity crisis is vast. Attention can begin with one name.`
- One short, editorial paragraph about giving a species enough space to be known before asking for action. Do not claim that attention alone changes an ecological outcome.

### Three-step ritual

Use exactly three items, with field-plate numbering rather than generic feature cards:

1. `Meet` — `Encounter one species and a short sourced story.`
2. `Witness` — `Record a private act of attention, once.`
3. `Act` — `Open one credible, source-backed next step.`

Below: `A Witness is a record of attention—not a claim of conservation impact.`

### Vaquita field note

Show an original abstract figure and these factual elements only:

- `Vaquita · Phocoena sinus`
- `Northern Gulf of California, Mexico`
- `The world’s smallest porpoise lives nowhere else.`
- `Gillnet entanglement is the threat described in Witness’s current bundled story.`
- Source link, labeled `Read NOAA Fisheries ↗`, using this exact URL:
  `https://www.fisheries.noaa.gov/feature-story/endangered-vaquita-porpoise-not-doomed-extinction-inbreeding-depression`
- Verification note: `Current bundled prototype record · fact-checked 2026-08-21`

Do not add a population number, “critically endangered” wording, a map, any historical claim, or a photo.

### Built with care

Create a rule-led list, not four matching cards:

- `Evidence visible` — Sources and verification state belong in the experience.
- `Private by default` — No account or public memories in v1.
- `Offline-first` — The core ritual remains available without a network.
- `Free at the core` — The daily story, sources, Witness action, and credible action stay free.

### Current status

Use a plain, confident status block:

> `Witness is an iOS MVP in development. It is not yet available on the App Store.`

Support with one sentence about the local prototype: one bundled species, on-device Witness persistence, private reflection, and original share preview. Do not claim a backend, public count, subscription, partner, or production media library.

CTA: `View project ↗`

### Footer

- `Witness`
- “Every day, witness one species on the edge of disappearance—and join a global archive of memory and action.”
- GitHub link.
- `Sources, rights, and release readiness are treated as product requirements.`

## Layout and engineering rules

- Do not use a centered SaaS hero, gradients, glassmorphism, bento grid, logo wall, pricing table, fake phone mockup, dashboard, cookie banner, or stock-photo montage.
- Do not put every section in a rounded card. Use paper tone, rules, and whitespace.
- Use `min-height: 100dvh`, never `100vh`.
- Keep content in `min(1200px, calc(100vw - 48px))`; use 20–24 px mobile gutters.
- Use a 4 px spacing rhythm and max 65ch reading measure.
- Minimum 44 × 44 px interactive targets; visible focus states; one H1; semantic headings and landmarks.
- Decorative rules and specimen annotations are `aria-hidden`; the specimen figure has one concise accessible description.
- Motion must be limited to quiet opacity/line reveals under 300 ms. Remove nonessential motion under `prefers-reduced-motion`.
- Build dark mode with the same paper/ink hierarchy; do not invert to pure black.
- Do not use more than one eyebrow for every three sections.

## Deliverables

1. A working responsive one-page site.
2. Reusable semantic design tokens and components.
3. A short `README` explaining local run/build commands and asset provenance.
4. An accessibility checklist covering keyboard navigation, contrast, reduced motion/transparency, semantic landmarks, and responsive behavior.
5. A clear list of intentionally deferred integrations: App Store link, mailing list, analytics, backend counts, payments, and production media.

Before handing it off, verify desktop and 320 px mobile layouts, light/dark appearance, all links, focus states, CTA contrast, and that no claim exceeds the supplied source material.
