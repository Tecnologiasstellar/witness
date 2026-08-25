#!/usr/bin/env python3
"""Verify every URL in the species catalog is alive. Stdlib only; used by CI.

By default only records with editorial.state == "approved" fail the build
(the production bar). During card production run:

    python3 tools/check_links.py --all            # every record
    python3 tools/check_links.py --all --only vaquita

Pass: HTTP < 400. Warn-pass: 401/403/405/429, and 307/308 that urllib could
not follow (a followable redirect never surfaces as an error, so these are
JS bot gates on conservation sites; the link exists). Fail: 404/410, 5xx,
or connection errors after 2 attempts. Exit code 1 on any failure.
"""

import json
import ssl
import sys
import urllib.request
from pathlib import Path

CATALOG = Path(__file__).resolve().parent.parent / "Packages/WitnessCore/Sources/WitnessCore/Resources/catalog"
WARN_STATUSES = {307, 308, 401, 403, 405, 429}
HEADERS = {
    "User-Agent": "Mozilla/5.0 (Macintosh) WitnessLinkCheck/1.0",
    "Accept": "text/html,application/xhtml+xml,*/*;q=0.8",
}


def urls_in(record: dict) -> set[str]:
    urls = {s["url"] for s in record["sources"]}
    urls.add(record["action"]["destinationURL"])
    urls.update(p["url"] for p in record.get("programs") or [])
    return {u for u in urls if u.startswith("https://")}


def check(url: str) -> tuple[bool, str]:
    context = ssl.create_default_context()
    last = "unknown"
    for _ in range(2):
        request = urllib.request.Request(url, headers=HEADERS)
        try:
            with urllib.request.urlopen(request, timeout=20, context=context) as response:
                return True, f"{response.status}"
        except urllib.error.HTTPError as error:
            if error.code in WARN_STATUSES:
                return True, f"{error.code} (bot gate; treated as alive)"
            last = f"HTTP {error.code}"
        except (urllib.error.URLError, TimeoutError, ssl.SSLError, ConnectionError) as error:
            last = str(getattr(error, "reason", error))
    return False, last


def main() -> None:
    check_all = "--all" in sys.argv
    only = sys.argv[sys.argv.index("--only") + 1] if "--only" in sys.argv else None

    to_check: dict[str, list[str]] = {}
    for path in sorted(CATALOG.glob("*.json")):
        record = json.loads(path.read_text())
        if only and record["id"] != only:
            continue
        if not check_all and record["editorial"]["state"] != "approved":
            continue
        for url in urls_in(record):
            to_check.setdefault(url, []).append(record["id"])

    if not to_check:
        print("No records in scope (approved-only by default; use --all).")
        return

    failures = []
    for url, ids in sorted(to_check.items()):
        alive, detail = check(url)
        print(f"{'ok  ' if alive else 'DEAD'} {url} [{', '.join(ids)}] {detail}")
        if not alive:
            failures.append(url)

    if failures:
        sys.exit(f"\n{len(failures)} dead link(s) — fix or replace before merging.")
    print(f"\nAll {len(to_check)} links alive.")


if __name__ == "__main__":
    main()
