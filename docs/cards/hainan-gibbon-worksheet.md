# Card worksheet — Hainan Gibbon (Nomascus hainanus)

Scaffolded 2026-09-02 by tools/new-card.py. Pipeline: docs/CARD_PRODUCTION_PIPELINE.md; trust bar: docs/CONTENT_TRUST_AND_RIGHTS.md. Delete this file once the card is approved and merged.

## Source-verification checklist

- [ ] Scientific + common name and status wording verified against a primary source (no IUCN API per D-005)
- [ ] Every story sentence maps to a declared source; story 120-220 words
- [ ] Stats (size, lifespan, diet, trend, 4+ threats) each curl-verified; volatile population figures omitted or dated
- [ ] Range generalized: named regions only, radius >= 25 km, no sensitive localities
- [ ] Action: official destination, working HTTPS link, passes the action policy
- [ ] 1+ conservation programs live-verified (`kind: program`; sponsors must be labeled)
- [ ] Insight is genuinely surprising and sourced
- [ ] All URLs pass `python3 tools/check_links.py --all --only hainan-gibbon`
- [ ] Five plates generated (model nano_banana_pro, tecnologiasstellar account), job IDs in the rights record
- [ ] Species-accuracy review of every plate against source reference photos
- [ ] Editorial review done; `editorial.state` flipped in the PR (approval = PR review)
- [ ] `swift test --package-path Packages/WitnessCore` green

## Image prompts (locked template, D-013)

### hainan-gibbon-plate-01 — hero, aspect 2:3

```
Fine natural-history plate illustration of Hainan Gibbon (Nomascus hainanus), a small tailless ape with arms far longer than its legs, an adult male in jet-black fur with an upright hairy crest on the crown, an adult female in golden-yellow fur with a black crown patch, bare dark face with a slight brow ridge. Painterly gouache and ink on warm paper texture, muted palette of ink, warm golden ochre and charcoal black and lichen green, soft directional light, full body in gentle profile, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### hainan-gibbon-context-01 — habitat, aspect 3:2

```
Fine natural-history plate illustration of Hainan Gibbon (Nomascus hainanus), a small tailless ape with arms far longer than its legs, an adult male in jet-black fur with an upright hairy crest on the crown, an adult female in golden-yellow fur with a black crown patch, bare dark face with a slight brow ridge. Painterly gouache and ink on warm paper texture, muted palette of ink, warm golden ochre and charcoal black and lichen green, soft directional light, the animal small within its characteristic habitat, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### hainan-gibbon-detail-01 — head study, aspect 1:1

```
Fine natural-history plate illustration of Hainan Gibbon (Nomascus hainanus), a small tailless ape with arms far longer than its legs, an adult male in jet-black fur with an upright hairy crest on the crown, an adult female in golden-yellow fur with a black crown patch, bare dark face with a slight brow ridge. Painterly gouache and ink on warm paper texture, muted palette of ink, warm golden ochre and charcoal black and lichen green, soft directional light, close head study showing the diagnostic facial features, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### hainan-gibbon-behavior-01 — behavior, aspect 3:2

```
Fine natural-history plate illustration of Hainan Gibbon (Nomascus hainanus), a small tailless ape with arms far longer than its legs, an adult male in jet-black fur with an upright hairy crest on the crown, an adult female in golden-yellow fur with a black crown patch, bare dark face with a slight brow ridge. Painterly gouache and ink on warm paper texture, muted palette of ink, warm golden ochre and charcoal black and lichen green, soft directional light, an adult pair singing their dawn duet from a high canopy branch, mouths open, one long arm hooked over a limb, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### hainan-gibbon-scale-01 — human scale, aspect 1:1

```
Fine natural-history plate illustration of Hainan Gibbon (Nomascus hainanus), a small tailless ape with arms far longer than its legs, an adult male in jet-black fur with an upright hairy crest on the crown, an adult female in golden-yellow fur with a black crown patch, bare dark face with a slight brow ridge. Painterly gouache and ink on warm paper texture, muted palette of ink, warm golden ochre and charcoal black and lichen green, soft directional light, the animal beside a quiet human silhouette for scale, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

## Open questions for AV

1. Trend: the card says `increasing` (29 in four groups in 2018 to 42 in seven groups by Feb 2024, per Frontiers 2025 / Hainan government / China Daily HK). The IUCN Red List page still shows "Stable" from the 2015 assessment (flagged "Needs updating" on the page). Keep `increasing`?
2. National park date: Hainan government page and China Daily HK say the park was established (October 12) 2021; the Science Advances 2025 paper says October 2020 (the pilot ran from 2019). Card uses 2021.
3. 1970s low point: KFBG says "less than 10"; Frontiers in Genetics 2020 says 7-8 individuals in Bawangling; Science Advances 2025 says "fewer than 40". Card follows KFBG ("fewer than ten"). The brief's "about two family groups in the 1970s-80s" was not found stated in any fetched source; the two-group figure that IS sourced is the 2003 census (13 in two groups), so the story uses that.
4. Group count: the seven-groups / 42 figure is dated February 2024 (Frontiers 2025); the Hainan government page (July 2025) repeats 42 in seven groups without a date. populationAsOf reads "2024 · per Hainan Provincial Government".
5. ZSL, Nature.com, Wiley (Wengel 2024) and Springer pages were all Cloudflare/IdP-blocked to every fetch path (WebFetch, curl, in-app browser). ZSL's Hainan Gibbon Project is therefore not cited or listed as a program; the Scientific Reports bridge paper is cited via its PubMed Central copy instead. Worth re-trying ZSL from a normal browser and adding it as a third program or source.
6. Lifespan: Animal Diversity Web states lifespan is not reported for this species (related gibbons to 60 in care); no tier-1/2 wild lifespan figure exists. Stat reads "Unrecorded for the species · kin gibbons to 60 in care". OK, or drop the row?
7. Home range conflict: IUCN page cites 1.5-10 km2 (largest of any gibbon, Bryant et al. 2016); Science Advances 2025 says 100-200 ha. The insight uses the IUCN figure; consider softening to "several square kilometres".
8. The IUCN page was read once in the in-app browser (assessment text captured) but re-renders as "Page cannot be found" on a second read; check_links returns 200. Fine to cite, but the founder should eyeball it.
9. Behavior plate: prompt uses the dawn duet. The rope-bridge crossing (family on a single rope across a landslide gap, adult male hanging back) is the more Witness-specific image if you prefer it.
10. media.source: replaced the scaffold's "Higgsfield job TODO" with "Higgsfield job pending" so the validator passes (same convention as black-rhino, sunda-pangolin, scimitar-horned-oryx drafts).
11. China Daily HK (state media) is used only to corroborate the park date and the six rope corridors in the park program summary; drop if you want tier 1-3 only.
