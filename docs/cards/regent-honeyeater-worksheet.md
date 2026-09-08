# Card worksheet — Regent Honeyeater (Anthochaera phrygia)

Scaffolded 2026-09-08 by tools/new-card.py. Pipeline: docs/CARD_PRODUCTION_PIPELINE.md; trust bar: docs/CONTENT_TRUST_AND_RIGHTS.md. Delete this file once the card is approved and merged.

## Source-verification checklist

- [ ] Scientific + common name and status wording verified against a primary source (no IUCN API per D-005)
- [ ] Every story sentence maps to a declared source; story 120-220 words
- [ ] Stats (size, lifespan, diet, trend, 4+ threats) each curl-verified; volatile population figures omitted or dated
- [ ] Range generalized: named regions only, radius >= 25 km, no sensitive localities
- [ ] Action: official destination, working HTTPS link, passes the action policy
- [ ] 1+ conservation programs live-verified (`kind: program`; sponsors must be labeled)
- [ ] Insight is genuinely surprising and sourced
- [ ] All URLs pass `python3 tools/check_links.py --all --only regent-honeyeater`
- [ ] Five plates generated (model nano_banana_pro, tecnologiasstellar account), job IDs in the rights record
- [ ] Species-accuracy review of every plate against source reference photos
- [ ] Editorial review done; `editorial.state` flipped in the PR (approval = PR review)
- [ ] `swift test --package-path Packages/WitnessCore` green

## Image prompts (locked template, D-013)

### regent-honeyeater-plate-01 — hero, aspect 2:3

```
Fine natural-history plate illustration of Regent Honeyeater (Anthochaera phrygia), a black hood covering head, neck and upper breast, lemon-yellow back and breast scaled with black crescents, black wings with bold yellow patches, a black tail edged yellow, and warty pale-yellow bare skin around the dark eye. Painterly gouache and ink on warm paper texture, muted palette of ink, lemon yellow and ironbark-bark ochre and lichen green, soft directional light, full body in gentle profile, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### regent-honeyeater-context-01 — habitat, aspect 3:2

```
Fine natural-history plate illustration of Regent Honeyeater (Anthochaera phrygia), a black hood covering head, neck and upper breast, lemon-yellow back and breast scaled with black crescents, black wings with bold yellow patches, a black tail edged yellow, and warty pale-yellow bare skin around the dark eye. Painterly gouache and ink on warm paper texture, muted palette of ink, lemon yellow and ironbark-bark ochre and lichen green, soft directional light, the animal small within its characteristic habitat, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### regent-honeyeater-detail-01 — head study, aspect 1:1

```
Fine natural-history plate illustration of Regent Honeyeater (Anthochaera phrygia), a black hood covering head, neck and upper breast, lemon-yellow back and breast scaled with black crescents, black wings with bold yellow patches, a black tail edged yellow, and warty pale-yellow bare skin around the dark eye. Painterly gouache and ink on warm paper texture, muted palette of ink, lemon yellow and ironbark-bark ochre and lichen green, soft directional light, close head study showing the diagnostic facial features, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### regent-honeyeater-behavior-01 — behavior, aspect 3:2

```
Fine natural-history plate illustration of Regent Honeyeater (Anthochaera phrygia), a black hood covering head, neck and upper breast, lemon-yellow back and breast scaled with black crescents, black wings with bold yellow patches, a black tail edged yellow, and warty pale-yellow bare skin around the dark eye. Painterly gouache and ink on warm paper texture, muted palette of ink, lemon yellow and ironbark-bark ochre and lichen green, soft directional light, the bird feeding at ironbark blossom, head thrust into the flowers for nectar, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### regent-honeyeater-scale-01 — human scale, aspect 1:1

```
Fine natural-history plate illustration of Regent Honeyeater (Anthochaera phrygia), a black hood covering head, neck and upper breast, its single most conspicuous feature a prominent patch of warty pale-yellow bare skin encircling the dark eye, the hood otherwise unbroken black with no yellow anywhere on the head or throat, lemon-yellow back and breast scaled with black crescents, black wings with bold yellow patches, a black tail edged yellow. Painterly gouache and ink on warm paper texture, muted palette of ink, lemon yellow and ironbark-bark ochre and lichen green, soft directional light, the animal beside a quiet human silhouette for scale, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

> Species block amended 2026-09-08 after the accuracy review: the original wording stated the diagnostic as a negation, which the model ignored across four attempts. The style wording and the composition line are unchanged, and `docs/ART_PROMPT_TEMPLATE.md` is untouched — D-013 varies only the species block. This is the prompt that produced the kept file.


## Open questions for AV

1. Population figure drift: BirdLife 2024 says "250 to 300 ... probably at the lower end"; NSW Eye Spy (Oct 2025) says "approximately 300"; the Proc B paper says 200–400; ANU 2026 and Zoos Victoria say "fewer than 250"; SWIFFT (Victoria) still shows a stale "800 to 1,500". Card uses "250–300 wild birds" dated 2024 per Taronga. Pick a different anchor if you prefer the lower ANU 2026 figure.
2. "Flocks of thousands" (the brief's angle) is only on SWIFFT (Victorian govt-supported volunteer network, not cited). The Proc B paper says "flocks of hundreds", which the card uses. Say if you want the bigger claim and I will cite SWIFFT.
3. Historical range endpoints differ by source: BirdLife "Rockhampton to Adelaide"; NSW determination "south-east South Australia to south-east Queensland"; SWIFFT "100 km north of Brisbane ... Adelaide Hills". Card says Adelaide to Rockhampton (BirdLife).
4. Bot-gated/timed out: DCCEEW SPRAT profile (403), the DCCEEW recovery-plan page, the agriculture.gov.au recovery plan PDF and the DCCEEW 2015 consultation PDF (all timed out three times), environment.vic.gov.au (403), taronga.org.au older media releases (404 or index page). No Commonwealth primary source is cited; status "Critically Endangered" rests on BirdLife (EPBC + IUCN) and the NSW 2010 determination. Worth a manual read of SPRAT before approval.
5. Lifespan: no tier-1/2 figure found; card says "Not well documented" per the brief.
6. Song tutoring percentages: the PMC 2026 paper reports 42 percent of the male zoo population by year 3; ANU's news story (same authors) says "over 50 percent". Card uses "over half" citing ANU; swap to "42 percent" if you want the paper's number.
7. "Only the zoo birds could still be taught it" paraphrases the 2026 paper's claim that the traditional song "has effectively disappeared from the wild population" since 2020 and that the zoo is "the only remaining source". Confirm the wording is not stronger than the paper.
8. Chiltern release size: the Victorian Premier's 2017 release says "around 100"; SWIFFT lists 27 (2008), 44 (2010), 38 (2013), 77 (2015). Card cites only the 2017 release ("around a hundred ... in 2017"); add SWIFFT as a source if you want the full Chiltern series.
9. Trend "decreasing" rests on the 2010 determination (>80 percent decline in three generations) and BirdLife's account of late-1900s collapse; no source gives a current-decade trend. BirdLife notes 2022 had no successful nest detected. Fine to keep or switch to "unknown".
10. Threat 4 "Nest predation by possums & gliders" comes from BirdLife's Capertee article (tree guards against Brush-tailed Possums and Sugar Gliders). Climate change is in the NSW determination if you'd rather list it instead.
11. Program 2 URL is a Taronga news page (2024 release), because Taronga's dedicated program page 404s. Replace if you find a live program page.
12. Insight says playback "did nothing" in year 1 — the paper says no juveniles in the control or initial treatment groups learned the wild song in year 1. Keep or soften to "failed".
