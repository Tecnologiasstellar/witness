# Card worksheet — Devils Hole Pupfish (Cyprinodon diabolis)

Scaffolded 2026-09-02 by tools/new-card.py. Pipeline: docs/CARD_PRODUCTION_PIPELINE.md; trust bar: docs/CONTENT_TRUST_AND_RIGHTS.md. Delete this file once the card is approved and merged.

## Source-verification checklist

- [ ] Scientific + common name and status wording verified against a primary source (no IUCN API per D-005)
- [ ] Every story sentence maps to a declared source; story 120-220 words
- [ ] Stats (size, lifespan, diet, trend, 4+ threats) each curl-verified; volatile population figures omitted or dated
- [ ] Range generalized: named regions only, radius >= 25 km, no sensitive localities
- [ ] Action: official destination, working HTTPS link, passes the action policy
- [ ] 1+ conservation programs live-verified (`kind: program`; sponsors must be labeled)
- [ ] Insight is genuinely surprising and sourced
- [ ] All URLs pass `python3 tools/check_links.py --all --only devils-hole-pupfish`
- [ ] Five plates generated (model nano_banana_pro, tecnologiasstellar account), job IDs in the rights record
- [ ] Species-accuracy review of every plate against source reference photos
- [ ] Editorial review done; `editorial.state` flipped in the PR (approval = PR review)
- [ ] `swift test --package-path Packages/WitnessCore` green

## Image prompts (locked template, D-013)

### devils-hole-pupfish-plate-01 — hero, aspect 2:3

```
Fine natural-history plate illustration of Devils Hole Pupfish (Cyprinodon diabolis), a tiny deep-bodied pupfish about one inch long, no pelvic fins, a large dark eye, a short blunt head with an upturned mouth, the male an iridescent shimmering blue without the dark cross-bars of other pupfish, the female plain yellow-brown to olive. Painterly gouache and ink on warm paper texture, muted palette of ink, iridescent cobalt blue and pale limestone gold and lichen green, soft directional light, full body in gentle profile, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### devils-hole-pupfish-context-01 — habitat, aspect 3:2

```
Fine natural-history plate illustration of Devils Hole Pupfish (Cyprinodon diabolis), a tiny deep-bodied pupfish about one inch long, no pelvic fins, a large dark eye, a short blunt head with an upturned mouth, the male an iridescent shimmering blue without the dark cross-bars of other pupfish, the female plain yellow-brown to olive. Painterly gouache and ink on warm paper texture, muted palette of ink, iridescent cobalt blue and pale limestone gold and lichen green, soft directional light, the animal small within its characteristic habitat, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### devils-hole-pupfish-detail-01 — head study, aspect 1:1

```
Fine natural-history plate illustration of Devils Hole Pupfish (Cyprinodon diabolis), a tiny deep-bodied pupfish about one inch long, no pelvic fins, a large dark eye, a short blunt head with an upturned mouth, the male an iridescent shimmering blue without the dark cross-bars of other pupfish, the female plain yellow-brown to olive. Painterly gouache and ink on warm paper texture, muted palette of ink, iridescent cobalt blue and pale limestone gold and lichen green, soft directional light, close head study showing the diagnostic facial features, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### devils-hole-pupfish-behavior-01 — behavior, aspect 3:2

```
Fine natural-history plate illustration of Devils Hole Pupfish (Cyprinodon diabolis), a tiny deep-bodied pupfish about one inch long, no pelvic fins, a large dark eye, a short blunt head with an upturned mouth, the male an iridescent shimmering blue without the dark cross-bars of other pupfish, the female plain yellow-brown to olive. Painterly gouache and ink on warm paper texture, muted palette of ink, iridescent cobalt blue and pale limestone gold and lichen green, soft directional light, a blue male in courtship colour holding a small patch of the sunlit, algae-covered limestone shelf just below the surface, a yellow-brown female beside him, spawning where the whole species spawns, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### devils-hole-pupfish-scale-01 — human scale, aspect 1:1

```
Fine natural-history plate illustration of Devils Hole Pupfish (Cyprinodon diabolis), a tiny deep-bodied pupfish about one inch long, no pelvic fins, a large dark eye, a short blunt head with an upturned mouth, the male an iridescent shimmering blue without the dark cross-bars of other pupfish, the female plain yellow-brown to olive. Painterly gouache and ink on warm paper texture, muted palette of ink, iridescent cobalt blue and pale limestone gold and lichen green, soft directional light, the animal beside a quiet human silhouette for scale, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

## Open questions for AV

1. Status wording: card uses the ESA listing "Endangered" (listed March 11, 1967; USFWS 5-Year Review, Aug 2024). The IUCN Red List lists Cyprinodon diabolis as Critically Endangered (2014 assessment) per search results, but the Red List page returned a Cloudflare 403 in every fetch attempt, so it is not cited. Choose ESA "Endangered" (as drafted) or IUCN "Critically Endangered" (would need the page to be reachable and cited).
2. Trend "increasing" follows the USFWS "Inside Devils Hole" story (spring 2026 count 77, population "steadily increasing" after the 2025 crash). Long-term the count is still far below the 1972-1990s baseline (~200 spring / ~425 fall). "unknown" is defensible if you prefer the long view.
3. Fall 2025 count: no official NPS/USFWS release found. The 2024 5-Year Review cites a fall 2024 index of 263 fish (unpublished data). The follow-up transfer of "about 50 more" captive fish appears only in NPR / National Parks Traveler (2026), so it is omitted; the FWS story says only "subsequent transfers over the next year".
4. Captive population: "several hundred" (FWS story, undated) vs "approximately 300" (FWS "Defying the odds", May 2022). The stats line uses "several hundred".
5. Cavern depth: NPS Devils Hole page says "over 500 feet" (bottom never mapped); the FWS story says "nearly 450 feet". Story uses the NPS figure.
6. Cappaert v. United States is cited via Cornell Law School's LII text (decided June 7, 1976); supremecourt.gov does not host 1976 opinions and the Library of Congress PDF returned 403. NPS and FWS pages also state the 1976 ruling, so the fact is triple-sourced.
7. The 5-Year Review is a 923 KB PDF hosted on the FWS ECOS S3 bucket (ecosphere-documents-production-public.s3.amazonaws.com). Confirm a PDF/S3 link is acceptable as a card source; it is the only fetched source for "no pelvic fins", "annual species", dissolved-oxygen levels, and the 2006 low of 39.
8. Lifespan is given as "about 1 year — an annual species" (NPS page; 5-Year Review citing James 1969). No fetched source gives a month figure.
9. Insight's "roughly the floor of a one-car garage" is an editorial comparison for 215 sq ft, not a sourced fact.
10. habitatRegions: region 2 ("Amargosa Desert regional aquifer") is drawn from the NPS statement that the groundwater system extends over a hundred miles to the northeast; both circles are coarse (60 km / 120 km). Devils Hole is named in the text (public, fenced, signed) but never pinpointed.
11. Hook rounds the FWS shelf dimensions (11 ft 6 in by 16 ft 5 in) to "eleven feet by sixteen". Story is exactly 220 words, the top of the validator range; trim a word if you edit.
12. USGS pages (image caption, hybrid-propagation publication) were reachable via curl but not via the fetch tool (certificate error) and add nothing the FWS/NPS sources lack, so USGS is not cited despite being on the suggested list.
