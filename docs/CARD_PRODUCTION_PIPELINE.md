# Animal-card production pipeline

Last updated: 2026-08-25 (card v2 tooling). Governs every card entering the production catalog (D-019). The trust bar is `CONTENT_TRUST_AND_RIGHTS.md`; this file is the assembly line that meets it.

## Stages

Every card moves through these stages in order. State is recorded in the record's `editorialState` field; production validation (`CatalogValidator`) rejects anything below `approved`.

### 1. Select

Pick the next species from `SPECIES_BACKLOG.md`. Prefer story strength, a genuinely doable action, reliable primary sources, and taxonomic/geographic variety across the recent run of cards.

### 2. Research and source

- Verify scientific and common names, status wording, and status date against primary sources (source hierarchy in the trust policy; no IUCN API data per D-005).
- Every factual sentence in the story must map to a listed source URL.
- Generalize range; never sensitive coordinates.
- Choose one action that passes the action policy, with a working official destination link.

### 3. Draft the record

Scaffold with `python3 tools/new-card.py "Common Name" "Scientific name"` — it writes the v2-shaped record to `Resources/catalog/<id>.json` (one file per species; the loader merges them), a worksheet with the source checklist and five pre-filled image prompts under `docs/cards/`, and a rights stub under `docs/media/`. Resolve every TODO: sources, action, stats (4+ threats), generalized range regions, insight, reproduction, programs, story. The skeleton fails the validator by design until complete. Check URLs as you go: `python3 tools/check_links.py --all --only <id>`.

### 4. Artwork (Higgsfield) — five plates per card

Five plates per v2 card: hero 2:3, habitat 3:2, head study 1:1, behavior 3:2, human scale 1:1. The worksheet from stage 3 carries all five prompts pre-filled from the locked template.

- Generate with the locked Witness style-prompt template (kept in this repo once approved; one template, varied only by species description).
- Record in the rights file per asset: `rightsState: ai_generated_owned`, generation prompt, model/settings, date, generating account (tecnologiasstellar Higgsfield account).
- Output must read as original illustration — never a fake photograph, never imitating a nameable living artist.

### 5. Species-accuracy review

Compare the artwork against reference photos from the sources: body shape, proportions, coloration, distinctive features, habitat context. Wrong anatomy = regenerate. Record pass/fail and date.

### 6. Editorial review

Copy edit and tone review per the editorial voice rules. Reviewer name and date recorded; state moves to `approved`.

### 7. Validate

`CatalogValidator` runs in CI on every PR: schema validity, required fields, source mapping, working-link shape, rights record completeness, editorial state. CI also runs `tools/check_links.py`: an `approved` record with a dead URL fails the build. The website copy is synced with `python3 tools/export_catalog.py > witness_web/site/data/species.json`.

### 8. Merge and ship

Card merges to `main` behind a green CI run and ships bundled in the next app release (catalog is bundled in v1 per D-015). The last-verified date is recorded.

## Cadence and capacity

Honest throughput is 3–5 cards per focused day. Launch scope is 30 approved cards (D-014); post-launch target is 3+ new cards per week until the 100-species backlog is carded.

## Post-launch evolution

When release-coupled publishing becomes the bottleneck, move catalog delivery to Supabase storage/CDN with signed catalog versions — same pipeline, different final stage. Do not build this before the pain exists.
