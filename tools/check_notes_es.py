#!/usr/bin/env python3
"""Check witness_web/community/content/posts-es/ against content/posts/.

Every English note needs a Spanish file with the same name. Frontmatter keys,
section, image, type and sources must match; title, description and question
must be translated; the body must keep the same block structure (headings,
lists, quotes, paragraphs), the same links, and the same numerals. Exit 1 on
any problem. Run it after the daily engine publishes a note.
"""
import re, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent / "witness_web/community/content"
EN, ES = ROOT / "posts", ROOT / "posts-es"
FIXED = ("section", "image", "type", "sources")
TRANSLATED = ("title", "description", "question")
NUM = re.compile(r"\d[\d,.]*\d|\d")
DECADE = re.compile(r"\b\d{4}s\b")  # "the 1980s" is "los años ochenta" in Spanish
LINK = re.compile(r"\]\(([^)]+)\)")

def parse(path):
    m = re.match(r"^---\n([\s\S]*?)\n---\n([\s\S]*)$", path.read_text())
    if not m: sys.exit(f"{path.name}: missing frontmatter")
    meta = dict(re.findall(r"^(\w+):\s*(.*)$", m.group(1), re.M))
    blocks = [b.strip() for b in re.split(r"\n\s*\n", m.group(2).strip())]
    return meta, blocks

def kind(block):
    for prefix, name in (("### ", "h3"), ("## ", "h2"), ("- ", "list"), ("> ", "quote")):
        if block.startswith(prefix): return name
    return "p"

def numerals(en, es):
    years = {d[:-1] for d in DECADE.findall(en)}
    return sorted(n for n in NUM.findall(en) if n not in years), sorted(n for n in NUM.findall(es) if n not in years)

def main():
    problems = []
    en_files = sorted(EN.glob("*.md")); es_names = {p.name for p in ES.glob("*.md")}
    for stale in es_names - {p.name for p in en_files}: problems.append(f"{stale}: in posts-es but not in posts")
    for path in en_files:
        es_path = ES / path.name
        if not es_path.exists(): problems.append(f"{path.name}: missing from posts-es"); continue
        a, ab = parse(path); b, bb = parse(es_path)
        if a.keys() != b.keys(): problems.append(f"{path.name}: frontmatter keys differ {sorted(a.keys() ^ b.keys())}")
        for k in FIXED:
            if a.get(k) != b.get(k): problems.append(f"{path.name}: {k} changed")
        if all(a.get(k) == b.get(k) for k in TRANSLATED if k in a) and all(x == y for x, y in zip(ab, bb)):
            problems.append(f"{path.name}: not translated"); continue
        if [kind(x) for x in ab] != [kind(x) for x in bb]:
            problems.append(f"{path.name}: block structure differs ({len(ab)} vs {len(bb)} blocks)"); continue
        for i, (x, y) in enumerate(zip(ab, bb)):
            if sorted(LINK.findall(x)) != sorted(LINK.findall(y)): problems.append(f"{path.name} block {i + 1}: links differ")
            nv, nw = numerals(x, y)
            if nv != nw: problems.append(f"{path.name} block {i + 1}: numerals differ {nv} vs {nw}")
    for p in problems: print(p)
    print(f"{len(en_files) - sum(1 for p in problems if p.endswith('missing from posts-es'))}/{len(en_files)} notes translated, {len(problems)} problems")
    sys.exit(1 if problems else 0)

if __name__ == "__main__":
    main()
