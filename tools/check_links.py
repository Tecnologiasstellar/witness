#!/usr/bin/env python3
"""Verify every URL in the species catalog is alive. Stdlib only; used by CI.

By default only records with editorial.state == "approved" fail the build
(the production bar). During card production run:

    python3 tools/check_links.py --all            # every record
    python3 tools/check_links.py --all --only vaquita
    python3 tools/check_links.py --selftest       # verdict logic, no network

Alive: HTTP < 400, plus 401/403/405/429 and unfollowable 307/308 (a followable
redirect never surfaces as an error, so these are JS bot gates on conservation
sites; the link exists). Dead: 404/410, 5xx, or a domain that no longer
resolves. Exit code 1 on any dead link.

A host that refuses, resets or times out the connection is reported UNREACHABLE
and does not fail the build. The runner learned nothing about whether the page
exists, and a socket is not a 404: tpwd.texas.gov serves the whooping-crane
links fine from a desk while blocking GitHub's runners outright, which kept
every iOS CI run red through September 2026. A dead *domain* still fails —
NXDOMAIN is real evidence about the URL; a refused connection is evidence about
the network in between.
"""

import json
import os
import socket
import ssl
import sys
import time
import urllib.request
from pathlib import Path

CATALOG = Path(__file__).resolve().parent.parent / "Packages/WitnessCore/Sources/WitnessCore/Resources/catalog"
WARN_STATUSES = {307, 308, 401, 403, 405, 429}
GONE_STATUSES = {404, 410}
ATTEMPTS = 3
TIMEOUT = 20
HEADERS = {
    "User-Agent": "Mozilla/5.0 (Macintosh) WitnessLinkCheck/1.0",
    "Accept": "text/html,application/xhtml+xml,*/*;q=0.8",
}

ALIVE, DEAD, UNREACHABLE = "alive", "dead", "unreachable"
LABELS = {ALIVE: "ok  ", DEAD: "DEAD", UNREACHABLE: "????"}


def urls_in(record: dict) -> set[str]:
    urls = {s["url"] for s in record["sources"]}
    urls.add(record["action"]["destinationURL"])
    urls.update(p["url"] for p in record.get("programs") or [])
    return {u for u in urls if u.startswith("https://")}


def classify(error: BaseException) -> tuple[str, str]:
    """Verdict for a transport-level failure. Pure — see --selftest."""
    reason = getattr(error, "reason", error)
    if isinstance(reason, socket.gaierror):
        # EAI_NONAME means the name does not exist: the URL is dead. Every other
        # resolver error (EAI_AGAIN and friends) is DNS having a bad day and
        # says nothing about the domain.
        if reason.errno == socket.EAI_NONAME:
            return DEAD, f"domain does not resolve ({reason})"
        return UNREACHABLE, f"DNS: {reason}"
    return UNREACHABLE, str(reason)


def check(url: str) -> tuple[str, str]:
    context = ssl.create_default_context()
    last = (UNREACHABLE, "unknown")
    for attempt in range(ATTEMPTS):
        request = urllib.request.Request(url, headers=HEADERS)
        try:
            with urllib.request.urlopen(request, timeout=TIMEOUT, context=context) as response:
                return ALIVE, f"{response.status}"
        except urllib.error.HTTPError as error:
            if error.code in WARN_STATUSES:
                return ALIVE, f"{error.code} (bot gate; treated as alive)"
            if error.code in GONE_STATUSES:
                return DEAD, f"HTTP {error.code}"
            last = (DEAD, f"HTTP {error.code}")  # 5xx may be a bad minute; retry
        except (urllib.error.URLError, TimeoutError, ssl.SSLError, ConnectionError) as error:
            last = classify(error)
            if last[0] == DEAD:
                return last
        if attempt + 1 < ATTEMPTS:
            time.sleep(2 * (attempt + 1))
    return last


def selftest() -> None:
    gone = urllib.error.URLError(socket.gaierror(socket.EAI_NONAME, "Name or service not known"))
    assert classify(gone)[0] == DEAD, "NXDOMAIN must fail the build"

    flaky_dns = urllib.error.URLError(socket.gaierror(socket.EAI_AGAIN, "Temporary failure"))
    assert classify(flaky_dns)[0] == UNREACHABLE, "a resolver blip is not a dead domain"

    refused = urllib.error.URLError(ConnectionRefusedError(111, "Connection refused"))
    assert classify(refused)[0] == UNREACHABLE, "the tpwd.texas.gov case"
    assert classify(TimeoutError("timed out"))[0] == UNREACHABLE
    assert classify(urllib.error.URLError(ssl.SSLError("handshake failure")))[0] == UNREACHABLE

    print("selftest ok — NXDOMAIN fails, blocked sockets do not.")


def main() -> None:
    if "--selftest" in sys.argv:
        selftest()
        return

    check_all = "--all" in sys.argv
    only = sys.argv[sys.argv.index("--only") + 1] if "--only" in sys.argv else None
    # --dir lets staged drafts (content/cards/drafts) be checked before promotion.
    directory = Path(sys.argv[sys.argv.index("--dir") + 1]) if "--dir" in sys.argv else CATALOG

    to_check: dict[str, list[str]] = {}
    for path in sorted(directory.glob("*.json")):
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

    failures, unreachable = [], []
    for url, ids in sorted(to_check.items()):
        state, detail = check(url)
        print(f"{LABELS[state]} {url} [{', '.join(ids)}] {detail}")
        if state == DEAD:
            failures.append(url)
        elif state == UNREACHABLE:
            unreachable.append(url)

    if unreachable:
        print(f"\n{len(unreachable)} link(s) unreachable from this network — not judged:")
        for url in unreachable:
            print(f"  {url}")
            # Green build, visible warning: an unreachable link is the one way
            # real rot could now pass, so surface it in the run summary.
            if os.environ.get("GITHUB_ACTIONS"):
                print(f"::warning title=Unreachable link::{url}")
        print("Open them by hand. A host that blocks CI is not a dead link.")

    if failures:
        sys.exit(f"\n{len(failures)} dead link(s) — fix or replace before merging.")
    print(f"\nAll {len(to_check) - len(unreachable)} reachable links alive.")


if __name__ == "__main__":
    main()
