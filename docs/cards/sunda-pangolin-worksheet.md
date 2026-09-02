# Card worksheet — Sunda Pangolin (Manis javanica)

Scaffolded 2026-09-02 by tools/new-card.py. Pipeline: docs/CARD_PRODUCTION_PIPELINE.md; trust bar: docs/CONTENT_TRUST_AND_RIGHTS.md. Delete this file once the card is approved and merged.

## Source-verification checklist

- [ ] Scientific + common name and status wording verified against a primary source (no IUCN API per D-005)
- [ ] Every story sentence maps to a declared source; story 120-220 words
- [ ] Stats (size, lifespan, diet, trend, 4+ threats) each curl-verified; volatile population figures omitted or dated
- [ ] Range generalized: named regions only, radius >= 25 km, no sensitive localities
- [ ] Action: official destination, working HTTPS link, passes the action policy
- [ ] 1+ conservation programs live-verified (`kind: program`; sponsors must be labeled)
- [ ] Insight is genuinely surprising and sourced
- [ ] All URLs pass `python3 tools/check_links.py --all --only sunda-pangolin`
- [ ] Five plates generated (model nano_banana_pro, tecnologiasstellar account), job IDs in the rights record
- [ ] Species-accuracy review of every plate against source reference photos
- [ ] Editorial review done; `editorial.state` flipped in the PR (approval = PR review)
- [ ] `swift test --package-path Packages/WitnessCore` green

## Image prompts (locked template, D-013)

### sunda-pangolin-plate-01 — hero, aspect 2:3

```
Fine natural-history plate illustration of Sunda Pangolin (Manis javanica), overlapping dark-brown keratin scales in 15–19 rows across the back, a long slender prehensile tail often tipped with a few pale scales, a long narrow toothless snout with small eyes, short stout foreclaws tucked under the feet when walking, an unscaled pale belly. Painterly gouache and ink on warm paper texture, muted palette of ink, umber brown and warm ochre and lichen green, soft directional light, full body in gentle profile, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### sunda-pangolin-context-01 — habitat, aspect 3:2

```
Fine natural-history plate illustration of Sunda Pangolin (Manis javanica), overlapping dark-brown keratin scales in 15–19 rows across the back, a long slender prehensile tail often tipped with a few pale scales, a long narrow toothless snout with small eyes, short stout foreclaws tucked under the feet when walking, an unscaled pale belly. Painterly gouache and ink on warm paper texture, muted palette of ink, umber brown and warm ochre and lichen green, soft directional light, the animal small within its characteristic habitat, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### sunda-pangolin-detail-01 — head study, aspect 1:1

```
Fine natural-history plate illustration of Sunda Pangolin (Manis javanica), overlapping dark-brown keratin scales in 15–19 rows across the back, a long slender prehensile tail often tipped with a few pale scales, a long narrow toothless snout with small eyes, short stout foreclaws tucked under the feet when walking, an unscaled pale belly. Painterly gouache and ink on warm paper texture, muted palette of ink, umber brown and warm ochre and lichen green, soft directional light, close head study showing the diagnostic facial features, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### sunda-pangolin-behavior-01 — behavior, aspect 3:2

```
Fine natural-history plate illustration of Sunda Pangolin (Manis javanica), overlapping dark-brown keratin scales in 15–19 rows across the back, a long slender prehensile tail often tipped with a few pale scales, a long narrow toothless snout with small eyes, short stout foreclaws tucked under the feet when walking, an unscaled pale belly. Painterly gouache and ink on warm paper texture, muted palette of ink, umber brown and warm ochre and lichen green, soft directional light, curled tightly into a scaled ball on the forest floor with the soft belly hidden inside, the tail wrapped over the head, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### sunda-pangolin-scale-01 — human scale, aspect 1:1

```
Fine natural-history plate illustration of Sunda Pangolin (Manis javanica), overlapping dark-brown keratin scales in 15–19 rows across the back, a long slender prehensile tail often tipped with a few pale scales, a long narrow toothless snout with small eyes, short stout foreclaws tucked under the feet when walking, an unscaled pale belly. Painterly gouache and ink on warm paper texture, muted palette of ink, umber brown and warm ochre and lichen green, soft directional light, the animal beside a quiet human silhouette for scale, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

## Open questions for AV

1. IUCN Red List species page (https://www.iucnredlist.org/species/12763/123584856) returns 403 to fetchers, so it is not cited; the "Critically Endangered" wording and the "~80% decline 1998–2019" figure come from the IUCN SSC Pangolin Specialist Group and World Land Trust pages, which quote the 2019 assessment. Fine to add the Red List page as a source if you can open it in a browser.
2. `stats.populationAsOf` reads "2019 · per IUCN Red List, via World Land Trust" — an honest chain, but not the house "YEAR · per ORG" shape. Alternative: drop the decline figure and use "No global count" with "2025 · per IUCN" (the 27 Aug 2025 IUCN press release says there is an absence of updated population estimates).
3. Lifespan is "Unknown in the wild" (World Land Trust, National Geographic). Secondary pages mention ~20 years in care; not sourced to tier 1-2, so omitted.
4. Singapore's "~100 wild pangolins" figure: NParks BiodiversitySG page gives it without a year; a search snippet attributes it to a 2016 NParks estimate. Story uses "about a hundred" undated.
5. Mandai's "~20 rescued a year" is from Reverse the Red (co-authored with Mandai); the Night Safari page says "over 20". Story says "some twenty".
6. Trafficking figure: the story uses "equivalent of more than 895,000 pangolins trafficked 2000–2019" (Pangolin SG). TRAFFIC gives "approximately 1,000,000 poached over the last decade"; both are estimates. Chose the dated one.
7. "Most trafficked mammals" is claimed for the pangolin group (Pangolin SG); Sunda specifically is "the mammal most frequently found in illicit trade in Asia". Hook uses the group wording (plural).
8. `media.source` scaffold said "Higgsfield job TODO"; the validator rejects any TODO, so it now reads "Higgsfield job pending". Fill the job ID when the plates exist.
9. Habitat region "Singapore's central nature reserves" (radius 30 km covers the whole island) — NParks publishes the reserves by name; flag if you want only the Borneo region.
10. behavior-01 uses the defensive ball; the alternative was a young riding on its mother's tail (also sourced, NParks). Swap if the ball reads too static.
11. Second program URL is the Night Safari "Pangolin Trail" page because Mandai Nature's project page (mandainature.org, "Scaling up pangolin conservation in Singapore") blocks fetchers (403). Swap in if you can verify it.
12. Fetch-blocked but not cited: WWF pangolin page (403), ZSL pangolin pages (403), Mandai Nature project page (403); SVW's older domain savevietnamswildlife.org now redirects to a spam site — only www.svw.vn is used.
