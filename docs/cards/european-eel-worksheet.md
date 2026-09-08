# Card worksheet — European Eel (Anguilla anguilla)

Scaffolded 2026-09-08 by tools/new-card.py. Pipeline: docs/CARD_PRODUCTION_PIPELINE.md; trust bar: docs/CONTENT_TRUST_AND_RIGHTS.md. Delete this file once the card is approved and merged.

## Source-verification checklist

- [ ] Scientific + common name and status wording verified against a primary source (no IUCN API per D-005)
- [ ] Every story sentence maps to a declared source; story 120-220 words
- [ ] Stats (size, lifespan, diet, trend, 4+ threats) each curl-verified; volatile population figures omitted or dated
- [ ] Range generalized: named regions only, radius >= 25 km, no sensitive localities
- [ ] Action: official destination, working HTTPS link, passes the action policy
- [ ] 1+ conservation programs live-verified (`kind: program`; sponsors must be labeled)
- [ ] Insight is genuinely surprising and sourced
- [ ] All URLs pass `python3 tools/check_links.py --all --only european-eel`
- [ ] Five plates generated (model nano_banana_pro, tecnologiasstellar account), job IDs in the rights record
- [ ] Species-accuracy review of every plate against source reference photos
- [ ] Editorial review done; `editorial.state` flipped in the PR (approval = PR review)
- [ ] `swift test --package-path Packages/WitnessCore` green

## Image prompts (locked template, D-013)

### european-eel-plate-01 — hero, aspect 2:3

```
Fine natural-history plate illustration of European Eel (Anguilla anguilla), an elongated cylindrical snake-like body with small gill openings, a single pair of small rounded pectoral fins and no pelvic fins, olive-brown to dark green back over a pale silvery belly, a small head with a slightly protruding lower jaw. Painterly gouache and ink on warm paper texture, muted palette of ink, olive brown and pale silver and lichen green, soft directional light, full body in gentle profile, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### european-eel-context-01 — habitat, aspect 3:2

```
Fine natural-history plate illustration of European Eel (Anguilla anguilla), an elongated cylindrical snake-like body with small gill openings, a single pair of small rounded pectoral fins and no pelvic fins, olive-brown to dark green back over a pale silvery belly, a small head with a slightly protruding lower jaw. Painterly gouache and ink on warm paper texture, muted palette of ink, olive brown and pale silver and lichen green, soft directional light, the animal small within its characteristic habitat, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### european-eel-detail-01 — head study, aspect 1:1

```
Fine natural-history plate illustration of European Eel (Anguilla anguilla), an elongated cylindrical snake-like body with small gill openings, a single pair of small rounded pectoral fins and no pelvic fins, olive-brown to dark green back over a pale silvery belly, a small head with a slightly protruding lower jaw. Painterly gouache and ink on warm paper texture, muted palette of ink, olive brown and pale silver and lichen green, soft directional light, close head study showing the diagnostic facial features, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### european-eel-behavior-01 — behavior, aspect 3:2

```
Fine natural-history plate illustration of European Eel (Anguilla anguilla), an elongated cylindrical snake-like body with small gill openings, a single pair of small rounded pectoral fins and no pelvic fins, olive-brown to dark green back over a pale silvery belly, a small head with a slightly protruding lower jaw. Painterly gouache and ink on warm paper texture, muted palette of ink, olive brown and pale silver and lichen green, soft directional light, a silver-phase eel with enlarged eyes slipping downstream through dark water at night toward the sea, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### european-eel-scale-01 — human scale, aspect 1:1

```
Fine natural-history plate illustration of European Eel (Anguilla anguilla), an elongated cylindrical snake-like body with small gill openings, a single pair of small rounded pectoral fins and no pelvic fins, olive-brown to dark green back over a pale silvery belly, a small head with a slightly protruding lower jaw. Painterly gouache and ink on warm paper texture, muted palette of ink, olive brown and pale silver and lichen green, soft directional light, the animal beside a quiet human silhouette for scale, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

## Open questions for AV

1. **ICES advice URL.** The ICES Library (ices-library.figshare.com, DOI 10.17895/ices.advice.27203028) returned 403 to every fetch, so the card cites the FishSec-hosted PDF of the same ICES Advice 2025 document (published 4 Nov 2025). I read the PDF in full; swap the URL to the ICES DOI if you can open it in a browser.
2. **Recruitment figures.** The card says North Sea glass-eel recruitment is "near 1 percent" of the 1960–1979 mean and "around 12 percent" elsewhere. Exact ICES values: North Sea 1.3 % (2024) / 0.7 % (2025, preliminary); Elsewhere Europe 7.2 % (2024) / 12.1 % (2025, preliminary); yellow-eel index 14.3 % (2024). The 2025 values are flagged preliminary — decide whether to quote 2024 finals instead.
3. **Trend = "decreasing".** ICES says the status "remains critical" and recruitment is far below the 1960–1979 limit, but the indices have been flat-low (not still falling) since about 2011. "unknown" would also be defensible; I chose "decreasing" on the EC/EPRS wording of a 90–95 % decline since the 1980s.
4. **"Largest wildlife crime" attribution.** The sentence is attributed to the European Commission (DG Environment news page, 3 Mar 2026: "Europe's largest wildlife crime"; "100 tonnes of glass eels are trafficked annually to Asia … over €5,000 per kilogram"). Europol pages are a JavaScript app — only the headline text loads. The cited Europol headline ("256 eel smugglers … 25 tonnes … EUR 13 million destined for Asia") is used only for what the headline itself states.
5. **Hydropower 42 % (Sweden, 2014) — cut for length.** The story ran 287 words and was trimmed to 9 sections; the Sweden sentence and its SEG source were dropped. The figure came from SEG's summary of Dekker & Wickström (SLU), https://www.sustainableeelgroup.org/new-evidence-published-showing-hydropower-mortality-and-importance-of-translocation-in-sweden/ — restore if you want a hard number on turbines. It is a national estimate of the share of silver-eel mortality, not a turbine-passage mortality rate. Range-wide turbine mortality figures vary widely (roughly 10–100 % depending on turbine type per the literature I saw in search snippets but did not fetch), so I kept the sourced Swedish figure only.
6. **Bot-gated / unreadable pages.** ZSL (species and project pages), Natural History Museum (both eel articles), Wildlife Trusts, NatureScot, cites.org and legislation.gov.uk all returned 403 or empty. None are cited. The CITES Appendix II dates (listed 2007, in force 2009) come from the ICES advice and the EPRS briefing; the EU's 2010 external-trade ban comes from the EC oceans page and EPRS.
7. **Size/lifespan spread.** WWT: 60–80 cm, up to 1.5 m, 1–2 kg, ~20 years average, up to 50. Canal & River Trust: "eight to possibly 100 years (if landlocked)", British record 11 lb 3 oz. Rewilding Britain (fetched, not cited) says ~80 years in captivity. I used WWT's figures and added CRT's landlocked caveat; trim if it reads hedgy.
8. **Years in fresh water.** Sources disagree: GOV.UK and Forth Rivers Trust say 5–20 years; EPRS says "four to more than 20"; the EA East Anglia blog (fetched, not cited) says 6–10. Card uses "five to twenty".
9. **Larval journey distance.** WWT says 4,000 miles (larvae); Thames Rivers Trust says over 6,500 km; EPRS gives 5,000–10,000 km for the adult return; GOV.UK says "over 3,500 miles" for silver eels. Card uses WWT's 4,000 miles for the larval drift.
10. **Sargasso Sea as a habitat pin.** Deliberately left off habitatRegions (the brief bars spawning sites even though this one is an ocean region hundreds of km across). Add it as a third pin (~26 N, 60 W, radius 300 km) if you want the map to show the ocean half of the story.
11. **Action destination.** WWT factfile (charity, UK-focused). ZSL's eel pages would be the more program-relevant destination but were bot-gated; swap if you can open them.
12. **Population estimate.** Left null: no organisation publishes an absolute count for this panmictic stock; ICES assesses recruitment indices only.

