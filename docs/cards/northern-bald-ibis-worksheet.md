# Card worksheet — Northern Bald Ibis (Geronticus eremita)

Scaffolded 2026-09-08 by tools/new-card.py. Pipeline: docs/CARD_PRODUCTION_PIPELINE.md; trust bar: docs/CONTENT_TRUST_AND_RIGHTS.md. Delete this file once the card is approved and merged.

## Source-verification checklist

- [ ] Scientific + common name and status wording verified against a primary source (no IUCN API per D-005)
- [ ] Every story sentence maps to a declared source; story 120-220 words
- [ ] Stats (size, lifespan, diet, trend, 4+ threats) each curl-verified; volatile population figures omitted or dated
- [ ] Range generalized: named regions only, radius >= 25 km, no sensitive localities
- [ ] Action: official destination, working HTTPS link, passes the action policy
- [ ] 1+ conservation programs live-verified (`kind: program`; sponsors must be labeled)
- [ ] Insight is genuinely surprising and sourced
- [ ] All URLs pass `python3 tools/check_links.py --all --only northern-bald-ibis`
- [ ] Five plates generated (model nano_banana_pro, tecnologiasstellar account), job IDs in the rights record
- [ ] Species-accuracy review of every plate against source reference photos
- [ ] Editorial review done; `editorial.state` flipped in the PR (approval = PR review)
- [ ] `swift test --package-path Packages/WitnessCore` green

## Image prompts (locked template, D-013)

### northern-bald-ibis-plate-01 — hero, aspect 2:3

```
Fine natural-history plate illustration of Northern Bald Ibis (Geronticus eremita), glossy black plumage with green and violet iridescence, a bare wrinkled red face and crown with individual black markings, a ragged crest of long lance-shaped black feathers on the nape, a long slender down-curved red bill, strong red legs, no visible difference between sexes. Painterly gouache and ink on warm paper texture, muted palette of ink, dull vermilion and oil-slick green-violet iridescence and lichen green, soft directional light, full body in gentle profile, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### northern-bald-ibis-context-01 — habitat, aspect 3:2

```
Fine natural-history plate illustration of Northern Bald Ibis (Geronticus eremita), glossy black plumage with green and violet iridescence, a bare wrinkled red face and crown with individual black markings, a ragged crest of long lance-shaped black feathers on the nape, a long slender down-curved red bill, strong red legs, no visible difference between sexes. Painterly gouache and ink on warm paper texture, muted palette of ink, dull vermilion and oil-slick green-violet iridescence and lichen green, soft directional light, the animal small within its characteristic habitat, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### northern-bald-ibis-detail-01 — head study, aspect 1:1

```
Fine natural-history plate illustration of Northern Bald Ibis (Geronticus eremita), glossy black plumage with green and violet iridescence, a bare wrinkled red face and crown with individual black markings, a ragged crest of long lance-shaped black feathers on the nape, a long slender down-curved red bill, strong red legs, no visible difference between sexes. Painterly gouache and ink on warm paper texture, muted palette of ink, dull vermilion and oil-slick green-violet iridescence and lichen green, soft directional light, close head study showing the diagnostic facial features, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### northern-bald-ibis-behavior-01 — behavior, aspect 3:2

```
Fine natural-history plate illustration of Northern Bald Ibis (Geronticus eremita), glossy black plumage with green and violet iridescence, a bare wrinkled red face and crown with individual black markings, a ragged crest of long lance-shaped black feathers on the nape, a long slender down-curved red bill, strong red legs, no visible difference between sexes. Painterly gouache and ink on warm paper texture, muted palette of ink, dull vermilion and oil-slick green-violet iridescence and lichen green, soft directional light, a small group foraging on a short-grass meadow, bills probing the soil for larvae, one bird with its crest raised, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### northern-bald-ibis-scale-01 — human scale, aspect 1:1

```
Fine natural-history plate illustration of Northern Bald Ibis (Geronticus eremita), glossy black plumage with green and violet iridescence, a bare wrinkled red face and crown with individual black markings, a ragged crest of long lance-shaped black feathers on the nape, a long slender down-curved red bill, strong red legs, no visible difference between sexes. Painterly gouache and ink on warm paper texture, muted palette of ink, dull vermilion and oil-slick green-violet iridescence and lichen green, soft directional light, the animal beside a quiet human silhouette for scale, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

## Open questions for AV

1. **Population figure drift.** The card carries the 2018 Moroccan census (147 pairs, 708 birds; Böhm et al. 2021, Schenker et al. 2019). Nothing newer than 2018 was fetchable from a citable source; MaghrebOrnitho (blog) and CNN repeat "more than 500" or "about 700" without a new count. Zoo Zürich's lexicon still says "450 wild individuals" — clearly stale. Fine to publish "about 700 (2018)" or hold for a 2024/25 GREPOM/HCEFLCD figure?
2. **Europe's reintroduced count.** Zoo Vienna says 280 birds in 2025 and a minimum viable population of 357; Hellabrunn (2024) says "more than 250"; Waldrappteam home page says ~200 by 2021. I used Zoo Vienna's 280/357 in the witness sentence. OK to quote a modelled MVP as "could stand alone"?
3. **Birecik dropped from the story for word count.** Böhm et al. give 263 birds in seasonal captivity (2018) and OSME (July 2026) confirms it is non-migratory since 1989 and semi-wild. The generalizedRange still mentions the Türkiye colony. Add it back at the cost of a sentence elsewhere?
4. **"Last bird vanished in 2013" (Syria).** PMC/Animals says 2013; Böhm et al. say the population was lost by 2015; Mongabay's 2025 analysis (not cited) says the female Salam returned for the last time in 2013–14 and scattered immatures were seen in Ethiopia in 2015. I kept 2013 with "vanished", not "died". Check wording.
5. **"Some researchers call the downlisting premature."** PMC/Animals 2022 says the 2018 downlisting "remains controversial". Keep, soften, or drop?
6. **Lifespan.** No wild figure from a citable source. Zoo Vienna says 30 years (captivity); Zoo Zürich says "over 23 years in captivity"; the PMC paper gives none. Stat reads "About 30 years in human care; wild lifespan not well documented".
7. **Size.** Length 60–75 cm and 1.2–1.9 kg from Zoo Zürich; ~1.3 kg from Zoo Vienna; PMC gives males ~1,390 g. Wingspan (125–135 cm) only appeared on tertiary sites, so it is omitted. Add it if AV has a primary source.
8. **Bot-gated / unusable pages.** BirdLife DataZone loads its numbers by JS (fetched shell only), BirdLife's 2018/2019 news posts, the IUCN Red List page, both AEWA pages (species page and the action-plan PDF), and the ACE-Eco Birecik genetics paper all returned 403. Doğa Derneği's ibis URL served its homepage. None are cited.
9. **2025 migration ended in Catalonia, not Andalusia** (29 juveniles, ~800 km, training deficit) and the 2026 migration (30 juveniles) launched 23 Aug from Binningen. The story says "in 2024 … to Andalusia" only, so it stays true; the 2025 page is cited for context. Mention the setback on the card or leave it to the action page?
10. **Hook** ("Extinct in Europe for 400 years. Now it follows a microlight home.") — Böhm et al.: extirpated from central Europe >400 years ago. "Home" is poetic; the birds are reintroduced, not returning. OK?
11. **Trend = increasing** rests on Morocco (59→147 pairs) and Europe/Andalusia growth, while the eastern wild population is gone. Keep "increasing"?
12. **Habitat region centre for the Alps** (47.8N, 11.8E, 200 km) is a broad circle covering Burghausen, Kuchl, Überlingen; Rosegg (Carinthia) and the Italian sites are outside it. Acceptable? A fourth region would exceed the 1–3 limit.
