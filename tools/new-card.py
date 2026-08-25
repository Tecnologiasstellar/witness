#!/usr/bin/env python3
"""Scaffold a v2 species card: catalog JSON + production worksheet + rights stub.

Usage:
    python3 tools/new-card.py "Javan Rhino" "Rhinoceros sondaicus"

Writes (refusing to overwrite):
    Packages/WitnessCore/Sources/WitnessCore/Resources/catalog/<id>.json
    docs/cards/<id>-worksheet.md      (source checklist + 5 pre-filled image prompts)
    docs/media/<id>-plates-rights.md  (rights record stub)

The JSON skeleton deliberately fails CatalogValidator until every TODO is
resolved — an unfinished card can never ship. Pipeline: docs/CARD_PRODUCTION_PIPELINE.md.
"""

import datetime
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CATALOG = ROOT / "Packages/WitnessCore/Sources/WitnessCore/Resources/catalog"

# Locked style template (docs/ART_PROMPT_TEMPLATE.md, D-013). Vary only the
# species block and the composition line per plate kind.
STYLE_PREFIX = "Fine natural-history plate illustration of {block}. Painterly gouache and ink on warm paper texture, muted palette of ink, {accents} and lichen green, soft directional light, "
STYLE_SUFFIX = " generous negative space, quiet dignified museum-specimen plate composition. No text, no border, no watermark. Original stylized illustration, not a photograph."

PLATES = [
    ("plate-01", "hero", "2:3", "full body in gentle profile,"),
    ("context-01", "habitat", "3:2", "the animal small within its characteristic habitat,"),
    ("detail-01", "head study", "1:1", "close head study showing the diagnostic facial features,"),
    ("behavior-01", "behavior", "3:2", "TODO: one sourced characteristic behavior,"),
    ("scale-01", "human scale", "1:1", "the animal beside a quiet human silhouette for scale,"),
]


def main() -> None:
    if len(sys.argv) != 3:
        sys.exit(__doc__)
    common, scientific = sys.argv[1].strip(), sys.argv[2].strip()
    species_id = re.sub(r"[^a-z0-9]+", "-", common.lower()).strip("-")
    today = datetime.date.today().isoformat()

    existing = [json.loads(p.read_text()) for p in CATALOG.glob("*.json")]
    last_publish = max(r["publishDate"] for r in existing)
    publish = (datetime.date.fromisoformat(last_publish) + datetime.timedelta(days=1)).isoformat()

    block = f"{common} ({scientific}), TODO: 3-5 anatomically accurate distinguishing features from the card's cited sources"
    accents = "TODO: one or two species-appropriate accent tones"

    record = {
        "id": species_id,
        "schemaVersion": 1,
        "commonName": common,
        "scientificName": scientific,
        "conservationStatus": {"displayName": "TODO", "normalizedValue": "todo"},
        "generalizedRange": "TODO: broad region, never precise localities",
        "hook": "TODO: one line that makes a stranger stop scrolling",
        "story": [
            {"id": f"{species_id}-{n}", "text": "TODO", "sourceIDs": ["TODO-source-id"]}
            for n in ("opening", "life", "threat", "hope", "witness")
        ],
        "action": {
            "id": f"learn-{species_id}",
            "title": "TODO",
            "summary": "TODO",
            "effort": "TODO minutes",
            "destinationURL": "TODO: https official destination",
            "destinationOrganization": "TODO",
            "geographicApplicability": "Worldwide",
            "sourceIDs": ["TODO-source-id"],
            "lastVerified": "TODO",
            "measurementType": "opened",
        },
        "media": {
            "assetID": f"{species_id}-plate-01",
            "depictionType": "AI-assisted stylized illustration",
            "creator": "Witness (generated via Higgsfield, owner account tecnologiasstellar)",
            "source": f"Higgsfield job TODO, {today}; rights record docs/media/{species_id}-plates-rights.md",
            "license": "ai_generated_owned",
            "requiredAttribution": "None",
            "commercialUseStatus": "owner-asserted, Higgsfield plan terms verification pending",
            "verificationStatus": "pending",
        },
        "publishDate": publish,
        "sources": [
            {"id": "TODO-source-id", "title": "TODO", "organization": "TODO", "url": "TODO: https", "lastAccessed": today}
        ],
        "editorial": {
            "state": "prototype",
            "reviewer": "TODO",
            "lastFactChecked": "TODO",
            "sensitiveLocationReview": "generalized",
            "notes": "Scaffolded by tools/new-card.py; every TODO must be resolved before review.",
        },
        "stats": {
            "size": "TODO",
            "lifespan": "TODO",
            "diet": "TODO",
            "populationEstimate": None,
            "populationAsOf": None,
            "trend": "unknown",
            "threats": ["TODO", "TODO", "TODO", "TODO"],
            "sourceIDs": ["TODO-source-id"],
        },
        "reproduction": {"id": f"{species_id}-reproduction", "text": "TODO", "sourceIDs": ["TODO-source-id"]},
        "insight": {"id": f"{species_id}-insight", "text": "TODO: the one fact people repeat at dinner", "sourceIDs": ["TODO-source-id"]},
        "habitatRegions": [
            {"name": "TODO", "latitude": 0.0, "longitude": 0.0, "radiusKm": 25.0}
        ],
        "gallery": [f"{species_id}-{suffix}" for suffix, *_ in PLATES],
        "programs": [
            {
                "id": f"TODO-{species_id}-program",
                "organization": "TODO",
                "title": "TODO",
                "summary": "TODO: what the program concretely does",
                "url": "TODO: https",
                "kind": "program",
                "sourceIDs": ["TODO-source-id"],
                "lastVerified": "TODO",
            }
        ],
    }

    prompts = "\n\n".join(
        f"### {species_id}-{suffix} — {kind}, aspect {aspect}\n\n```\n"
        + STYLE_PREFIX.format(block=block, accents=accents) + composition + STYLE_SUFFIX + "\n```"
        for suffix, kind, aspect, composition in PLATES
    )

    worksheet = f"""# Card worksheet — {common} ({scientific})

Scaffolded {today} by tools/new-card.py. Pipeline: docs/CARD_PRODUCTION_PIPELINE.md; trust bar: docs/CONTENT_TRUST_AND_RIGHTS.md. Delete this file once the card is approved and merged.

## Source-verification checklist

- [ ] Scientific + common name and status wording verified against a primary source (no IUCN API per D-005)
- [ ] Every story sentence maps to a declared source; story 120-220 words
- [ ] Stats (size, lifespan, diet, trend, 4+ threats) each curl-verified; volatile population figures omitted or dated
- [ ] Range generalized: named regions only, radius >= 25 km, no sensitive localities
- [ ] Action: official destination, working HTTPS link, passes the action policy
- [ ] 1+ conservation programs live-verified (`kind: program`; sponsors must be labeled)
- [ ] Insight is genuinely surprising and sourced
- [ ] All URLs pass `python3 tools/check_links.py --all --only {species_id}`
- [ ] Five plates generated (model nano_banana_pro, tecnologiasstellar account), job IDs in the rights record
- [ ] Species-accuracy review of every plate against source reference photos
- [ ] Editorial review done; `editorial.state` flipped in the PR (approval = PR review)
- [ ] `swift test --package-path Packages/WitnessCore` green

## Image prompts (locked template, D-013)

{prompts}
"""

    rights = f"""# Rights record — {species_id} plates

All: rights state `ai_generated_owned` (D-013), Higgsfield account tecnologiasstellar, model `nano_banana_pro`, locked style template (docs/ART_PROMPT_TEMPLATE.md). Species-accuracy review: TODO (date + pass per plate). Open item: Higgsfield plan commercial-terms confirmation before App Store submission.

| Asset | Kind / aspect | Job | Generated |
|---|---|---|---|
{"".join(f"| {species_id}-{suffix} | {kind} {aspect} | TODO | TODO |{chr(10)}" for suffix, kind, aspect, _ in PLATES)}"""

    outputs = {
        CATALOG / f"{species_id}.json": json.dumps(record, indent=2, ensure_ascii=False) + "\n",
        ROOT / "docs/cards" / f"{species_id}-worksheet.md": worksheet,
        ROOT / "docs/media" / f"{species_id}-plates-rights.md": rights,
    }
    clashes = [p for p in outputs if p.exists()]
    if clashes:
        sys.exit("Refusing to overwrite:\n" + "\n".join(str(p) for p in clashes))
    for path, content in outputs.items():
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(content)
        print(f"wrote {path.relative_to(ROOT)}")

    print(f"\npublishDate {publish} (next free slot). The skeleton fails the validator until every TODO is resolved — that is the point.")


if __name__ == "__main__":
    main()
