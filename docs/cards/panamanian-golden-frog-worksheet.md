# Card worksheet — Panamanian Golden Frog (Atelopus zeteki)

Scaffolded 2026-09-08 by tools/new-card.py. Pipeline: docs/CARD_PRODUCTION_PIPELINE.md; trust bar: docs/CONTENT_TRUST_AND_RIGHTS.md. Delete this file once the card is approved and merged.

## Source-verification checklist

- [ ] Scientific + common name and status wording verified against a primary source (no IUCN API per D-005)
- [ ] Every story sentence maps to a declared source; story 120-220 words
- [ ] Stats (size, lifespan, diet, trend, 4+ threats) each curl-verified; volatile population figures omitted or dated
- [ ] Range generalized: named regions only, radius >= 25 km, no sensitive localities
- [ ] Action: official destination, working HTTPS link, passes the action policy
- [ ] 1+ conservation programs live-verified (`kind: program`; sponsors must be labeled)
- [ ] Insight is genuinely surprising and sourced
- [ ] All URLs pass `python3 tools/check_links.py --all --only panamanian-golden-frog`
- [ ] Five plates generated (model nano_banana_pro, tecnologiasstellar account), job IDs in the rights record
- [ ] Species-accuracy review of every plate against source reference photos
- [ ] Editorial review done; `editorial.state` flipped in the PR (approval = PR review)
- [ ] `swift test --package-path Packages/WitnessCore` green

## Image prompts (locked template, D-013)

### panamanian-golden-frog-plate-01 — hero, aspect 2:3

```
Fine natural-history plate illustration of Panamanian Golden Frog (Atelopus zeteki), a small slim-bodied toad with long limbs and a pointed, protruding snout, smooth bright golden-yellow skin with irregular black blotches or bands on the back and legs, a uniformly yellow belly, a greenish-yellow iris with a horizontal pupil, and no visible eardrum. Painterly gouache and ink on warm paper texture, muted palette of ink, saffron gold and charcoal black and lichen green, soft directional light, full body in gentle profile, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### panamanian-golden-frog-context-01 — habitat, aspect 3:2

```
Fine natural-history plate illustration of Panamanian Golden Frog (Atelopus zeteki), a small slim-bodied toad with long limbs and a pointed, protruding snout, smooth bright golden-yellow skin with irregular black blotches or bands on the back and legs, a uniformly yellow belly, a greenish-yellow iris with a horizontal pupil, and no visible eardrum. Painterly gouache and ink on warm paper texture, muted palette of ink, saffron gold and charcoal black and lichen green, soft directional light, the animal small within its characteristic habitat, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### panamanian-golden-frog-detail-01 — head study, aspect 1:1

```
Fine natural-history plate illustration of Panamanian Golden Frog (Atelopus zeteki), a small slim-bodied toad with long limbs and a pointed, protruding snout, smooth bright golden-yellow skin with irregular black blotches or bands on the back and legs, a uniformly yellow belly, a greenish-yellow iris with a horizontal pupil, and no visible eardrum. Painterly gouache and ink on warm paper texture, muted palette of ink, saffron gold and charcoal black and lichen green, soft directional light, close head study showing the diagnostic facial features, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### panamanian-golden-frog-behavior-01 — behavior, aspect 3:2

```
Fine natural-history plate illustration of Panamanian Golden Frog (Atelopus zeteki), a small slim-bodied toad with long limbs and a pointed, protruding snout, smooth bright golden-yellow skin with irregular black blotches or bands on the back and legs, a uniformly yellow belly, a greenish-yellow iris with a horizontal pupil, and no visible eardrum. Painterly gouache and ink on warm paper texture, muted palette of ink, saffron gold and charcoal black and lichen green, soft directional light, a male perched on a moss-covered stream rock lifting and slowly rotating one forelimb in its semaphore wave, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### panamanian-golden-frog-scale-01 — human scale, aspect 1:1

```
Fine natural-history plate illustration of Panamanian Golden Frog (Atelopus zeteki), a small slim-bodied toad with long limbs and a pointed, protruding snout, smooth bright golden-yellow skin with irregular black blotches or bands on the back and legs, a uniformly yellow belly, a greenish-yellow iris with a horizontal pupil, and no visible eardrum. Painterly gouache and ink on warm paper texture, muted palette of ink, saffron gold and charcoal black and lichen green, soft directional light, the animal beside a quiet human silhouette for scale, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

## Open questions for AV

1. **Status wording.** IUCN category is Critically Endangered (reported on the PARC species page and MiAmbiente; the IUCN Red List page itself was bot-gated, 403). MiAmbiente, SDZWA and Stone Zoo call it "extinct in the wild"; the 2025–26 release trial muddies that further. I kept "Critically Endangered" and let the story carry "no one has recorded one in the wild since 2009." Want a "(possibly extinct in the wild)" note anywhere?
2. **Last wild sighting: 2009 vs 2007.** Smithsonian/PARC/Maryland Zoo say 2009; UNESCO and La Estrella say 2007 (a BBC film crew), and the IUCN assessment (per search snippets only) says 2007. Card uses 2009 from the program running the release. Confirm.
3. **Bd reaching El Valle: 2004 vs 2006.** NZCBI news + PARC release post say 2004; PARC history and PARC species page say 2006. Story says "mid-2000s" to avoid picking. OK, or choose?
4. **Clutch size drift.** NZCBI says 30–80 eggs; SDZWA 200–620; STRI portal 200–600; Stone Zoo ~370. Reproduction sentence avoids a number ("one long strand of eggs"). Fine?
5. **Lifespan drift.** NZCBI 10–15 yr; Maryland Zoo ~8 yr; SDZWA median 4–7 yr in human care. Stats say "About 8–15 years in human care; unknown in the wild." Could tighten to one source.
6. **Population figure.** "More than 1,000 adults at more than 50 institutions" is from the PARC species page (undated; possibly years old — PARC history says 1,500 by 2008). populationAsOf reads "2026 · per PARC" because that is when the page was read, not when the count was made. Prefer null?
7. **Release trial timing.** Pens went up in late 2025 (Smithsonian Magazine says August 2025); the announcement was Feb 25–26, 2026. Story and hook say "in 2025." Also: no source states how many of the ~30 survivors were still alive after full release — the story deliberately stops at "were released."
8. **Semaphoring claims.** The primary paper (Lindquist & Hetherington 1998, Animal Cognition) was unreachable (Springer redirect loop; ResearchGate 403). Waving sentence is sourced to PLOS ONE 2023, SDZWA and the STRI portal, all of which describe males waving; the 1998 finding that females also semaphore is NOT on the card.
9. **Zetekitoxin.** PNAS 2004 (Yotsu-Yamashita et al.) and PubMed were bot-gated. "Most potent in its family (Bufonidae)" comes from SDZWA; STRI portal says "most toxic of all Atelopus." Insight's "harmless in zoos because of diet" is NZCBI's wording.
10. **Law 37 of 2010.** Sourced to MiAmbiente (gov). NZCBI calls Golden Frog Day "an official holiday"; the law makes it a national day, not a public holiday — card says "by law."
11. **Bot-gated pages, not cited:** AmphibiaWeb (captcha), si.edu newsdesk release, STRI stories, Smithsonian Magazine STRI blog, IUCN Red List, PNAS, PubMed, Springer. Readable but not cited: UNESCO feature (2018), Smithsonian Magazine 2021 feature (founder pairs, "The Old Man"), Zoo New England pages, La Prensa/La Estrella.
12. **Habitat pin.** One circle, 60 km, centered between El Valle de Antón and Altos de Campana — both localities are named on every program page, so nothing sensitive is revealed; the actual release stream is not located.
