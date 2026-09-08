# Card worksheet — Spixs Macaw (Cyanopsitta spixii)

Scaffolded 2026-09-08 by tools/new-card.py. Pipeline: docs/CARD_PRODUCTION_PIPELINE.md; trust bar: docs/CONTENT_TRUST_AND_RIGHTS.md. Delete this file once the card is approved and merged.

## Source-verification checklist

- [ ] Scientific + common name and status wording verified against a primary source (no IUCN API per D-005)
- [ ] Every story sentence maps to a declared source; story 120-220 words
- [ ] Stats (size, lifespan, diet, trend, 4+ threats) each curl-verified; volatile population figures omitted or dated
- [ ] Range generalized: named regions only, radius >= 25 km, no sensitive localities
- [ ] Action: official destination, working HTTPS link, passes the action policy
- [ ] 1+ conservation programs live-verified (`kind: program`; sponsors must be labeled)
- [ ] Insight is genuinely surprising and sourced
- [ ] All URLs pass `python3 tools/check_links.py --all --only spixs-macaw`
- [ ] Five plates generated (model nano_banana_pro, tecnologiasstellar account), job IDs in the rights record
- [ ] Species-accuracy review of every plate against source reference photos
- [ ] Editorial review done; `editorial.state` flipped in the PR (approval = PR review)
- [ ] `swift test --package-path Packages/WitnessCore` green

## Image prompts (locked template, D-013)

### spixs-macaw-plate-01 — hero, aspect 2:3

```
Fine natural-history plate illustration of Spixs Macaw (Cyanopsitta spixii), a slender macaw about 56 cm long, little more than half the size of a hyacinth macaw, plumage predominantly blue with darker blue wings and a long graduated tail, sides of the head paler grey-blue below the eye, bare grey lores and eye-ring, mustard-yellow iris, long narrow wings. Painterly gouache and ink on warm paper texture, muted palette of ink, dusty cerulean blue and mustard yellow and lichen green, soft directional light, full body in gentle profile, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### spixs-macaw-context-01 — habitat, aspect 3:2

```
Fine natural-history plate illustration of Spixs Macaw (Cyanopsitta spixii), a slender macaw about 56 cm long, little more than half the size of a hyacinth macaw, plumage predominantly blue with darker blue wings and a long graduated tail, sides of the head paler grey-blue below the eye, bare grey lores and eye-ring, mustard-yellow iris, long narrow wings. Painterly gouache and ink on warm paper texture, muted palette of ink, dusty cerulean blue and mustard yellow and lichen green, soft directional light, the animal small within its characteristic habitat, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### spixs-macaw-detail-01 — head study, aspect 1:1

```
Fine natural-history plate illustration of Spixs Macaw (Cyanopsitta spixii), a slender macaw about 56 cm long, little more than half the size of a hyacinth macaw, plumage predominantly blue with darker blue wings and a long graduated tail, sides of the head paler grey-blue below the eye, bare grey lores and eye-ring, mustard-yellow iris, long narrow wings. Painterly gouache and ink on warm paper texture, muted palette of ink, dusty cerulean blue and mustard yellow and lichen green, soft directional light, close head study showing the diagnostic facial features, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### spixs-macaw-behavior-01 — behavior, aspect 3:2

```
Fine natural-history plate illustration of Spixs Macaw (Cyanopsitta spixii), a slender macaw about 56 cm long, little more than half the size of a hyacinth macaw, plumage predominantly blue with darker blue wings and a long graduated tail, sides of the head paler grey-blue below the eye, bare grey lores and eye-ring, mustard-yellow iris, long narrow wings. Painterly gouache and ink on warm paper texture, muted palette of ink, dusty cerulean blue and mustard yellow and lichen green, soft directional light, a small flock of Spix's macaws trailing a band of blue-winged macaws through caraibeira trees along a dry seasonal creek, one bird taking fruit it has just learned to eat, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### spixs-macaw-scale-01 — human scale, aspect 1:1

```
Fine natural-history plate illustration of Spixs Macaw (Cyanopsitta spixii), a slender macaw about 56 cm long, little more than half the size of a hyacinth macaw, plumage predominantly blue with darker blue wings and a long graduated tail, sides of the head paler grey-blue below the eye, bare grey lores and eye-ring, mustard-yellow iris, long narrow wings. Painterly gouache and ink on warm paper texture, muted palette of ink, dusty cerulean blue and mustard yellow and lichen green, soft directional light, the animal beside a quiet human silhouette for scale, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

## Open questions for AV

1. **Status: two categories are both current.** Global IUCN Red List = Extinct in the Wild (2019). Brazil's own SALVE assessment (category dated 18/10/2024, published 2025) = Criticamente em Perigo (CR), "Possivelmente Extinta", criterion D, because 20 birds were released in 2022 but there is no viable wild offspring. The card uses the global category (Extinct in the Wild) since it is the one the Red List still shows and the one press and BirdLife use; the SALVE sheet itself lists the 2019 global EW in its assessment table. Flip to Critically Endangered if you prefer the national listing.
2. **Reassessment risk.** With all 11 free-living birds recaptured in November 2025 and none released since, the global EW category now describes reality again, but I found no 2025–2026 IUCN reassessment. The iucnredlist.org species page returned 403 (bot-gated) so I could not read it directly.
3. **BirdLife factsheet is JS-rendered.** The action destination and one source (datazone.birdlife.org) loads its data client-side; WebFetch and curl both returned only "Loading…" placeholders. The link is alive (200) and I kept it as the action page, but no story sentence now leans on it alone. Every claim it used to carry (1990 single bird, October 2000 disappearance, 2019 EW) is now sourced to the ICMBio SALVE sheet. Dropped the "female blue-winged macaw mate" detail from the story because its only readable source was a Loro Parque page I did not add.
4. **ICMBio–ACTP agreement, stated neutrally.** Mongabay (July 2024): ICMBio announced in May 2024 it would not renew the five-year technical cooperation agreement with ACTP, which ended in June 2024; ICMBio alleged a commercial transfer when ACTP sent 26 Spix's and four Lear's macaws to a private zoo in India in 2023; ACTP says no bird was sold. Vercillo et al. 2024 (BCI) records that in July 2024 the Brazilian government made captive breeding the priority "with no further releases authorised". The story says "let its agreement … lapse" and "no more were released"; it does not assign blame.
5. **Recapture wording.** Mongabay (Oct 2025) reported a judge upholding ICMBio's capture order with captures still pending; CNN Brasil (26 Nov 2025) reports the 11 free birds were recaptured in early November on circovirus suspicion and all 11 tested positive; AFP (phys.org, 27 Nov 2025) confirms all survivors positive plus 21 of about 90 captive birds. The story sentence therefore leans on CNN Brasil for "recaptured". Secondary reports give 15 November as the capture date; I could not read them (403), so no date beyond "November" is in the card.
6. **2026 developments I could NOT source.** Search snippets say ICMBio reported negative retests by 31 March 2026 and in May 2026 moved 69 Spix's macaws (plus two red-and-green macaws) from the Curaçá facility to Cemafauna/Univasf in Petrolina, with 34 positives kept alive rather than euthanised. The four ICMBio gov.br news pages that would confirm this returned "Conteúdo Restrito" to both WebFetch and curl, and the secondary Brazilian pages were 403 or DNS-dead. None of this is in the card. If you can open the gov.br pages in a browser, they would be the right sources for a 2026 update sentence.
7. **Captive total is a 2024 composite.** "About 350 in captivity" = ACTP ~267 + São Paulo Zoo 27 + others, per Mongabay July 2024. By late 2025 the split had changed (41 birds moved from Germany to Brazil in January 2025; ~103 at the Curaçá facility per CNN Brasil; ACTP still said to hold most of the registered population). No single 2025/2026 total was readable. Stats say "about 350" dated 2025 with the composite named; tighten or drop if you want one dated primary figure.
8. **Lifespan figure.** SALVE gives 20–30 years free-living and one captive bird of about 40 that died in 2014; the "about 40 in captivity" stat rests on that single record.
9. **Diet plant names** (pinhão, faveleira, baraúna, marizeiro) are the historic wild diet from Barros et al. 2012 as quoted in SALVE; the released birds ate a broader set of Caatinga fruits learned from blue-winged macaws. Kept the historic list in the stat.
10. **Two sources are PDFs**, both on ICMBio domains (SALVE sheet; Lugarini et al. 2021 in Biodiversidade Brasileira). check_links passes them; the text was read via pypdf extraction.
11. **Circovirus in the threats list** is a 2025 event, not a historic threat; SALVE's own threat table does not list disease. Kept because it is the reason no bird flies free today.
