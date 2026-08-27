# Witness web design system v1.0

> Historical foundation. The current implementation preserves these Witness tokens and anti-template principles, while responsive layout, device storytelling, motion, and components are documented in `site/DESIGN_NOTES.md`.

## Design read and dials

Reading this as: an editorial project showcase for trust-sensitive, design-conscious supporters and judges, with a quiet archival language leaning toward a modern field-notebook rather than an app-marketing template.

```text
DESIGN_VARIANCE: 6
MOTION_INTENSITY: 3
VISUAL_DENSITY: 3
```

The parchment palette is intentional because it is already the Atlas identity of the native app and signals a field plate / evidence archive. It must not drift into generic “luxury wellness” beige-and-brass styling.

## Visual thesis: Atlas at dusk

The web should feel like a public reading room for a living field archive: parchment, fine rules, restrained taxonomy marks, generous space, and an abstract specimen study. It should be calm enough to earn attention and rigorous enough to earn trust.

Use one compositional system throughout:

- thin engraved rules and occasional corner ticks;
- direct-on-paper figures, not floating rounded cards;
- serif only for species identity and editorial headlines;
- technical sans for metadata and calls to action;
- one restrained sage accent for interactive emphasis;
- visual proof through a specimen plate and clear language, not fake social proof or ecology statistics.

## Color tokens

Use semantic tokens. Do not add arbitrary section colors.

| Token | Light | Dark | Use |
|---|---:|---:|---|
| `--paper` | `#F1E8D5` | `#15130F` | Main canvas |
| `--paper-aged` | `#E9DCC1` | `#1D1A15` | Quiet tonal panel / figure field |
| `--paper-fresh` | `#F7F1E3` | `#221E18` | Elevated accessible surface |
| `--ink` | `#25231F` | `#EFE6D2` | Body text and primary action |
| `--sepia` | `#624936` | `#C6A98A` | Metadata, rules, subtle links |
| `--ink-muted` | `#6B6157` | `#A79C8D` | Supporting copy only |
| `--earth` | `#8A684A` | `#B08C68` | Figure annotation, never threat severity |
| `--sage` | `#65745A` | `#93A886` | Focus and primary interactive state |
| `--hairline` | `#81796E` | `#7C7365` | Decorative rules only; never text |

Contrast rules:

- `--ink` is the default for long-form text.
- `--ink-muted` may be used only when it meets WCAG AA against its actual background.
- `--hairline` is decorative and cannot carry information.
- Status is written in words; color never communicates severity alone.
- Dark appearance must preserve the archival tonal hierarchy, not simply invert to black.

## Typography

Use a system-first stack. Do not add a font dependency until its license, loading behavior, and performance are accepted.

```css
--font-display: ui-serif, Georgia, Cambria, "Times New Roman", serif;
--font-body: ui-sans-serif, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
```

| Role | Treatment |
|---|---|
| Hero and section headline | Display serif, semibold, tight but unclipped leading |
| Species name | Display serif; sentence/title case, never all caps |
| Scientific name | Display serif italic |
| Body | System sans, 16–18 px, 1.55–1.7 line height, max 65ch |
| Metadata / labels | System sans, 11–13 px, medium/semibold; sparse uppercase tracking |
| Button | System sans, 14–16 px, semibold; sentence case or concise uppercase consistently |

Use at most one small uppercase eyebrow every three sections. Do not decorate every heading with labels.

## Layout and responsive behavior

- Desktop content container: `min(1200px, calc(100vw - 48px))`.
- Mobile content gutter: 20–24 px.
- Use a 4 px spacing rhythm: `4, 8, 12, 16, 20, 24, 32, 40, 48, 64, 96`.
- Hero: split composition from 768 px upward; stacked on mobile. The call to action must be visible in the initial viewport.
- Never use `100vh`; use `min-height: 100dvh` if a viewport-led hero is needed.
- Multi-column sections collapse deliberately below 768 px. Preserve reading order.
- Use borders, negative space, and paper tone for grouping. Avoid repeating rounded white cards.

## Components

| Component | Rules |
|---|---|
| `SiteHeader` | Wordmark, 2–3 anchors maximum, external GitHub link. One desktop line; accessible menu on mobile. |
| `AtlasRule` | Fine line with optional corner tick; decorative, `aria-hidden`. |
| `SpecimenPlate` | Original abstract Vaquita study with label `Abstract prototype depiction`; no unverified photo. |
| `RitualStep` | Number, concise verb, one sentence. Three only: Meet, Witness, Act. |
| `EvidenceStrip` | Source-aware, privacy-first, offline-first principles. No fake counters. |
| `StatusNote` | Plain statement: “iOS MVP in development — not yet on the App Store.” |
| `PrimaryLink` | Dark ink background/light ink text; minimum 44 px target, clear keyboard focus. |
| `TextLink` | Sepia/ink link with visible underline or non-color affordance. |

## Imagery and figures

- Use original CSS/canvas/SVG geometry only for the v1 Vaquita study, or leave the media field intentionally abstract.
- Label the study truthfully: “Abstract prototype depiction — not documentary media.”
- Do not use the supplied DailyArt/Mobbin reference assets in any form.
- Do not use a public species photo, map, population count, satellite imagery, or sensitive coordinates unless a rights and source record is approved for web use.
- Avoid animal portraits framed as “cute,” suffering imagery, dramatic ocean stock photography, planet imagery, and extinction countdowns.

## Motion, accessibility, and interaction

- Motion is optional atmosphere, not meaning. Use only gentle opacity or line-reveal transitions under 300 ms.
- `prefers-reduced-motion: reduce` removes all nonessential transforms and scroll-linked animation.
- `prefers-reduced-transparency` receives solid paper surfaces.
- Keyboard focus is always visible and high contrast.
- Buttons/links have 44 × 44 px minimum targets.
- Use semantic landmarks, one H1, logical heading order, meaningful alt text, and `aria-hidden` for decorative rules.
- No carousel, autoplay video, parallax, scroll hijacking, text-over-image without a measured scrim, or essential hover-only content.
