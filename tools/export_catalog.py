#!/usr/bin/env python3
"""Merge Resources/catalog/*.json into one array on stdout, in app order.

The website serves a verbatim copy of the app catalog; sync it with:

    python3 tools/export_catalog.py > witness_web/site/data/species.json
"""

import json
from pathlib import Path

CATALOG = Path(__file__).resolve().parent.parent / "Packages/WitnessCore/Sources/WitnessCore/Resources/catalog"

records = [json.loads(p.read_text()) for p in CATALOG.glob("*.json")]
records.sort(key=lambda r: (r["publishDate"], r["id"]))
print(json.dumps(records, indent=2, ensure_ascii=False))
