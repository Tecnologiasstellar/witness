# Card worksheet — Saiga Antelope (Saiga tatarica)

Scaffolded 2026-09-08 by tools/new-card.py. Pipeline: docs/CARD_PRODUCTION_PIPELINE.md; trust bar: docs/CONTENT_TRUST_AND_RIGHTS.md. Delete this file once the card is approved and merged.

## Source-verification checklist

- [ ] Scientific + common name and status wording verified against a primary source (no IUCN API per D-005)
- [ ] Every story sentence maps to a declared source; story 120-220 words
- [ ] Stats (size, lifespan, diet, trend, 4+ threats) each curl-verified; volatile population figures omitted or dated
- [ ] Range generalized: named regions only, radius >= 25 km, no sensitive localities
- [ ] Action: official destination, working HTTPS link, passes the action policy
- [ ] 1+ conservation programs live-verified (`kind: program`; sponsors must be labeled)
- [ ] Insight is genuinely surprising and sourced
- [ ] All URLs pass `python3 tools/check_links.py --all --only saiga-antelope`
- [ ] Five plates generated (model nano_banana_pro, tecnologiasstellar account), job IDs in the rights record
- [ ] Species-accuracy review of every plate against source reference photos
- [ ] Editorial review done; `editorial.state` flipped in the PR (approval = PR review)
- [ ] `swift test --package-path Packages/WitnessCore` green

## Image prompts (locked template, D-013)

### saiga-antelope-plate-01 — hero, aspect 2:3

```
Fine natural-history plate illustration of Saiga Antelope (Saiga tatarica), a sheep-sized antelope with a large inflated downward-drooping proboscis nose that overhangs the mouth, short heavily ridged translucent amber horns on the male only (about 6–10 inches, none on the female), a stooping body on long thin legs, a cinnamon-buff summer coat with creamy-white rump and underparts (thicker and paler in winter), and a large head. Painterly gouache and ink on warm paper texture, muted palette of ink, cinnamon buff, translucent amber and lichen green, soft directional light, full body in gentle profile, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### saiga-antelope-context-01 — habitat, aspect 3:2

```
Fine natural-history plate illustration of Saiga Antelope (Saiga tatarica), a sheep-sized antelope with a large inflated downward-drooping proboscis nose that overhangs the mouth, short heavily ridged translucent amber horns on the male only (about 6–10 inches, none on the female), a stooping body on long thin legs, a cinnamon-buff summer coat with creamy-white rump and underparts (thicker and paler in winter), and a large head. Painterly gouache and ink on warm paper texture, muted palette of ink, cinnamon buff, translucent amber and lichen green, soft directional light, the animal small within its characteristic habitat, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### saiga-antelope-detail-01 — head study, aspect 1:1

```
Fine natural-history plate illustration of Saiga Antelope (Saiga tatarica), a sheep-sized antelope with a large inflated downward-drooping proboscis nose that overhangs the mouth, short heavily ridged translucent amber horns on the male only (about 6–10 inches, none on the female), a stooping body on long thin legs, a cinnamon-buff summer coat with creamy-white rump and underparts (thicker and paler in winter), and a large head. Painterly gouache and ink on warm paper texture, muted palette of ink, cinnamon buff, translucent amber and lichen green, soft directional light, close head study showing the diagnostic facial features, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### saiga-antelope-behavior-01 — behavior, aspect 3:2

```
Fine natural-history plate illustration of Saiga Antelope (Saiga tatarica), a sheep-sized antelope with a large inflated downward-drooping proboscis nose that overhangs the mouth, short heavily ridged translucent amber horns on the male only (about 6–10 inches, none on the female), a stooping body on long thin legs, a cinnamon-buff summer coat with creamy-white rump and underparts (thicker and paler in winter), and a large head. Painterly gouache and ink on warm paper texture, muted palette of ink, cinnamon buff, translucent amber and lichen green, soft directional light, a herd on migration strung out in a long line across open steppe, a ridged-horned male at the front, noses forward, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### saiga-antelope-scale-01 — human scale, aspect 1:1

```
Fine natural-history plate illustration of Saiga Antelope (Saiga tatarica), a sheep-sized antelope with a large inflated downward-drooping proboscis nose that overhangs the mouth, short heavily ridged translucent amber horns on the male only (about 6–10 inches, none on the female), a stooping body on long thin legs, a cinnamon-buff summer coat with creamy-white rump and underparts (thicker and paler in winter), and a large head. Painterly gouache and ink on warm paper texture, muted palette of ink, cinnamon buff, translucent amber and lichen green, soft directional light, the animal beside a quiet human silhouette for scale, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

## Open questions for AV

1. **Status wording.** Global IUCN category is Near Threatened since 11 Dec 2023 (cited via Saiga Conservation Alliance and FZS; the IUCN Red List page itself was not fetched, per D-005). USFWS notes Uzbekistan still lists the saiga as Critically Endangered nationally, and Mongolia's population is a distinct subspecies/species (WCS calls it *Saiga borealis*). Card uses the global category; confirm.
2. **The 2025 cull and horn-export decision are in the story.** Kazakhstan culled ~196,000 saiga (1 Jul–30 Nov 2025, per the Ministry via The Astana Times) and CITES CoP20 (28–29 Nov 2025, Samarkand) approved a 10,000 kg/yr horn export quota for three years. WCS opposed it. This is the honest current state, but it complicates a "success story" card — keep, soften, or cut?
3. **Astana Times is state-affiliated press, not a primary source.** It reports the Ministry of Ecology's own figures. I could not find a gov.kz page I could read. Replace with a primary if you can reach one, or accept as-is.
4. **2005 low-point drift.** SCA/USFWS/Oxford say 48,000 in 2005; WCS and FZS's reclassification release say 39,000. Card avoids 2005 and uses FZS's "21,000 in 2003" (also ~20,000 on the Earthshot page; 21,000 in the CMS/CAMI note). Hook uses 21,000.
5. **2015 die-off share drift.** Kock et al. 2018: >200,000 in 3 weeks, ~62% of the global population; FZS: 60% global / ~88% of the national population; CMS CAMI note: 150,000 / 80% of Betpak-Dala. Card follows the peer-reviewed paper (62%). Note "the world's" in the sentence means the global saiga population at the time.
6. **Population figure choice.** Stats use the 2024 aerial census (2,833,600, ACBK/Altyn Dala page). Press-reported later counts: ~4.1M (Apr 2025), "over 4 million" (Dec 2025), ~4.6M (June 2026, Astana Times). I did not cite the 2026 figure because only news carried it; the "millions" in the hook and "keep counting" in the witness line are deliberately loose. Update if you want the freshest number.
7. **"About 99 percent of the species"** in populationEstimate comes from FZS ("approximately 99% of the global saiga population"); with Mongolia at ~23–25k and Russia at ~38k that is roughly right for 2024 but is an FZS rounding.
8. **Bot-gated pages** (403 on fetch, not cited): Fauna & Flora species page and news, Science Advances DOI page (used the PMC copy instead), cms.int species page (the saiga.cms.int MOU site did load but I dropped it to stay at 12 sources), Oxford Biology news page loaded but is redundant.
9. **Migration plate.** "More than 1,000 km per year" is FZS wording; the plate shows a herd strung out on migration. Mass calving aggregations (thousands of females on open ground) are widely described but none of my fetched sources said it explicitly, so I left it out of reproduction.
10. **Size conversions.** ADW gives 0.6–0.8 m shoulder, 30–45 kg; WCS Mongolia gives 63–80 cm, 23–40 kg. Card uses ADW converted to 2–2.6 ft / 66–99 lbs.
11. **Habitat circles** are the three Kazakh population ranges (Betpak-Dala, Ural, Ustyurt) at 200–300 km; no calving grounds. Ustyurt circle straddles the Uzbekistan border by design.
12. **Program 1 organization string** lists all five Altyn Dala partners; trim to "Altyn Dala Conservation Initiative" if the card UI truncates.
