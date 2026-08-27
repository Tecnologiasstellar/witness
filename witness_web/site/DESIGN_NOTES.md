# Witness web v3 design notes

## Goal

Preserve the Witness archive identity while making the product easier to understand, navigate, and remember. The new homepage uses the structural grammar of a premium app showcase: compact proof, large promise, art constellation, central device, scroll-linked feature states, a three-step ritual, archive scale, trust, FAQ, and closing call to action.

## Reference boundary

DailyArt informed page rhythm, central-device storytelling, long-scroll pacing, FAQ placement, and footer density. Witness does not copy DailyArt code, text, branding, artwork, fonts, screenshots, layouts at pixel level, ratings, statistics, or motion assets. The resulting composition is independently designed in Witness’s parchment, ink, sepia, and sage system.

## Design dials

- Visual variance: 7/10
- Motion intensity: 6/10 on capable devices, static under reduced motion
- Information density: 3/10 on the homepage, higher on record pages
- One theme: archival paper with one dusk archive band
- One primary accent: sage, with sepia as semantic editorial ink

## Preserved

- Parchment and dusk semantic tokens
- Display serif plus system sans
- Procedural paper grain
- Fine rules, editorial marginalia, square actions
- Source-visible archive and record routes
- No trackers, cookie banner, email capture, or fabricated proof

## Added

- Sticky primary navigation with Experience, Archive, Method, and FAQ
- Art-led hero using exact rights-cleared assets
- Centered iPhone development preview using approved catalog data
- IntersectionObserver feature changes, isolated to one client component
- Native details/summary FAQ
- Reconciled legal and support wording
- Public claim ledger and artwork hash manifest

## Responsive behavior

Desktop keeps the device sticky while five record callouts pass beside it. Mobile shows the device and one concise first record rather than forcing five tall scroll states. Three-column ritual and trust layouts collapse to a single readable flow. Art side plates are removed from the smallest hero rather than shrunk into illegibility.

## Motion

Only transform and opacity animate. The marquee and image transitions stop under `prefers-reduced-motion`. No scroll hijacking, parallax, autoplay media, custom cursor, or carousel is used.
