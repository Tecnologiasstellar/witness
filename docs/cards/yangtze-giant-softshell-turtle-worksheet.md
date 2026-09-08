# Card worksheet — Yangtze Giant Softshell Turtle (Rafetus swinhoei)

Scaffolded 2026-09-08 by tools/new-card.py. Pipeline: docs/CARD_PRODUCTION_PIPELINE.md; trust bar: docs/CONTENT_TRUST_AND_RIGHTS.md. Delete this file once the card is approved and merged.

## Source-verification checklist

- [ ] Scientific + common name and status wording verified against a primary source (no IUCN API per D-005)
- [ ] Every story sentence maps to a declared source; story 120-220 words
- [ ] Stats (size, lifespan, diet, trend, 4+ threats) each curl-verified; volatile population figures omitted or dated
- [ ] Range generalized: named regions only, radius >= 25 km, no sensitive localities
- [ ] Action: official destination, working HTTPS link, passes the action policy
- [ ] 1+ conservation programs live-verified (`kind: program`; sponsors must be labeled)
- [ ] Insight is genuinely surprising and sourced
- [ ] All URLs pass `python3 tools/check_links.py --all --only yangtze-giant-softshell-turtle`
- [ ] Five plates generated (model nano_banana_pro, tecnologiasstellar account), job IDs in the rights record
- [ ] Species-accuracy review of every plate against source reference photos
- [ ] Editorial review done; `editorial.state` flipped in the PR (approval = PR review)
- [ ] `swift test --package-path Packages/WitnessCore` green

## Image prompts (locked template, D-013)

### yangtze-giant-softshell-turtle-plate-01 — hero, aspect 2:3

```
Fine natural-history plate illustration of Yangtze Giant Softshell Turtle (Rafetus swinhoei), a very large softshell turtle with an oblong flat leathery carapace (a bony plate ringed with soft cartilage under skin, no scutes), olive-green shell scattered with numerous yellow spots and small yellow dots, a short bony snout on a broad head, head, neck and chin black-to-olive with numerous large yellow spots, pale yellow underside. Painterly gouache and ink on warm paper texture, muted palette of ink, olive green and warm yellow ochre and lichen green, soft directional light, full body in gentle profile, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### yangtze-giant-softshell-turtle-context-01 — habitat, aspect 3:2

```
Fine natural-history plate illustration of Yangtze Giant Softshell Turtle (Rafetus swinhoei), a very large softshell turtle with an oblong flat leathery carapace (a bony plate ringed with soft cartilage under skin, no scutes), olive-green shell scattered with numerous yellow spots and small yellow dots, a short bony snout on a broad head, head, neck and chin black-to-olive with numerous large yellow spots, pale yellow underside. Painterly gouache and ink on warm paper texture, muted palette of ink, olive green and warm yellow ochre and lichen green, soft directional light, the animal small within its characteristic habitat, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### yangtze-giant-softshell-turtle-detail-01 — head study, aspect 1:1

```
Fine natural-history plate illustration of Yangtze Giant Softshell Turtle (Rafetus swinhoei), a very large softshell turtle with an oblong flat leathery carapace (a bony plate ringed with soft cartilage under skin, no scutes), olive-green shell scattered with numerous yellow spots and small yellow dots, a short bony snout on a broad head, head, neck and chin black-to-olive with numerous large yellow spots, pale yellow underside. Painterly gouache and ink on warm paper texture, muted palette of ink, olive green and warm yellow ochre and lichen green, soft directional light, close head study showing the diagnostic facial features, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### yangtze-giant-softshell-turtle-behavior-01 — behavior, aspect 3:2

```
Fine natural-history plate illustration of Yangtze Giant Softshell Turtle (Rafetus swinhoei), a very large softshell turtle with an oblong flat leathery carapace (a bony plate ringed with soft cartilage under skin, no scutes), olive-green shell scattered with numerous yellow spots and small yellow dots, a short bony snout on a broad head, head, neck and chin black-to-olive with numerous large yellow spots, pale yellow underside. Painterly gouache and ink on warm paper texture, muted palette of ink, olive green and warm yellow ochre and lichen green, soft directional light, the animal surfacing rarely from the depths of a large turbid lake, only the head breaking the still water, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

### yangtze-giant-softshell-turtle-scale-01 — human scale, aspect 1:1

```
Fine natural-history plate illustration of Yangtze Giant Softshell Turtle (Rafetus swinhoei), a very large softshell turtle with an oblong flat leathery carapace (a bony plate ringed with soft cartilage under skin, no scutes), olive-green shell scattered with numerous yellow spots and small yellow dots, a short bony snout on a broad head, head, neck and chin black-to-olive with numerous large yellow spots, pale yellow underside. Painterly gouache and ink on warm paper texture, muted palette of ink, olive green and warm yellow ochre and lichen green, soft directional light, the animal beside a quiet human silhouette for scale, generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph.
```

## Open questions for AV

1. **Count and date.** WCS (15 Jan 2025) says "As of 2024" two are known: the Suzhou male and the Xuan Khanh animal. Story and `populationAsOf` now say 2024, not 2025. ATP's own project page is stale (still says three known, pre-2023); IGB's fact card is also stale (still lists the Dong Mo female). Both are cited only for facts they support.
2. **Sex of the 2023 Dong Mo death.** The Government Portal article gives 23 April 2023, 93 kg, nearly 156 cm, but does not state the sex; it says it "could be" the turtle found in late 2020. WCS 2025 no longer counts a Dong Mo animal. Story says "likely the 2020 female" — soften further or accept.
3. **Length drift.** The 2020 capture recorded 86 kg and "1 m in length"; the 2023 carcass was "nearly 156 cm". Probably carapace vs total length, but no source says so. Stats `size` uses "About 4 ft" from Cu Rua's ~130 cm; consider "4–5 ft".
4. **Suzhou date.** ATP 2019 post: procedure 12 April, died after 24 hours; ATP/WCS 2020 release: "died on April 13, 2019". Card uses 13 April.
5. **Second Dong Mo animal.** ATP photographed two turtles surfacing together in Dong Mo on 20 Aug 2020 (est. 40–50 kg second animal) and WCS 2025 captions a May 2022 Dong Mo photo. Neither is counted by WCS as a known individual; the card ignores it. Mention or leave out?
6. **"Never been caught" insight.** Supported by ATP Dec 2020 ("only been based on Environmental DNA"), a Nov 2022 capture-planning workshop, and WCS 2025 "sex unknown" as of 2024. Anything after 2024 is unverified; re-check ATP news before publish.
7. **Snout.** Sources say "short bony snout" (Naturalis) — not the long pig-like proboscis of other softshells. The prompts follow the source; if plates come out with a long snout, reject them.
8. **Bot-gated pages.** All five asianturtleprogram.org pages returned HTTP 425 to WebFetch; read via curl instead (full text confirmed). All other sources fetched normally.
9. **Naturalis size.** Naturalis gives 60–80 cm carapace from old museum specimens; live animals (130 cm, 156 cm) are far larger. Stats use the live-animal figures from ATP/VGP.
10. **Threat wording.** "Dams on rivers and wetlands" and "Wetlands lost to farming" are both from ATP 2016 ("streams and wetlands dammed or converted to agriculture such as rice cultivation"); TSA supplies hunting/eggs and fishing-gear bycatch.
11. **Status.** "Critically Endangered" taken from ATP project page (IUCN 2019) and TSA; IUCN site not consulted (D-005).
