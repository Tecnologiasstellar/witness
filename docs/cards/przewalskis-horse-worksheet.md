# Card worksheet — Przewalskis Horse (Equus ferus przewalskii)

Scaffolded 2026-09-08 by tools/new-card.py. Pipeline: docs/CARD_PRODUCTION_PIPELINE.md; trust bar: docs/CONTENT_TRUST_AND_RIGHTS.md. Delete this file once the card is approved and merged.

## Source-verification checklist

- [ ] Scientific + common name and status wording verified against a primary source (no IUCN API per D-005)
- [ ] Every story sentence maps to a declared source; story 120-220 words
- [ ] Stats (size, lifespan, diet, trend, 4+ threats) each curl-verified; volatile population figures omitted or dated
- [ ] Range generalized: named regions only, radius >= 25 km, no sensitive localities
- [ ] Action: official destination, working HTTPS link, passes the action policy
- [ ] 1+ conservation programs live-verified (`kind: program`; sponsors must be labeled)
- [ ] Insight is genuinely surprising and sourced
- [ ] All URLs pass `python3 tools/check_links.py --all --only przewalskis-horse`
- [ ] Five plates generated (model nano_banana_pro, tecnologiasstellar account), job IDs in the rights record
- [ ] Species-accuracy review of every plate against source reference photos
- [ ] Editorial review done; `editorial.state` flipped in the PR (approval = PR review)
- [ ] `swift test --package-path Packages/WitnessCore` green

## Image prompts (locked template, D-013)

### przewalskis-horse-plate-01 — hero, aspect 2:3

```
Fine natural-history plate illustration of Przewalskis Horse (Equus ferus przewalskii), stocky dun-colored body with a pale yellowish-white belly, short erect dark mane with no forelock, dark dorsal stripe running from mane to a dark plumed tail, dark lower legs with faint zebra-like stripes behind the knees, large head on a thick short neck with a pale “flour” muzzle. Painterly gouache and ink on warm paper texture, muted palette of ink, sandy dun and warm chestnut-brown and lichen green, soft directional light, full body in gentle profile, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### przewalskis-horse-context-01 — habitat, aspect 3:2

```
Fine natural-history plate illustration of Przewalskis Horse (Equus ferus przewalskii), stocky dun-colored body with a pale yellowish-white belly, short erect dark mane with no forelock, dark dorsal stripe running from mane to a dark plumed tail, dark lower legs with faint zebra-like stripes behind the knees, large head on a thick short neck with a pale “flour” muzzle. Painterly gouache and ink on warm paper texture, muted palette of ink, sandy dun and warm chestnut-brown and lichen green, soft directional light, the animal small within its characteristic habitat, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### przewalskis-horse-detail-01 — head study, aspect 1:1

```
Fine natural-history plate illustration of Przewalskis Horse (Equus ferus przewalskii), stocky dun-colored body with a pale yellowish-white belly, short erect dark mane with no forelock, dark dorsal stripe running from mane to a dark plumed tail, dark lower legs with faint zebra-like stripes behind the knees, large head on a thick short neck with a pale “flour” muzzle. Painterly gouache and ink on warm paper texture, muted palette of ink, sandy dun and warm chestnut-brown and lichen green, soft directional light, close head study showing the diagnostic facial features, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### przewalskis-horse-behavior-01 — behavior, aspect 3:2

```
Fine natural-history plate illustration of Przewalskis Horse (Equus ferus przewalskii), stocky dun-colored body with a pale yellowish-white belly, short erect dark mane with no forelock, dark dorsal stripe running from mane to a dark plumed tail, dark lower legs with faint zebra-like stripes behind the knees, large head on a thick short neck with a pale “flour” muzzle. Painterly gouache and ink on warm paper texture, muted palette of ink, sandy dun and warm chestnut-brown and lichen green, soft directional light, a stallion’s harem of several mares and foals grazing together on open steppe, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### przewalskis-horse-scale-01 — human scale, aspect 1:1

```
Fine natural-history plate illustration of Przewalskis Horse (Equus ferus przewalskii), stocky dun-colored body with a pale yellowish-white belly, short erect dark mane with no forelock, dark dorsal stripe running from mane to a dark plumed tail, dark lower legs with faint zebra-like stripes behind the knees, large head on a thick short neck with a pale “flour” muzzle. Painterly gouache and ink on warm paper texture, muted palette of ink, sandy dun and warm chestnut-brown and lichen green, soft directional light, the animal beside a quiet human silhouette for scale, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

## Open questions for AV

1. **Founder count drifts by source.** SDZWA and Revive & Restore say 12 wild-born founders; Smithsonian's National Zoo says 14 (caught 1910–1960); the International Takhi Group says 13 fertile animals remained in the early 1940s. Card says "about a dozen" — confirm that hedge is acceptable or pick one source's number.
2. **Last wild sighting: 1969 vs 1968 vs "1960s".** Zoo Berlin and FZS say 1969 (Zoo Berlin: Gobi B); ITG's takhi page says 1968 in the Great Gobi SPA; Smithsonian and the IUCN CEM article say "1960s". Species360's blog (read but not cited) says a harem in 1967 and a single stallion in 1969. Card uses 1969; hook too.
3. **Status.** Endangered per IUCN since 2011 (Zoo Berlin, IUCN CEM 2018, ITG, Smithsonian equids page). Smithsonian's main species page still says "Critically Endangered" (stale). IUCN Red List page itself was bot-gated (403 via WebFetch and curl) so it is not cited.
4. **Population figure is undated.** "About 2,500 (zoos and wild)" comes from the ITG takhi page, which carries no date; populationAsOf is set to "2026 · per International Takhi Group" meaning the page as read in 2026. Alternatives: Smithsonian "approximately 1,900" (undated), Revive & Restore "over 2,000", Xinhua Aug 2025 "about 2,700 worldwide, 900+ in China" (state media, read but not cited). Say if you would rather null the figure.
5. **Hustai count.** hustai.mn says 380 takhi in 34 breeding harems with no date on the page; the 2018 IUCN CEM article says >500 free-ranging in all of Mongolia. Treat 380 as "current per park site" — confirm you are fine citing an undated homepage figure.
6. **Great Gobi B dzud losses.** ITG page: "over 400" before the 2022/23 dzud, "about 180 died". Card rounds to "400-odd". The ITG monitoring PDF was unreadable (binary) so no independent check.
7. **Kazakhstan foal date.** Prague Zoo's page reports a foal born 22 August 2026 to Tessa and Zorro; Fauna & Flora's "first wild-born in 200 years" article was bot-gated (403). FZS gives the first release as June 2025 (six horses: Zorro, Umbra, Wespe, Tessa, Sary, Ypsilonka). Card says "first steppe-born foal came in August 2026" — two weeks old as of drafting; verify it still stands at fact-check.
8. **"Absent some 200 years" in Kazakhstan** is the projects' own framing (Prague Zoo, FZS, Tierpark Berlin: "over 200 years"). No independent historical source fetched.
9. **Kalamaili sentence** relies on one peer-reviewed paper (PLOS ONE 2015, via PMC): first-winter deaths, winter corralling until 2013, ~121 horses end-2013. The Biological Conservation 2014 status paper (ScienceDirect) was 403-gated. Xinhua 2025 says Xinjiang now holds 546 — not cited.
10. **Chromosome/fertility insight.** Smithsonian equids page: 66 vs 64, hybrids (65) "remain fertile unlike the horse and donkey hybrids". Card says "unlike a mule" — fine, but note hybridization is also listed as a threat (Smithsonian), so the insight and a threat pull in opposite directions on purpose.
11. **Lifespan spread.** SDZWA "18 years on average" vs Smithsonian "up to 36". Card gives both. Size uses Smithsonian's range (1.3–1.5 m, 250–360 kg); SDZWA gives 1.2–1.4 m, 200–300 kg.
12. **Action/program overlap.** The action and program 1 both point at Prague Zoo's Kazakhstan page (the most alive, current official page). If you want the action elsewhere, hustai.mn (English homepage) is the fallback; Wilder Institute pages had nothing species-specific worth citing. Habitat circles are Hustai (60 km), Great Gobi B (150 km), Altyn Dala (200 km) — approximate centers, not release sites.
