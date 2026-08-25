# Witness — App Icon Design Brief

Status: current, 2026-08-25. Written to brief an external designer or Claude Design on the icon specifically. For the full product design system, see `docs/DESIGN_SYSTEM_BRIEF_AND_CLAUDE_PROMPT.md` — note its color table is v0.1 (Aug 21) and has since been superseded by the Atlas palette below, which is what's actually coded and shipping.

## What Witness is

A daily-ritual iOS app: each morning, one endangered species — its story, its evidence, one credible action. Visual concept: **Archive at dusk** — a field journal encountered at the edge of daylight. Reverent, tactile, quiet, editorial. Explicitly not: a dashboard, an activist poster, a cute mascot app, a museum-clone encyclopedia.

Rejected adjectives worth repeating to a designer: cute, alarming, gamified, corporate-ESG, encyclopedic, apocalyptic, ornamental.

## The Atlas palette (current, coded — `WitnessApp/DesignSystem/WitnessTheme.swift`)

This is the real, shipping palette. Treat it as the source of truth over the older design-system-brief doc.

| Token | Light | Dark | Feel |
|---|---:|---:|---|
| paper | `#F1E8D5` | `#15130F` | primary ground |
| paperAged | `#E9DCC1` | `#1D1A15` | |
| paperFresh | `#F7F1E3` | `#221E18` | raised surfaces |
| ink | `#25231F` | `#EFE6D2` | primary text/line |
| sepia | `#624936` | `#C6A98A` | rules, secondary line work |
| inkMuted | `#6B6157` | `#A79C8D` | |
| earth | `#8A684A` | `#B08C68` | |
| accentSage | `#65745A` | `#93A886` | the one accent — used sparingly |

Paper is warm and aged, never stark white or pure black. Sage green is the single accent color and should be spent carefully, not as a dominant field. No red/amber/green status coding anywhere in the product — the icon shouldn't introduce it either.

## Typography

Display face is EB Garamond (serif) where bundled, with a system-serif fallback — used for species identity and editorial display, never for every label. Interface/technical text is a monospace-leaning sans (see `AtlasType.technical`). If the icon carries any wordmark or monogram, it should draw from the serif, not the sans.

## The card art style (locked, approved — `docs/ART_PROMPT_TEMPLATE.md`)

Every species plate in the app follows one locked template: fine natural-history plate illustration, painterly gouache and ink on warm paper texture, muted palette of ink + one or two species-appropriate accent tones + lichen green, soft directional light, full body in gentle profile, generous negative space, quiet museum-specimen composition. No text, no border, no watermark, never a dramatic scene, never suffering as spectacle. This is the visual world the icon needs to feel like a mark for — an archive of these plates, not a departure from them.

## Icon candidates so far

Four explorations exist in `docs/icons/`, all built as flat SVG (plus rendered PNG) — no AI generation was used for these, they're geometric/vector marks:

- **A1** (`icon-a1-light.svg` / `-dark.svg`) — a compass rose: two concentric rings (heavy ink outer, thin sepia inner), four cardinal ticks, solid ink center dot. Paper background, subtle grain filter. Reads as "field-journal instrument" — a naturalist's compass, evoking navigation/tracking rather than any single species.
- **A2** (`icon-a2-light.svg`) — a simpler single-ring compass, same four ticks, but the center dot is sage green instead of ink — the only candidate that puts the accent color at the icon's focal point.
- **A3** (`icon-a3-light.svg`) — A1's compass rose again, but nested inside a double-rule square frame (echoing the picture-frame convention used around card plates). More "archival plate," less "instrument."
- **B** (`icon-b-vaquita-light.png`) — an actual species illustration (vaquita, in the exact locked card-art style) centered in a double-rule frame on paper. This is the only candidate that shows a specific animal rather than an abstract mark.

None have dark-mode variants finished except A1. None are chosen — AV hasn't picked one yet (this is decision DL in the project log).

## The open design question

The compass-rose direction (A1/A2/A3) is abstract and won't date as species get added or removed, but it's also generic — a compass could belong to any exploration/journal app. The vaquita direction (B) is distinctive and immediately legible as "this app is about a specific endangered species," in the app's actual art style — but a single species on the icon reads as if that species is special, when the whole point of Witness is that a different one appears every day; it also means the icon itself becomes stale-feeling art next to whichever species is live that day.

Worth asking Claude Design to explore: is there a mark that gets the "archive/field-journal" feeling of the compass without being generic — e.g. something built from the natural-history-plate visual grammar itself (a fine engraved line quality, the frame convention, the warm paper ground) but abstracted enough not to be any one species. AV's instinct so far has favored the compass family for its neutrality, but hasn't committed.

## Hard constraints for iOS

- Must work at all standard iOS icon sizes down to the small Settings/Spotlight size (60pt @3x = 180px) — fine detail that reads at 1024px (grain filters, thin double-rules) needs to still register as a coherent shape at 60pt. Test small.
- Needs light and dark variants (iOS 18-style icon variants); a tinted/monochrome variant is good to have but not required for v1.
- No transparency — iOS icons are composited on an opaque square, corners get masked by the OS.
- Should not use red, or any color/motif that could read as an alert or warning badge.

## What to hand back

Given this brief, a useful response from Claude Design would be: 2–3 fresh directions (not just refinements of A1–B) at 1024px, each with a one-line rationale tied to the "archive at dusk" concept, plus a light/dark pair for whichever direction seems strongest, and a note on how it holds up at small size.
