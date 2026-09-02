# Card worksheet — Great Indian Bustard (Ardeotis nigriceps)

Scaffolded 2026-09-02 by tools/new-card.py. Pipeline: docs/CARD_PRODUCTION_PIPELINE.md; trust bar: docs/CONTENT_TRUST_AND_RIGHTS.md. Delete this file once the card is approved and merged.

## Source-verification checklist

- [ ] Scientific + common name and status wording verified against a primary source (no IUCN API per D-005)
- [ ] Every story sentence maps to a declared source; story 120-220 words
- [ ] Stats (size, lifespan, diet, trend, 4+ threats) each curl-verified; volatile population figures omitted or dated
- [ ] Range generalized: named regions only, radius >= 25 km, no sensitive localities
- [ ] Action: official destination, working HTTPS link, passes the action policy
- [ ] 1+ conservation programs live-verified (`kind: program`; sponsors must be labeled)
- [ ] Insight is genuinely surprising and sourced
- [ ] All URLs pass `python3 tools/check_links.py --all --only great-indian-bustard`
- [ ] Five plates generated (model nano_banana_pro, tecnologiasstellar account), job IDs in the rights record
- [ ] Species-accuracy review of every plate against source reference photos
- [ ] Editorial review done; `editorial.state` flipped in the PR (approval = PR review)
- [ ] `swift test --package-path Packages/WitnessCore` green

## Image prompts (locked template, D-013)

### great-indian-bustard-plate-01 — hero, aspect 2:3

```
Fine natural-history plate illustration of Great Indian Bustard (Ardeotis nigriceps), a tall long-legged bustard just over a metre high with a heavy horizontal body, black crown cap on a pale head, long whitish neck and underparts with a narrow black breast-band, finely marked sandy-brown back and wings, held in a slow upright walk. Painterly gouache and ink on warm paper texture, muted palette of ink, sand ochre and pale buff and lichen green, soft directional light, full body in gentle profile, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### great-indian-bustard-context-01 — habitat, aspect 3:2

```
Fine natural-history plate illustration of Great Indian Bustard (Ardeotis nigriceps), a tall long-legged bustard just over a metre high with a heavy horizontal body, black crown cap on a pale head, long whitish neck and underparts with a narrow black breast-band, finely marked sandy-brown back and wings, held in a slow upright walk. Painterly gouache and ink on warm paper texture, muted palette of ink, sand ochre and pale buff and lichen green, soft directional light, the animal small within its characteristic habitat, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### great-indian-bustard-detail-01 — head study, aspect 1:1

```
Fine natural-history plate illustration of Great Indian Bustard (Ardeotis nigriceps), a tall long-legged bustard just over a metre high with a heavy horizontal body, black crown cap on a pale head, long whitish neck and underparts with a narrow black breast-band, finely marked sandy-brown back and wings, held in a slow upright walk. Painterly gouache and ink on warm paper texture, muted palette of ink, sand ochre and pale buff and lichen green, soft directional light, close head study showing the diagnostic facial features, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### great-indian-bustard-behavior-01 — behavior, aspect 3:2

```
Fine natural-history plate illustration of Great Indian Bustard (Ardeotis nigriceps), a tall long-legged bustard just over a metre high with a heavy horizontal body, black crown cap on a pale head, long whitish neck and underparts with a narrow black breast-band, finely marked sandy-brown back and wings, held in a slow upright walk. Painterly gouache and ink on warm paper texture, muted palette of ink, sand ochre and pale buff and lichen green, soft directional light, a male at a yearly lek with neck feathers inflated, tail raised, leaping in display on short open grassland at first light, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### great-indian-bustard-scale-01 — human scale, aspect 1:1

```
Fine natural-history plate illustration of Great Indian Bustard (Ardeotis nigriceps), a tall long-legged bustard just over a metre high with a heavy horizontal body, black crown cap on a pale head, long whitish neck and underparts with a narrow black breast-band, finely marked sandy-brown back and wings, held in a slow upright walk. Painterly gouache and ink on warm paper texture, muted palette of ink, sand ochre and pale buff and lichen green, soft directional light, the animal beside a quiet human silhouette for scale, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

## Open questions for AV

1. IUCN Red List species page (https://www.iucnredlist.org/species/22691932/134188105) returned 403 to every fetch, so it is not cited; "Critically Endangered" is taken from WII's 2020 report ("Critically Endangered (IUCN 2018)") and BirdLife's 2021 article. Add the IUCN page as a source once it can be opened.
2. The July 2026 WII "Status and trend of Great Indian Bustard ... in Thar" report (130 ± 21, stable since 2017–18, 16% of Thar occupied) is not findable on wii.gov.in; the figure is cited via The Tribune's report of the ministerial release. Swap in the WII PDF when it appears.
3. Trend is set to "stable" per that 2026 WII survey; the long-term picture (and IUCN's assessment) is decreasing. Decide which the card should show.
4. Lifespan: no tier-1/2 source gives a lifespan; only fan sites say 10–15 years. The stat shows "Slow life history · ~9-year generation time" (WII 2020–22 report's generation time). Accept, or find a lifespan source.
5. Size: "just over one metre" and "close to 15 kg" are for adult males (Corbett Foundation Kutch blog). Captive adults at Sam weighed 3.6–5 kg (females) and 5–9 kg (males) per WII's 2022–23 report; the 15 kg figure is a maximum. BirdLife calls it "the world's heaviest flying bird"; WII says "one of the heaviest" — the card uses the WII wording.
6. Prompt feature "black crown cap" comes from the species name (nigriceps) and general references, not from a cited page; the black breast-band and whitish neck are from the Corbett blog. Please confirm against reference photos before plates.
7. "Seventy birds" and "first soft releases due this year" are from the environment minister's March 2026 statement (AIR News). Check whether releases actually happened before the 2026-09-21 publish date.
8. "Up from sixteen in 2022" compares the March 2022 PIB count at Sam alone with the 2026 count across Sam + Ramdevra; Ramdevra opened August 2022. Fair as a chronology, but say if you'd rather use WII's 22 birds (2023).
9. Habitat regions: Desert National Park / Jaisalmer district (radius 120 km) and Kutch (radius 60 km) are public sanctuaries; the Sam and Ramdevra centres are named as "near Jaisalmer" only. Confirm this is coarse enough.
10. The BNHS Khetolai reserve program URL is a BNHS blog post (Feb 2025), not a permanent programme page; BNHS has no dedicated GIB page I could find. Same for The Corbett Foundation (blog post used as a source only).
11. Story section 6 compresses two orders (19 April 2021 restrictions over ~99,000 km²; 19 December 2025 revised priority area of 14,013 km² in Rajasthan, 80 km of 33 kV lines undergrounded immediately, no new wind turbines or solar >2 MW inside it). The March 2024 modification is omitted for length.
