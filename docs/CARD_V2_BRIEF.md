# Card v2 brief — owner direction, 2026-08-22

AV's direction at the close of day one, recorded verbatim in intent: **stop scaling card production (5 of 30 produced) until the card itself is nailed down.** The current card is missing:

1. **An actual hook** — the opening must excite, not just inform.
2. **Useful info and stats** — concrete, scannable facts about the animal (size, lifespan, where it lives, what it eats, what threatens it, trend).
3. **Maps** — a visual sense of where the species lives (generalized per the sensitive-location policy).
4. **A clear in-app CTA** — engagement must be driven *inside* the app; an external link that takes the user out of Witness is not the primary call to action.

## Implications to work through (day two)

- **Schema extension**: `SpeciesRecord` needs a sourced stats block (measurements, lifespan, diet, threats, trend) and generalized range-map data. Stats obey the same trust rules: every figure maps to a declared source; volatile counts stay out.
- **Range maps**: original code-drawn generalized maps (region-level highlight, no precise coordinates) in the Atlas visual language — one reusable map component fed by per-card region data, not per-card artwork.
- **In-app CTA design**: candidates to evaluate — the Witness act itself as the emotional CTA; a daily reflection prompt; save-to-cabinet/collection framing; streak continuity; share plate; a short "did you know" reveal loop. External actions (NOAA, Xerces links) demote to the evidence section. Must stay honest: no gamified guilt, no fake urgency (trust policy).
- **Hook rework**: hooks become curiosity-driven one-liners tested against "would a 12-year-old want to keep reading?"
- **Re-production**: existing 5 cards get upgraded to v2 before any new species are produced; the pipeline doc gains the new stages.

## Decision status

Direction accepted; concrete v2 card design to be mocked on the Vaquita and approved by AV before catalog-wide application.
