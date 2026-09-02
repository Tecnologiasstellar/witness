#!/usr/bin/env python3
"""Validate a staged card draft against the CatalogValidator rules, offline.

Mirrors Packages/WitnessCore/Sources/WitnessCore/Catalog/CatalogValidator.swift
so a draft living outside the bundle (content/cards/drafts) can be checked
before promotion. Accepts editorial.state prototype or approved. Stdlib only.

    python3 tools/validate_card.py content/cards/drafts/black-rhino.json
"""

import json
import re
import sys
from pathlib import Path

DATE = re.compile(r"^\d{4}-\d{2}-\d{2}$")


def is_https(url: str) -> bool:
    return url.startswith("https://") and len(url) > len("https://") and "." in url.split("/")[2]


def validate(record: dict) -> list[str]:
    errors: list[str] = []
    text = json.dumps(record)
    if "TODO" in text:
        errors.append(f"unresolved TODO markers: {text.count('TODO')}")

    for key in ("id", "commonName", "scientificName", "generalizedRange", "hook"):
        if not str(record.get(key, "")).strip():
            errors.append(f"{key} is blank")
    if record.get("schemaVersion", 0) < 1:
        errors.append("schemaVersion must be >= 1")

    source_ids = [s["id"] for s in record.get("sources", [])]
    if len(source_ids) != len(set(source_ids)):
        errors.append("duplicate source ids")
    declared = set(source_ids)
    for source in record.get("sources", []):
        if not is_https(source.get("url", "")):
            errors.append(f"source {source.get('id')} url is not https")
        if not DATE.match(source.get("lastAccessed", "")):
            errors.append(f"source {source.get('id')} lastAccessed not YYYY-MM-DD")

    def refs(label: str, ids) -> None:
        if not ids:
            errors.append(f"{label}.sourceIDs is empty")
        elif not set(ids) <= declared:
            errors.append(f"{label}.sourceIDs not declared: {sorted(set(ids) - declared)}")

    words = 0
    for section in record.get("story", []):
        words += len(section.get("text", "").split())
        refs(f"story[{section.get('id')}]", section.get("sourceIDs"))
    if not 120 <= words <= 220:
        errors.append(f"story is {words} words; must be 120-220")

    action = record.get("action", {})
    refs("action", action.get("sourceIDs"))
    if not is_https(action.get("destinationURL", "")):
        errors.append("action.destinationURL is not https")
    if not DATE.match(action.get("lastVerified", "")):
        errors.append("action.lastVerified not YYYY-MM-DD")
    if action.get("measurementType") not in ("opened", "self_reported", "verified"):
        errors.append("action.measurementType invalid")

    media = record.get("media", {})
    for key in ("assetID", "license", "commercialUseStatus"):
        if not str(media.get(key, "")).strip():
            errors.append(f"media.{key} is blank")

    editorial = record.get("editorial", {})
    if editorial.get("state") not in ("prototype", "approved"):
        errors.append("editorial.state must be prototype or approved")
    if editorial.get("sensitiveLocationReview") != "generalized":
        errors.append("editorial.sensitiveLocationReview must be 'generalized'")
    if not DATE.match(editorial.get("lastFactChecked", "")):
        errors.append("editorial.lastFactChecked not YYYY-MM-DD")
    if not DATE.match(record.get("publishDate", "")):
        errors.append("publishDate not YYYY-MM-DD")

    stats = record.get("stats")
    if stats:
        refs("stats", stats.get("sourceIDs"))
        if stats.get("populationEstimate") and not stats.get("populationAsOf"):
            errors.append("stats.populationAsOf required with populationEstimate")
        threats = stats.get("threats", [])
        if any(not t.strip() for t in threats):
            errors.append("stats.threats contains an empty string")
        if len(threats) != 4:
            errors.append(f"stats.threats has {len(threats)}; house style is exactly 4")
        if stats.get("trend") not in ("increasing", "decreasing", "stable", "unknown"):
            errors.append("stats.trend invalid")
    for key in ("reproduction", "insight"):
        if record.get(key):
            refs(key, record[key].get("sourceIDs"))

    gallery = record.get("gallery")
    if gallery is not None and (not gallery or any(not g for g in gallery)):
        errors.append("gallery must be non-empty with no empty ids")

    for region in record.get("habitatRegions") or []:
        if region.get("radiusKm", 0) < 25:
            errors.append(f"habitatRegion {region.get('name')} radiusKm < 25")
        if not -90 <= region.get("latitude", 999) <= 90 or not -180 <= region.get("longitude", 999) <= 180:
            errors.append(f"habitatRegion {region.get('name')} coordinates out of range")

    for program in record.get("programs") or []:
        refs(f"program {program.get('id')}", program.get("sourceIDs"))
        if not is_https(program.get("url", "")):
            errors.append(f"program {program.get('id')} url is not https")
        if not DATE.match(program.get("lastVerified", "")):
            errors.append(f"program {program.get('id')} lastVerified not YYYY-MM-DD")
        if program.get("kind") not in ("program", "sponsor"):
            errors.append(f"program {program.get('id')} kind invalid")

    if len(record.get("hook", "")) > 80:
        errors.append(f"hook is {len(record['hook'])} chars; keep it under 80")
    return errors


def main() -> None:
    paths = [Path(p) for p in sys.argv[1:]] or sorted(Path("content/cards/drafts").glob("*.json"))
    failed = False
    for path in paths:
        record = json.loads(path.read_text())
        errors = validate(record)
        words = sum(len(s.get("text", "").split()) for s in record.get("story", []))
        status = "ok  " if not errors else "FAIL"
        print(f"{status} {path.name} ({words} story words, {len(record.get('sources', []))} sources)")
        for error in errors:
            print(f"     - {error}")
        failed |= bool(errors)
    sys.exit(1 if failed else 0)


if __name__ == "__main__":
    main()
