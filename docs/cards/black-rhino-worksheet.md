# Card worksheet — Black Rhino (Diceros bicornis)

Scaffolded 2026-09-02 by tools/new-card.py. Pipeline: docs/CARD_PRODUCTION_PIPELINE.md; trust bar: docs/CONTENT_TRUST_AND_RIGHTS.md. Delete this file once the card is approved and merged.

## Source-verification checklist

- [ ] Scientific + common name and status wording verified against a primary source (no IUCN API per D-005)
- [ ] Every story sentence maps to a declared source; story 120-220 words
- [ ] Stats (size, lifespan, diet, trend, 4+ threats) each curl-verified; volatile population figures omitted or dated
- [ ] Range generalized: named regions only, radius >= 25 km, no sensitive localities
- [ ] Action: official destination, working HTTPS link, passes the action policy
- [ ] 1+ conservation programs live-verified (`kind: program`; sponsors must be labeled)
- [ ] Insight is genuinely surprising and sourced
- [ ] All URLs pass `python3 tools/check_links.py --all --only black-rhino`
- [ ] Five plates generated (model nano_banana_pro, tecnologiasstellar account), job IDs in the rights record
- [ ] Species-accuracy review of every plate against source reference photos
- [ ] Editorial review done; `editorial.state` flipped in the PR (approval = PR review)
- [ ] `swift test --package-path Packages/WitnessCore` green

## Image prompts (locked template, D-013)

### black-rhino-plate-01 — hero, aspect 2:3

```
Fine natural-history plate illustration of Black Rhino (Diceros bicornis), hooked prehensile upper lip, two keratin horns with the longer front horn ahead of a shorter rear horn, dark grey hairless skin, compact rounded ears, roughly 1.6 m at the shoulder. Painterly gouache and ink on warm paper texture, muted palette of ink, dust ochre and warm slate grey and lichen green, soft directional light, full body in gentle profile, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### black-rhino-context-01 — habitat, aspect 3:2

```
Fine natural-history plate illustration of Black Rhino (Diceros bicornis), hooked prehensile upper lip, two keratin horns with the longer front horn ahead of a shorter rear horn, dark grey hairless skin, compact rounded ears, roughly 1.6 m at the shoulder. Painterly gouache and ink on warm paper texture, muted palette of ink, dust ochre and warm slate grey and lichen green, soft directional light, the animal small within its characteristic habitat, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### black-rhino-detail-01 — head study, aspect 1:1

```
Fine natural-history plate illustration of Black Rhino (Diceros bicornis), hooked prehensile upper lip, two keratin horns with the longer front horn ahead of a shorter rear horn, dark grey hairless skin, compact rounded ears, roughly 1.6 m at the shoulder. Painterly gouache and ink on warm paper texture, muted palette of ink, dust ochre and warm slate grey and lichen green, soft directional light, close head study showing the diagnostic facial features, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### black-rhino-behavior-01 — behavior, aspect 3:2

```
Fine natural-history plate illustration of Black Rhino (Diceros bicornis), hooked prehensile upper lip, two keratin horns with the longer front horn ahead of a shorter rear horn, dark grey hairless skin, compact rounded ears, roughly 1.6 m at the shoulder. Painterly gouache and ink on warm paper texture, muted palette of ink, dust ochre and warm slate grey and lichen green, soft directional light, browsing with the hooked upper lip curled around a thorny branch, pulling leaves into the mouth, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### black-rhino-scale-01 — human scale, aspect 1:1

```
Fine natural-history plate illustration of Black Rhino (Diceros bicornis), hooked prehensile upper lip, two keratin horns with the longer front horn ahead of a shorter rear horn, dark grey hairless skin, compact rounded ears, roughly 1.6 m at the shoulder. Painterly gouache and ink on warm paper texture, muted palette of ink, dust ochre and warm slate grey and lichen green, soft directional light, the animal beside a quiet human silhouette for scale, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

## Open questions for AV

1. Media `source` reads "Higgsfield job pending" instead of the scaffold's "job TODO": the validator rejects any TODO, and the brief requires a clean run. Replace with the real job ID once the plates are generated; verificationStatus is still "pending".
2. Western black rhino declaration date: Save the Rhino's species page, its 2013 article, and IRF all say 2011; a separate Save the Rhino article dated 28 Feb 2012 frames it as a 2012 Red List update. I used 2011 (the Red List 2011.2 release). Confirm you're happy with 2011.
3. Lifespan: Save the Rhino says 30–35 years in the wild; IRF says 35–40. Card uses 30–35 per Save the Rhino. Pick one.
4. Historical low: IRF says ~2,300 by 1993; Save the Rhino says ~2,400 by 1992; SDZWA says "96 percent by the early 1990s." Card uses 1993 / ~2,300 (IRF). All agree on ~65,000 in 1970 and 96 percent.
5. Namibia's share: the Save the Rhino MEFT page says "more than a third of Africa's black rhino population"; its SRT page says "almost 35% of the world's". Card uses the MEFT wording ("more than a third of Africa's").
6. Story sentence 8 uses South Africa's 2024 poaching total (420, all rhino species) — it is not black-rhino-specific. Acceptable as horn-trade context, or swap for the continental 516 / 2.15% figure?
7. Kenya is named in generalizedRange but has no dedicated story line: the KWS site fails SSL verification in tools/check_links.py (certificate chain), so its 2022–2026 recovery plan (target 1,200 by end-2026) could not be cited. If you want Kenya in the story, a fetchable KWS or Save the Rhino Kenya page is needed.
8. IUCN Red List species page and WWF-US black rhino page are behind JS bot gates (403 to WebFetch and curl); neither is cited. Status wording "Critically Endangered" comes from the IUCN press release (Aug 2025) instead.
9. habitatRegions: two coarse circles (Kunene–Etosha 250 km; Zimbabwe Lowveld 120 km). Confirm you don't want a Kenya circle instead of Zimbabwe.
10. Save the Rhino Trust's own site (savetherhinotrust.org) returned 404 to the fetcher, so program 1 links to Save the Rhino International's SRT programme page. Swap to SRT's own URL if it resolves for you.
