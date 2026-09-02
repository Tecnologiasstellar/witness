# Card worksheet — Lord Howe Island Stick Insect (Dryococelus australis)

Scaffolded 2026-09-02 by tools/new-card.py. Pipeline: docs/CARD_PRODUCTION_PIPELINE.md; trust bar: docs/CONTENT_TRUST_AND_RIGHTS.md. Delete this file once the card is approved and merged.

## Source-verification checklist

- [ ] Scientific + common name and status wording verified against a primary source (no IUCN API per D-005)
- [ ] Every story sentence maps to a declared source; story 120-220 words
- [ ] Stats (size, lifespan, diet, trend, 4+ threats) each curl-verified; volatile population figures omitted or dated
- [ ] Range generalized: named regions only, radius >= 25 km, no sensitive localities
- [ ] Action: official destination, working HTTPS link, passes the action policy
- [ ] 1+ conservation programs live-verified (`kind: program`; sponsors must be labeled)
- [ ] Insight is genuinely surprising and sourced
- [ ] All URLs pass `python3 tools/check_links.py --all --only lord-howe-island-stick-insect`
- [ ] Five plates generated (model nano_banana_pro, tecnologiasstellar account), job IDs in the rights record
- [ ] Species-accuracy review of every plate against source reference photos
- [ ] Editorial review done; `editorial.state` flipped in the PR (approval = PR review)
- [ ] `swift test --package-path Packages/WitnessCore` green

## Image prompts (locked template, D-013)

### lord-howe-island-stick-insect-plate-01 — hero, aspect 2:3

```
Fine natural-history plate illustration of Lord Howe Island Stick Insect (Dryococelus australis), a wingless, glossy black to reddish-brown stick insect about 12–15 cm long with a smooth cylindrical body, pale cream markings where the body segments and leg joints meet, a square head with short antennae, and thick, strongly curved, spined hind legs (heaviest on the male). Painterly gouache and ink on warm paper texture, muted palette of ink, reddish-brown and pale cream and lichen green, soft directional light, full body in gentle profile, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### lord-howe-island-stick-insect-context-01 — habitat, aspect 3:2

```
Fine natural-history plate illustration of Lord Howe Island Stick Insect (Dryococelus australis), a wingless, glossy black to reddish-brown stick insect about 12–15 cm long with a smooth cylindrical body, pale cream markings where the body segments and leg joints meet, a square head with short antennae, and thick, strongly curved, spined hind legs (heaviest on the male). Painterly gouache and ink on warm paper texture, muted palette of ink, reddish-brown and pale cream and lichen green, soft directional light, the animal small within its characteristic habitat, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### lord-howe-island-stick-insect-detail-01 — head study, aspect 1:1

```
Fine natural-history plate illustration of Lord Howe Island Stick Insect (Dryococelus australis), a wingless, glossy black to reddish-brown stick insect about 12–15 cm long with a smooth cylindrical body, pale cream markings where the body segments and leg joints meet, a square head with short antennae, and thick, strongly curved, spined hind legs (heaviest on the male). Painterly gouache and ink on warm paper texture, muted palette of ink, reddish-brown and pale cream and lichen green, soft directional light, close head study showing the diagnostic facial features, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### lord-howe-island-stick-insect-behavior-01 — behavior, aspect 3:2

```
Fine natural-history plate illustration of Lord Howe Island Stick Insect (Dryococelus australis), a wingless, glossy black to reddish-brown stick insect about 12–15 cm long with a smooth cylindrical body, pale cream markings where the body segments and leg joints meet, a square head with short antennae, and thick, strongly curved, spined hind legs (heaviest on the male). Painterly gouache and ink on warm paper texture, muted palette of ink, reddish-brown and pale cream and lichen green, soft directional light, several insects clustered together by day inside a hollow log, one adult at the entrance reaching for the leaf tips of a Melaleuca howeana shrub, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### lord-howe-island-stick-insect-scale-01 — human scale, aspect 1:1

```
Fine natural-history plate illustration of Lord Howe Island Stick Insect (Dryococelus australis), a wingless, glossy black to reddish-brown stick insect about 12–15 cm long with a smooth cylindrical body, pale cream markings where the body segments and leg joints meet, a square head with short antennae, and thick, strongly curved, spined hind legs (heaviest on the male). Painterly gouache and ink on warm paper texture, muted palette of ink, reddish-brown and pale cream and lichen green, soft directional light, the animal beside a quiet human silhouette for scale, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

## Open questions for AV

1. Population line: I used the NSW Threatened Species Scientific Committee's 2012 figure ("fewer than 50 mature individuals in the wild"). Zoos Victoria's page says "9 - 35" wild with no year; the SDZWA library factsheet says "fewer than 40" against a 2017 assessment. Pick one; the NSW figure is the only one with a date attached on the page.
2. IUCN Red List page (https://www.iucnredlist.org/species/6852/21426226) sits behind a Cloudflare JS gate, so I could not read it and did not cite it. Status wording "Critically Endangered" is taken from the 2012 NSW listing and the Zoos Victoria page instead. If you want the IUCN citation, open it manually and confirm the category before adding.
3. Federal DCCEEW conservation advice and SPRAT pages timed out / were bot-gated on every attempt, so the EPBC status wording is not on the card. Worth a manual fetch for the fact-check.
4. Size: NSW listing gives females 150 mm (commonly 120 mm); SDZWA says "to 7 inches (18 cm)"; Lord Howe Island Museum says up to 20 cm. I went with "Females to 15 cm" (the regulator's figure). Weight (about 25 g) is from SDZWA and the LHI Museum.
5. Story sentence "generations": the "19 generations, 700–800 insects, Prague Zoo" figures come from ABC News (15 Mar 2026) quoting the program; the Zoos Victoria page itself only says "two breeding pairs ... 2003". Fine for a draft, but it is the only tier-3 media source carrying a load-bearing number.
6. Threats: the 2012 NSW listing names ship-rat predation and coastal morning glory. "One tiny wild colony" and "Six shrubs of food" are drawn from the same listing's population/habitat facts rather than an explicit threat list; older NSW material also mentions insect collectors and stochastic events, but that page only serves the determination notice, so I did not cite it.
7. "Valentine's night, 2003" and "Eve laid 248 eggs" are from the Australian Museum blog (2017); Zoos Victoria's own page gives no dates or egg counts. Media.source reads "Higgsfield job pending" (the validator rejects any "TODO", and black-rhino / sunda-pangolin drafts use "pending"); all other media fields are the untouched scaffold.
