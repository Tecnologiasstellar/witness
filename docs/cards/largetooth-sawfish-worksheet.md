# Card worksheet — Largetooth Sawfish (Pristis pristis)

Scaffolded 2026-09-02 by tools/new-card.py. Pipeline: docs/CARD_PRODUCTION_PIPELINE.md; trust bar: docs/CONTENT_TRUST_AND_RIGHTS.md. Delete this file once the card is approved and merged.

## Source-verification checklist

- [ ] Scientific + common name and status wording verified against a primary source (no IUCN API per D-005)
- [ ] Every story sentence maps to a declared source; story 120-220 words
- [ ] Stats (size, lifespan, diet, trend, 4+ threats) each curl-verified; volatile population figures omitted or dated
- [ ] Range generalized: named regions only, radius >= 25 km, no sensitive localities
- [ ] Action: official destination, working HTTPS link, passes the action policy
- [ ] 1+ conservation programs live-verified (`kind: program`; sponsors must be labeled)
- [ ] Insight is genuinely surprising and sourced
- [ ] All URLs pass `python3 tools/check_links.py --all --only largetooth-sawfish`
- [ ] Five plates generated (model nano_banana_pro, tecnologiasstellar account), job IDs in the rights record
- [ ] Species-accuracy review of every plate against source reference photos
- [ ] Editorial review done; `editorial.state` flipped in the PR (approval = PR review)
- [ ] `swift test --package-path Packages/WitnessCore` green

## Image prompts (locked template, D-013)

### largetooth-sawfish-plate-01 — hero, aspect 2:3

```
Fine natural-history plate illustration of Largetooth Sawfish (Pristis pristis), a long flattened toothed rostrum (saw) about a quarter of the body length with 14–24 evenly spaced teeth along each edge, a shark-like body with two tall dorsal fins (the first set well ahead of the pelvic fins), broad triangular pectoral fins, a tail with a small but distinct lower lobe, olive-brown above and white below. Painterly gouache and ink on warm paper texture, muted palette of ink, olive-brown and river-silt ochre and lichen green, soft directional light, full body in gentle profile, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### largetooth-sawfish-context-01 — habitat, aspect 3:2

```
Fine natural-history plate illustration of Largetooth Sawfish (Pristis pristis), a long flattened toothed rostrum (saw) about a quarter of the body length with 14–24 evenly spaced teeth along each edge, a shark-like body with two tall dorsal fins (the first set well ahead of the pelvic fins), broad triangular pectoral fins, a tail with a small but distinct lower lobe, olive-brown above and white below. Painterly gouache and ink on warm paper texture, muted palette of ink, olive-brown and river-silt ochre and lichen green, soft directional light, the animal small within its characteristic habitat, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### largetooth-sawfish-detail-01 — head study, aspect 1:1

```
Fine natural-history plate illustration of Largetooth Sawfish (Pristis pristis), a long flattened toothed rostrum (saw) about a quarter of the body length with 14–24 evenly spaced teeth along each edge, a shark-like body with two tall dorsal fins (the first set well ahead of the pelvic fins), broad triangular pectoral fins, a tail with a small but distinct lower lobe, olive-brown above and white below. Painterly gouache and ink on warm paper texture, muted palette of ink, olive-brown and river-silt ochre and lichen green, soft directional light, close head study showing the diagnostic facial features, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### largetooth-sawfish-behavior-01 — behavior, aspect 3:2

```
Fine natural-history plate illustration of Largetooth Sawfish (Pristis pristis), a long flattened toothed rostrum (saw) about a quarter of the body length with 14–24 evenly spaced teeth along each edge, a shark-like body with two tall dorsal fins (the first set well ahead of the pelvic fins), broad triangular pectoral fins, a tail with a small but distinct lower lobe, olive-brown above and white below. Painterly gouache and ink on warm paper texture, muted palette of ink, olive-brown and river-silt ochre and lichen green, soft directional light, swinging its saw sideways through a school of small fish in shallow, murky river water, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### largetooth-sawfish-scale-01 — human scale, aspect 1:1

```
Fine natural-history plate illustration of Largetooth Sawfish (Pristis pristis), a long flattened toothed rostrum (saw) about a quarter of the body length with 14–24 evenly spaced teeth along each edge, a shark-like body with two tall dorsal fins (the first set well ahead of the pelvic fins), broad triangular pectoral fins, a tail with a small but distinct lower lobe, olive-brown above and white below. Painterly gouache and ink on warm paper texture, muted palette of ink, olive-brown and river-silt ochre and lichen green, soft directional light, the animal beside a quiet human silhouette for scale, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

## Open questions for AV

1. IUCN Red List species page (https://www.iucnredlist.org/species/18584848/58336780) and the Australian Government DCCEEW sawfish/recovery-plan pages were bot-gated (403 / timeouts) and could not be fetched, so neither is cited. Status "Critically Endangered" (IUCN, 2022 assessment by Espinoza et al.) is corroborated by the FRDC 2023 report card, Florida Museum, SCS and Fishes of Australia. EPBC "Vulnerable (2000), Migratory (2015)" comes from the FRDC card, not DCCEEW. Please open both in a browser and confirm.
2. No global population count exists. `populationEstimate` carries the 61% range contraction since 1900 (Dulvy et al. 2016, IUCN SSG PDF) instead. Alternative: set both population fields to null.
3. Maximum size: 705 cm TL (FRDC, Fishes of Australia); NOAA says "just over 23 feet"; typical adults ~2.5 m. Card says "up to 7 m (23 ft)".
4. Lifespan: FRDC says estimated 36 years; NOAA says "36–80 depending on study"; SCS says ~80. Card uses 36 (Australian assessors).
5. Years juveniles spend in freshwater vary by source: 3–5 (SCS), 4–5 (Florida Museum), ~7 (CSIRO Archer River). Story says "first years" to avoid picking one.
6. Section 6 credits "Simon Fraser and Charles Darwin universities" from the author affiliations of Dulvy et al. (SFU, CDU, JCU, NOAA). Drop the attribution if it reads as name-dropping.
7. Program 2 is the Shark Trust "See a Saw" rostrum-documentation project (fits the rostrum-trade angle). The Fitzroy (Murdoch/WAMSI) and Archer River (CSIRO) work have no standing program page, so they are cited in the story only. sharktrust.org returned 403 to the WebFetch tool but 200 to curl and to check_links; content verified from the curl copy.
8. A 2026 Proceedings B paper (historical DNA from 375 museum rostra; only 6 of 35 historical haplotypes survive) is a strong story beat but the paper, PubMed and PMC pages were all bot-gated; only phys.org coverage was readable, so it was left out. Worth adding if you can open the Royal Society page.
9. IUCN 2022 assessment reportedly says "possibly extinct in 19 of 60 former range states" (search snippet, not fetched). Not used.
10. Habitat-region coordinates (Kimberley/Fitzroy; Gulf of Carpentaria rivers) are my region-scale approximations with 250–300 km radii; not from any source.
11. `media.source` had the scaffold job-id placeholder, which fails the validator; replaced with "Higgsfield job pending (plates not yet generated)". Swap in the real job id when plates are made.
12. Hook is 65 chars; "75 countries" is the historical-range figure from Dulvy et al. 2016.
