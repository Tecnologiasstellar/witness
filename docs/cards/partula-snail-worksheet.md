# Card worksheet — Partula Snail (Partula tohiveana)

Scaffolded 2026-09-08 by tools/new-card.py. Pipeline: docs/CARD_PRODUCTION_PIPELINE.md; trust bar: docs/CONTENT_TRUST_AND_RIGHTS.md. Delete this file once the card is approved and merged.

## Source-verification checklist

- [ ] Scientific + common name and status wording verified against a primary source (no IUCN API per D-005)
- [ ] Every story sentence maps to a declared source; story 120-220 words
- [ ] Stats (size, lifespan, diet, trend, 4+ threats) each curl-verified; volatile population figures omitted or dated
- [ ] Range generalized: named regions only, radius >= 25 km, no sensitive localities
- [ ] Action: official destination, working HTTPS link, passes the action policy
- [ ] 1+ conservation programs live-verified (`kind: program`; sponsors must be labeled)
- [ ] Insight is genuinely surprising and sourced
- [ ] All URLs pass `python3 tools/check_links.py --all --only partula-snail`
- [ ] Five plates generated (model nano_banana_pro, tecnologiasstellar account), job IDs in the rights record
- [ ] Species-accuracy review of every plate against source reference photos
- [ ] Editorial review done; `editorial.state` flipped in the PR (approval = PR review)
- [ ] `swift test --package-path Packages/WitnessCore` green

## Image prompts (locked template, D-013)

### partula-snail-plate-01 — hero, aspect 2:3

```
Fine natural-history plate illustration of Partula Snail (Partula tohiveana), a tiny elongated conical spiral shell only 1–2 cm long, pale cream-to-tan shell with faint brown banding, soft grey-brown body with two slender upper eye tentacles and two short lower tentacles, the snail clinging to the underside of a broad leaf, a single tiny live-born juvenile snail 1–2 mm long nearby. Painterly gouache and ink on warm paper texture, muted palette of ink, pale cream and warm tan and lichen green, soft directional light, full body in gentle profile, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### partula-snail-context-01 — habitat, aspect 3:2

```
Fine natural-history plate illustration of Partula Snail (Partula tohiveana), a tiny elongated conical spiral shell only 1–2 cm long, pale cream-to-tan shell with faint brown banding, soft grey-brown body with two slender upper eye tentacles and two short lower tentacles, the snail clinging to the underside of a broad leaf, a single tiny live-born juvenile snail 1–2 mm long nearby. Painterly gouache and ink on warm paper texture, muted palette of ink, pale cream and warm tan and lichen green, soft directional light, the animal small within its characteristic habitat, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### partula-snail-detail-01 — head study, aspect 1:1

```
Fine natural-history plate illustration of Partula Snail (Partula tohiveana), a tiny elongated conical spiral shell only 1–2 cm long, pale cream-to-tan shell with faint brown banding, soft grey-brown body with two slender upper eye tentacles and two short lower tentacles, the snail clinging to the underside of a broad leaf, a single tiny live-born juvenile snail 1–2 mm long nearby. Painterly gouache and ink on warm paper texture, muted palette of ink, pale cream and warm tan and lichen green, soft directional light, close head study showing the diagnostic facial features, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### partula-snail-behavior-01 — behavior, aspect 3:2

```
Fine natural-history plate illustration of Partula Snail (Partula tohiveana), a tiny elongated conical spiral shell only 1–2 cm long, pale cream-to-tan shell with faint brown banding, soft grey-brown body with two slender upper eye tentacles and two short lower tentacles, the snail clinging to the underside of a broad leaf, a single tiny live-born juvenile snail 1–2 mm long nearby. Painterly gouache and ink on warm paper texture, muted palette of ink, pale cream and warm tan and lichen green, soft directional light, the snail feeding at night on decaying leaf litter on the underside of a leaf, a faint glowing dot of UV paint on its shell, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### partula-snail-scale-01 — human scale, aspect 1:1

```
Fine natural-history plate illustration of Partula Snail (Partula tohiveana), a tiny elongated conical spiral shell only 1–2 cm long, pale cream-to-tan shell with faint brown banding, soft grey-brown body with two slender upper eye tentacles and two short lower tentacles, the snail clinging to the underside of a broad leaf, a single tiny live-born juvenile snail 1–2 mm long nearby. Painterly gouache and ink on warm paper texture, muted palette of ink, pale cream and warm tan and lichen green, soft directional light, the animal beside a quiet human silhouette for scale, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

## Open questions for AV

1. Species choice: kept `Partula tohiveana` (Moorea). It is the species with the clean sourced arc — first invertebrate reassessed from Extinct in the Wild to Critically Endangered after a self-sustaining wild population was found (Oryx 2025; RZSS 28 Mar 2025). The common name in the literature is "Moorean viviparous tree snail" / "Tohiea tree snail"; card keeps the generic "Partula Snail" per scaffold. OK, or use the specific common name?
2. Status date drift: press (Sept 2024, Cambridge/STL) said "will be downlisted"; RZSS/BIAZA announced the downlisting 28 Mar 2025; the Oryx paper says "reassessed as Critically Endangered in 2025"; Wikipedia cites an IUCN 2025 assessment. Story says "moved from ... to ..." without a year. The brief's "moved ... in 2024" framing is not quite right — 2025 is the Red List year.
3. IUCN Red List page for P. tohiveana (iucnredlist.org/species/16283/268742577) was bot-gated (403); not cited. Status rests on RZSS press + the Oryx paper.
4. ZSL / London Zoo pages were all 403 (project page, both 2024/2025 news pages, "rare snail returns"). ZSL leads the programme but is not cited; the same press releases are cited via Edinburgh Zoo / RZSS mirrors. Also 403: Bristol Zoo Project news, BIAZA, Wiley (Haponski 2019), ResearchGate, CABI.
5. "52 species extinct in the wild" is from Gerlach et al. Oryx 2023 (WebFetch paraphrase: "52 species faced extinction in the wild"). Other counts drift: Coote & Loève 2003 title "61 species to five"; Marwell says 77 species / 51 extinct / 11 captive-only; Gerlach's site says 50+ extinct, 11 captive, 5 wild; Oryx 2025 says of 51 Society Islands species at least 29 (possibly 34) extinct, 10 captive-only. Pick one framing you like; I chose the most recent peer-reviewed figure.
6. Introduction date: Bick et al. 2014 (Oryx) gives 1974 for the Society Islands (Tahiti); Moorea was 1977 per Coote & Loève 2003 (seen only in search snippet, not fetched — not cited). Zoo pages say "1970s". Story uses 1974.
7. "By 1995 almost every wild population was gone" — Oryx 2025 says populations were eliminated "between 1982 and 1995". Fine as written?
8. Trend set to "increasing": releases grow yearly and wild-born tohiveana are spreading beyond the release site (Edinburgh Zoo Nov 2025). Defensible, but the re-established wild population is tiny (4 adults + 13 juveniles found in 2024). Switch to "unknown" if you prefer caution.
9. Population figures deliberately null: no reliable wild count exists. Could add "~40,000 released 2015–2025" as the number, but that is releases, not population.
10. Cumulative release totals drift by source: Cambridge news "over 30,000 since 2015" (Sept 2024); RZSS page "over 24,000"; Detroit "over 17,000"; Edinburgh Nov 2025 "nearly 40,000 over the last decade". Story uses the latest (nearly 40,000).
11. UV paint colour varies by year/zoo (red 2024, white-glows-blue 2025, orange at Detroit 2026). Plate prompt says "faint glowing dot" without colour.
12. Habitat regions: Moorea (30 km) and Tahiti (60 km) island-scale circles. Huahine also receives releases (other species) — add a third circle?
13. Action destination is a University of Cambridge news page rather than a zoo page, because every ZSL page was blocked and the Cambridge story is the fullest public account. Alternative: RZSS 2025 news page.
14. Stats size line spans the genus (12–30 mm per Marwell); Beauval Nature (fetched, not cited) gives P. tohiveana at ~2 cm and 1.9 g if you want species-specific.
15. Plate-prompt honesty: only "1–2 cm shell", "live-born 1–2 mm young", "underside of leaves", "nocturnal detritivore" and the UV dot are from cited sources. Shell colour/banding and the four-tentacle head are generic pulmonate-snail anatomy, not species-sourced — check against reference photos of P. tohiveana before generating (its shell is reportedly pale/whitish; confirm).
