# Card worksheet — Scimitar-horned Oryx (Oryx dammah)

Scaffolded 2026-09-02 by tools/new-card.py. Pipeline: docs/CARD_PRODUCTION_PIPELINE.md; trust bar: docs/CONTENT_TRUST_AND_RIGHTS.md. Delete this file once the card is approved and merged.

## Source-verification checklist

- [ ] Scientific + common name and status wording verified against a primary source (no IUCN API per D-005)
- [ ] Every story sentence maps to a declared source; story 120-220 words
- [ ] Stats (size, lifespan, diet, trend, 4+ threats) each curl-verified; volatile population figures omitted or dated
- [ ] Range generalized: named regions only, radius >= 25 km, no sensitive localities
- [ ] Action: official destination, working HTTPS link, passes the action policy
- [ ] 1+ conservation programs live-verified (`kind: program`; sponsors must be labeled)
- [ ] Insight is genuinely surprising and sourced
- [ ] All URLs pass `python3 tools/check_links.py --all --only scimitar-horned-oryx`
- [ ] Five plates generated (model nano_banana_pro, tecnologiasstellar account), job IDs in the rights record
- [ ] Species-accuracy review of every plate against source reference photos
- [ ] Editorial review done; `editorial.state` flipped in the PR (approval = PR review)
- [ ] `swift test --package-path Packages/WitnessCore` green

## Image prompts (locked template, D-013)

### scimitar-horned-oryx-plate-01 — hero, aspect 2:3

```
Fine natural-history plate illustration of Scimitar-horned Oryx (Oryx dammah), long ridged sharp-tipped horns sweeping back in a scimitar curve on both sexes, white body with rust-brown neck and chest, a dark mask stripe through the eye, a long dark-tufted tail, broad flat hooves. Painterly gouache and ink on warm paper texture, muted palette of ink, rust ochre and pale sand and lichen green, soft directional light, full body in gentle profile, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### scimitar-horned-oryx-context-01 — habitat, aspect 3:2

```
Fine natural-history plate illustration of Scimitar-horned Oryx (Oryx dammah), long ridged sharp-tipped horns sweeping back in a scimitar curve on both sexes, white body with rust-brown neck and chest, a dark mask stripe through the eye, a long dark-tufted tail, broad flat hooves. Painterly gouache and ink on warm paper texture, muted palette of ink, rust ochre and pale sand and lichen green, soft directional light, the animal small within its characteristic habitat, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### scimitar-horned-oryx-detail-01 — head study, aspect 1:1

```
Fine natural-history plate illustration of Scimitar-horned Oryx (Oryx dammah), long ridged sharp-tipped horns sweeping back in a scimitar curve on both sexes, white body with rust-brown neck and chest, a dark mask stripe through the eye, a long dark-tufted tail, broad flat hooves. Painterly gouache and ink on warm paper texture, muted palette of ink, rust ochre and pale sand and lichen green, soft directional light, close head study showing the diagnostic facial features, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### scimitar-horned-oryx-behavior-01 — behavior, aspect 3:2

```
Fine natural-history plate illustration of Scimitar-horned Oryx (Oryx dammah), long ridged sharp-tipped horns sweeping back in a scimitar curve on both sexes, white body with rust-brown neck and chest, a dark mask stripe through the eye, a long dark-tufted tail, broad flat hooves. Painterly gouache and ink on warm paper texture, muted palette of ink, rust ochre and pale sand and lichen green, soft directional light, a small herd grazing the Sahelian grassland at dusk, heads down, one animal lifted and watching, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### scimitar-horned-oryx-scale-01 — human scale, aspect 1:1

```
Fine natural-history plate illustration of Scimitar-horned Oryx (Oryx dammah), long ridged sharp-tipped horns sweeping back in a scimitar curve on both sexes, white body with rust-brown neck and chest, a dark mask stripe through the eye, a long dark-tufted tail, broad flat hooves. Painterly gouache and ink on warm paper texture, muted palette of ink, rust ochre and pale sand and lichen green, soft directional light, the animal beside a quiet human silhouette for scale, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

## Open questions for AV

1. First release size: Sahara Conservation says 25 oryx were transported from Abu Dhabi in 2016 (25 released in August); Smithsonian's CEC page says the first release was 23. The story avoids the number; pick one before approval.
2. Wild population: the 2023 figure is "over 600" (Sahara Conservation, EAD). Sahara Conservation's reserve page (undated) says "over 380 transferred... approaching 600", and RZSS says "around 400". Card uses 600+ dated 2023; no post-2023 official count was found.
3. Releases total: 285 (EAD/Sahara milestone, Dec 2023) vs "nearly 300" (Smithsonian) vs "over 380" (Sahara reserve page). Card uses 285, dated to the 2023 milestone.
4. IUCN Red List species page and all ZSL/Whipsnade pages returned Cloudflare 403 to fetches, so they are not cited; the 11 Dec 2023 IUCN press release (fetched) stands in for the Red List. ZSL's post-release monitoring role is therefore uncredited on the card.
5. "Fourth large mammal returned to the wild in 100 years" is the IUCN press release's wording; the story says "in a hundred years". Confirm you are comfortable with the claim's precision.
6. Trend "increasing" is inferred from the 2016-2023 growth in Sahara/EAD figures, not read from the Red List page (not fetched).
7. Horn length: Smithsonian says "several feet"; Fossil Rim says over 36 inches. Story keeps "several feet".
8. Second habitat region (central Tunisia, fenced reserves, per Marwell's 1985 Bou Hedma donation) is a judgement call; drop it if you want the map to show only the free-ranging Chad herd.
9. The 116°F body-temperature figure is from Smithsonian's species page; SDZWA attributes the same figure to beisa/fringe-eared oryx generally. Kept, on the Smithsonian citation.
10. media.source: the scaffold's "Higgsfield job TODO" fails tools/validate_card.py (TODO marker), so it now reads "Higgsfield job pending"; replace with the real job ID when plate-01 is generated. Other drafts still carry the TODO form.
