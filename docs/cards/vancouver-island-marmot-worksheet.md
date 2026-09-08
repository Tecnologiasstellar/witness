# Card worksheet — Vancouver Island Marmot (Marmota vancouverensis)

Scaffolded 2026-09-08 by tools/new-card.py. Pipeline: docs/CARD_PRODUCTION_PIPELINE.md; trust bar: docs/CONTENT_TRUST_AND_RIGHTS.md. Delete this file once the card is approved and merged.

## Source-verification checklist

- [ ] Scientific + common name and status wording verified against a primary source (no IUCN API per D-005)
- [ ] Every story sentence maps to a declared source; story 120-220 words
- [ ] Stats (size, lifespan, diet, trend, 4+ threats) each curl-verified; volatile population figures omitted or dated
- [ ] Range generalized: named regions only, radius >= 25 km, no sensitive localities
- [ ] Action: official destination, working HTTPS link, passes the action policy
- [ ] 1+ conservation programs live-verified (`kind: program`; sponsors must be labeled)
- [ ] Insight is genuinely surprising and sourced
- [ ] All URLs pass `python3 tools/check_links.py --all --only vancouver-island-marmot`
- [ ] Five plates generated (model nano_banana_pro, tecnologiasstellar account), job IDs in the rights record
- [ ] Species-accuracy review of every plate against source reference photos
- [ ] Editorial review done; `editorial.state` flipped in the PR (approval = PR review)
- [ ] `swift test --package-path Packages/WitnessCore` green

## Image prompts (locked template, D-013)

### vancouver-island-marmot-plate-01 — hero, aspect 2:3

```
Fine natural-history plate illustration of Vancouver Island Marmot (Marmota vancouverensis), rich chocolate-brown fur with irregular white patches on the nose, chin, forehead and chest, a stocky groundhog-like body about 65–70 cm from nose to the tip of a bushy tail, short sturdy digging forelimbs, and a broad blunt muzzle. Painterly gouache and ink on warm paper texture, muted palette of ink, warm chocolate umber and a touch of lupine violet and lichen green, soft directional light, full body in gentle profile, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### vancouver-island-marmot-context-01 — habitat, aspect 3:2

```
Fine natural-history plate illustration of Vancouver Island Marmot (Marmota vancouverensis), rich chocolate-brown fur with irregular white patches on the nose, chin, forehead and chest, a stocky groundhog-like body about 65–70 cm from nose to the tip of a bushy tail, short sturdy digging forelimbs, and a broad blunt muzzle. Painterly gouache and ink on warm paper texture, muted palette of ink, warm chocolate umber and a touch of lupine violet and lichen green, soft directional light, the animal small within its characteristic habitat, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### vancouver-island-marmot-detail-01 — head study, aspect 1:1

```
Fine natural-history plate illustration of Vancouver Island Marmot (Marmota vancouverensis), rich chocolate-brown fur with irregular white patches on the nose, chin, forehead and chest, a stocky groundhog-like body about 65–70 cm from nose to the tip of a bushy tail, short sturdy digging forelimbs, and a broad blunt muzzle. Painterly gouache and ink on warm paper texture, muted palette of ink, warm chocolate umber and a touch of lupine violet and lichen green, soft directional light, close head study showing the diagnostic facial features, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### vancouver-island-marmot-behavior-01 — behavior, aspect 3:2

```
Fine natural-history plate illustration of Vancouver Island Marmot (Marmota vancouverensis), rich chocolate-brown fur with irregular white patches on the nose, chin, forehead and chest, a stocky groundhog-like body about 65–70 cm from nose to the tip of a bushy tail, short sturdy digging forelimbs, and a broad blunt muzzle. Painterly gouache and ink on warm paper texture, muted palette of ink, warm chocolate umber and a touch of lupine violet and lichen green, soft directional light, the animal upright on a meadow boulder, mouth open in a whistled alarm call to its colony, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### vancouver-island-marmot-scale-01 — human scale, aspect 1:1

```
Fine natural-history plate illustration of Vancouver Island Marmot (Marmota vancouverensis), rich chocolate-brown fur with irregular white patches on the nose, chin, forehead and chest, a stocky groundhog-like body about 65–70 cm from nose to the tip of a bushy tail, short sturdy digging forelimbs, and a broad blunt muzzle. Painterly gouache and ink on warm paper texture, muted palette of ink, warm chocolate umber and a touch of lupine violet and lichen green, soft directional light, the animal beside a quiet human silhouette for scale, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

## Open questions for AV

1. **Status wording.** Card uses the IUCN global category "Critically Endangered" (readable on the Wilder Institute program page and in the 2024 PMC paper). Canada's SARA Schedule 1 and COSEWIC (2008) list it as "Endangered". The IUCN Red List page itself returned HTTP 403 (bot-gated) so it is not cited. Keep IUCN wording, or switch to the national "Endangered"?
2. **2003 low: "fewer than 30" vs "22".** Marmot Recovery Foundation (MRF) pages say "less than 30" (current-status) and "fewer than 30" (home, dated 2004); the recovery strategy says "fewer than 30 mature wild-born individuals" in 2000; CHLY news (Dec 2025) and a Wilder snippet say "22 in 2003". I used "fewer than 30" everywhere. The sharper "22" would make a better hook but I could not source it from a primary page.
3. **Colony count drift: 35 vs 37.** MRF current-status says 35 active colonies going into winter 2025–26; the Wilder Institute program page says "37 active colonies as of 2025" and "over 425" marmots. Card follows MRF (427, 35).
4. **Releases total: 725 vs 630 vs 529.** Wilder program page: 725 released since 2003 by MRF; PMC 2024 paper: 630 as of 2023; PMC 2022 paper: 529 between 2003 and 2020. Consistent trajectory; card uses 725 and cites Wilder. MRF's own pages do not state a running total.
5. **Endemic mammal count.** Toronto Zoo says "one of only six mammals endemic to Canada"; COSEWIC and Wilder say "one of only five". Card avoids the number.
6. **Predation figure.** "80% of mortality from wolves, cougars and golden eagles" is MRF's figure for 1995–2005 in the south-island area; COSEWIC ch. 8 gives no percentage. Story says "80 percent of those that died" without the date scope — add "1995–2005" if you want it tighter (costs words).
7. **Population history figures.** 1984 ≈ 325 and 1972 = 125 come from the 2020 recovery strategy; 1998 = 70 from MRF history page. Recovery strategy says "approximately 70" in the late 1990s. Fine, but flagging that these are estimates from partial surveys.
8. **Mount Washington in the program text.** The program summary names the Tony Barrett Mount Washington Marmot Recovery Centre (a public facility on a ski resort, named on MRF's site). Habitat regions are region-level (Nanaimo Lakes highlands 40 km; Strathcona/Forbidden Plateau 60 km) and do not point at any colony. OK to keep the centre's name?
9. **Size stat.** MRF profile: 65–70 cm nose to tail, females 4.5–5.5 kg, males up to 7.5 kg. The 2020 recovery strategy gives a smaller average (668 mm, 3.76 kg average, males up to 7.5 kg) — spring vs autumn weights differ by a third. Card: "26–28 in nose to tail · males up to 16.5 lbs (7.5 kg)".
10. **Lifespan.** MRF: "over 10 years in the wild (10–15 in captivity)"; recovery strategy: oldest wild female 10, captive to at least 14. Card follows MRF wording.
11. **Wilder Institute pages needed curl.** WebFetch returned only navigation for wilderinstitute.org; the program page body was read via curl (full text confirmed: >900 born program-wide, >250 at Wilder, 725 released, 35→37 colonies). Toronto Zoo page (torontozoo.com/tz/vim) says "over 200 wild marmots" — stale; only used for 1997/six marmots/gestation.
12. **BC government PDFs** (2008 recovery strategy, IWMS account, brochure) came back as unreadable binary via WebFetch; the sararegistry COSEWIC PDF reset the connection. All BC facts are taken instead from the canada.ca HTML versions. If you want a provincial source, the a100.gov.bc.ca species summary is a candidate to open manually.

