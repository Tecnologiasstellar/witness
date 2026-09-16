# Map safety review, September 2026

Reviewer: Alberto Villalpando  
Date: 2026-09-__ (fill in on signature)  
Scope: every record in `witness_web/site/data/species.json` (30 cards, 51 regions) as drawn on witnessatlas.com/map and /es/map (D-030). New cards add a row here before approval (`docs/CARD_PRODUCTION_PIPELINE.md`).

This file is the evidence behind the "Sensitive species safety" row in `docs/COMPETITION_AND_RELEASE_GATES.md`. The row flips from PENDING to PASS only when the signature line at the bottom is filled, and `vercel deploy --prod` for the map waits on it.

## Rules the map is held to

1. Every region is a named public place (a park, bay, range, coast or island group); the name may already be public prose in `generalizedRange`.
2. `radiusKm` is at least 25 (`RangeRegion.minimumRadiusKm`; `CatalogValidator` rejects anything smaller).
3. The centre is a public centroid (the middle of a park, bay or coast), never an occurrence, nest, den, release pen, grove or pool.
4. The map draws area only: no centre mark, no pin, no cluster count for a species.
5. The rendered radius is never smaller than the true radius and never below the visual floor (8 viewBox units, about 297 km at the equator); the floor overstates, never understates, a range, and the tooltip carries the real km.
6. No coordinate appears in page text, tooltips, aria labels, JSON-LD or a URL. The list gives region names and radii only. (The fallback's ellipse attributes carry one-decimal projected units, and the live map receives the same two-decimal centroids `species.json` has published since 2026-09-04.)
7. No zoom finer than the record's own generalisation: the live map is capped at zoom 7 (about 611 m per pixel at the equator; a 25 km range is ~80 px across) and deep-links by `#r-<id>` only, never by a viewport coordinate.
8. The basemap draws only land, water, country borders and place names from OpenFreeMap tiles: no roads, buildings or rivers at any zoom. Without JavaScript the map is the Natural Earth 110m outline, where nothing finer than roughly 50 km resolves.

## What the founder accepts by signing

- At the world view most regions render at the visual floor (6 px on the live map; 40 of 51 at 8 units on the fallback), so they read as same-size markers at their centroids until the reader zooms in. Rule 4 forbids a centre mark; this is the map's honest limit, not a marker, and the list beside it names every region with its radius.
- Where regions overlap (the Caribbean, the Gulf of Mexico, the two Amur species at one coordinate) the hover tooltip shows only the topmost circle; records are drawn largest first so no species is buried, and the list is complete.
- The spoon-billed sandpiper's Chukotka region crosses the antimeridian and is drawn once at each edge of the frame.
- The three rows marked FOUNDER below are decided here, not in code. A changed radius is a catalog edit: `python3 tools/export_catalog.py > witness_web/site/data/species.json && cp witness_web/site/data/species.json witness_web/community/data/`, the same region object mirrored into `species.es.json` (and its community copy), `python3 tools/check_species_es.py`, `swift test --filter CatalogValidatorTests`.

## Records

| id | status | regions (name · radius) | flag | decision | note |
|---|---|---|---|---|---|
| vaquita | Endangered | Northern Gulf of California · 90 km | — | keep | Single region at 90 km; a public park or coast. |
| amur-leopard | Critically Endangered | Russian Far East borderlands · 130 km | — | keep | Single region at 130 km; a public park or coast. |
| kakapo | Nationally Critical | Southern predator-free islands · 80 km | single region | keep | Islands closed to the public and published by DOC. |
| axolotl | Critically Endangered | Xochimilco canals, southern Mexico City · 25 km | minimum radius, single site | keep | The circle covers all of southern Mexico City; the place name is the card's own prose. |
| monarch-butterfly | In Decline | Overwintering forests, central Mexico · 60 km; Western overwintering coast, California · 150 km | — | keep | Multi-region; public parks, ranges or coasts. |
| javan-rhino | Critically Endangered | Ujung Kulon National Park, Java · 30 km | single site, one park | keep | Ujung Kulon's boundary is public (IRF, UNESCO); the circle is the park, nothing within it. |
| mountain-gorilla | Endangered | Virunga Massif · 30 km; Bwindi Impenetrable National Park · 25 km | minimum radius (Bwindi) | keep | Tourism park with a public boundary. |
| north-atlantic-right-whale | Endangered | Gulf of Maine & Cape Cod Bay · 200 km; Southeast calving grounds · 150 km | — | keep | Multi-region; public parks, ranges or coasts. |
| snow-leopard | Vulnerable | Himalaya & Tibetan Plateau · 750 km; Altai & Tien Shan ranges · 800 km | — | keep | Multi-region; public parks, ranges or coasts. |
| california-condor | Endangered | Central California coast ranges · 90 km; Grand Canyon & Vermilion Cliffs · 120 km | — | keep | Multi-region; public parks, ranges or coasts. |
| saola | Critically Endangered | Northern Annamite Mountains · 200 km; Central Annamite Mountains · 150 km | — | keep | Multi-region; public parks, ranges or coasts. |
| sumatran-orangutan | Critically Endangered | Leuser Ecosystem · 150 km; West Toba landscape · 120 km | — | keep | Multi-region; public parks, ranges or coasts. |
| hawksbill-turtle | Endangered | Caribbean reefs · 900 km; Coral Triangle & northern Australia · 1000 km | — | keep | Multi-region; public parks, ranges or coasts. |
| whooping-crane | Endangered | Wood Buffalo National Park · 100 km; Aransas National Wildlife Refuge · 40 km | — | keep | Multi-region; public parks, ranges or coasts. |
| gharial | Critically Endangered | National Chambal Sanctuary · 120 km; Chitwan rivers, Nepal · 60 km | — | keep | Multi-region; public parks, ranges or coasts. |
| iberian-lynx | Vulnerable | Sierra Morena highlands · 45 km; Doñana · 30 km | — | keep | Multi-region; public parks, ranges or coasts. |
| rusty-patched-bumble-bee | Endangered | Upper Midwest stronghold · 400 km; Northeast remnants · 400 km | — | keep | Multi-region; public parks, ranges or coasts. |
| amur-tiger | Endangered | Sikhote-Alin mountains · 175 km; Southwest Primorye border forests · 60 km | — | keep | Multi-region; public parks, ranges or coasts. |
| golden-lion-tamarin | Endangered | São João River basin · 40 km | single region | keep | Public reserve; the AMLD publishes it. |
| yangtze-finless-porpoise | Critically Endangered | Middle Yangtze mainstem · 80 km; Poyang Lake · 50 km | — | keep | Multi-region; public parks, ranges or coasts. |
| philippine-eagle | Critically Endangered | Mindanao mountain forests · 150 km; Luzon Sierra Madre · 150 km | — | keep | Multi-region; public parks, ranges or coasts. |
| ethiopian-wolf | Endangered | Bale Mountains · 45 km; Simien Mountains · 30 km | — | keep | Multi-region; public parks, ranges or coasts. |
| spoon-billed-sandpiper | Critically Endangered | Chukotka breeding coast · 300 km; Gulf of Mottama · 100 km | — | keep | Multi-region; public parks, ranges or coasts. |
| chinese-giant-salamander | Critically Endangered | Qinling–Daba mountain streams · 300 km; South-central China uplands · 350 km | — | keep | Multi-region; public parks, ranges or coasts. |
| staghorn-coral | Threatened | Florida Keys reef tract · 140 km; Caribbean & Bahamas · 1000 km | — | keep | Multi-region; public parks, ranges or coasts. |
| ploughshare-tortoise | Critically Endangered | Baly Bay National Park · 30 km | single site; highest illegal-trade value in the catalog | FOUNDER DECIDES | Enlarge to ~100 km as 'Northwest Madagascar coast' (catalog edit, iOS picks it up next release) or keep 30 km and record why. |
| kemps-ridley-turtle | Endangered | Rancho Nuevo nesting beach · 50 km; Gulf of Mexico foraging waters · 600 km | — | keep | Multi-region; public parks, ranges or coasts. |
| red-wolf | Critically Endangered | Albemarle Peninsula · 60 km | single region | keep | USFWS publishes the recovery area. |
| hawaiian-crow | Extinct in the Wild | Kaʻū & Kona forests, Hawaiʻi Island · 60 km; East Maui release forests · 25 km | release site | FOUNDER CONFIRMS | The centre must be the public forest area, not the release pen. |
| wollemi-pine | Critically Endangered | Wollemi National Park · 60 km | the grove is officially secret | FOUNDER CONFIRMS | The centre must be the park centroid, not the canyon. |

## Drafts pre-flagged (not on the map until they enter the catalog)

| id | flag | note |
|---|---|---|
| devils-hole-pupfish | single fenced site | The centre must be the Ash Meadows refuge, not the pool (a 2016 vandalism record). |
| spixs-macaw | single region | 90 km around the release landscape; fine. |
| hainan-gibbon | single region | Bawangling, 40 km; fine. |
| lord-howe-island-stick-insect | single region | Balls Pyramid, 50 km; public. |

## On signature

Replace line 35 of `docs/COMPETITION_AND_RELEASE_GATES.md` with:

`| Sensitive species safety | PASS (2026-09-__) | All 51 habitatRegions across 30 catalog cards reviewed by Alberto Villalpando against the 25 km / public-place / public-centroid rule; docs/evidence/map-safety-review-2026-09.md |`

Signed: ______________________ (date: __________)
