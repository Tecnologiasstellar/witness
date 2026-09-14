#!/usr/bin/env python3
"""Check witness_web/site/data/species.es.json against species.json.

Reports records missing from the Spanish file (the weekly export adds one),
non-translatable fields that drifted, records left entirely in English,
and numerals that do not survive translation. Exit 1 on any problem.
"""
import json, re, sys
from pathlib import Path

SITE = Path(__file__).resolve().parent.parent / "witness_web/site/data"
NUM = re.compile(r"\d[\d,.]*\d|\d")
DECADE = re.compile(r"\b\d{4}s\b")  # "the 1980s" is "los años ochenta" in Spanish

def translatable(r):
    """Paths (tuples) of the human-readable fields the record page renders."""
    out = {("commonName",), ("conservationStatus", "displayName"), ("generalizedRange",), ("hook",),
           ("media", "depictionType")}
    for k in ("title", "summary", "effort", "geographicApplicability"): out.add(("action", k))
    for k in ("size", "lifespan", "diet", "populationEstimate", "populationAsOf"):
        if k in r.get("stats", {}): out.add(("stats", k))
    for i in range(len(r.get("stats", {}).get("threats", []))): out.add(("stats", "threats", i))
    for k in ("reproduction", "insight"):
        if k in r: out.add((k, "text"))
    for i in range(len(r["story"])): out.add(("story", i, "text"))
    for i in range(len(r.get("programs", []))): out.update({("programs", i, "title"), ("programs", i, "summary")})
    return out

def walk(o, path=()):
    if isinstance(o, dict):
        for k, v in o.items(): yield from walk(v, path + (k,))
    elif isinstance(o, list):
        for i, v in enumerate(o): yield from walk(v, path + (i,))
    else:
        yield path, o

def main():
    en = {r["id"]: r for r in json.load((SITE / "species.json").open())}
    es = {r["id"]: r for r in json.load((SITE / "species.es.json").open())}
    problems = []
    for rid in en.keys() - es.keys(): problems.append(f"{rid}: missing from species.es.json")
    for rid in es.keys() - en.keys(): problems.append(f"{rid}: in species.es.json but not in species.json")
    for rid in en.keys() & es.keys():
        tr = translatable(en[rid])
        a, b = dict(walk(en[rid])), dict(walk(es[rid]))
        if a.keys() != b.keys(): problems.append(f"{rid}: structure differs at {sorted(a.keys() ^ b.keys())[:3]}")
        if all(b.get(path) == v for path, v in a.items() if path in tr):
            problems.append(f"{rid}: not translated (every rendered field is still English)")
        for path, v in a.items():
            if path not in b: continue
            w = b[path]
            if path in tr:
                if isinstance(v, str):
                    years = {d[:-1] for d in DECADE.findall(v)}  # "1980s" may become "los años ochenta" or "la década de 1980"
                    nv = sorted(n for n in NUM.findall(v) if n not in years)
                    nw = sorted(n for n in NUM.findall(w) if n not in years)
                    if nv != nw: problems.append(f"{rid}/{'/'.join(map(str, path))}: numerals differ {nv} vs {nw}")
            elif w != v:
                problems.append(f"{rid}/{'/'.join(map(str, path))}: non-translatable field changed")
    community = SITE.parent.parent / "community/data/species.es.json"
    if community.exists() and community.read_bytes() != (SITE / "species.es.json").read_bytes():
        problems.append("witness_web/community/data/species.es.json differs from the site copy (cp it over)")
    for p in problems: print(p)
    print(f"{len(es)}/{len(en)} records translated, {len(problems)} problems")
    sys.exit(1 if problems else 0)

if __name__ == "__main__":
    main()
