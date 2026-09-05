#!/usr/bin/env python3
"""
Schedules the next Instagram post for @witnessatlas on PostPeer.

Run weekly (see the witnessatlas-ig-post scheduled task) — each run books one
post, about a week out, for the next approved species not yet in ig-posted.json.

    python3 tools/ig_schedule.py            # schedule the next post, ~a week out
    python3 tools/ig_schedule.py --dry-run  # print the plan, touch nothing
    python3 tools/ig_schedule.py --hours 24 # manual test: schedule sooner (min 24h buffer)

Disk is the queue: ig-posted.json is the record. A species is consumed when its
id appears there. Re-running is safe — nothing is re-posted. PostPeer's servers
do the actual publishing at the scheduled time, so nothing has to be awake then.

Credentials: source /Users/avp/Documents/CLAUDE/WITNESS/IG/.env first
(POSTPEER_API_KEY). That key's PostPeer workspace also runs Lullable's
IG/TikTok/YouTube posting — credits are shared across all of them.
"""
import json, os, sys, urllib.error, urllib.request
from datetime import datetime, timedelta
from pathlib import Path
from zoneinfo import ZoneInfo

SITE = Path(__file__).parent.parent / "witness_web" / "site"
SPECIES = SITE / "data" / "species.json"
POSTED = SITE / "content" / "ig-posted.json"

API = "https://api.postpeer.dev/v1/posts"
USAGE = "https://api.postpeer.dev/v1/usage"
ACCOUNT = "6a9c5cb6243e87581173966f"           # @witnessatlas, from /v1/connect/integrations
IMAGE_BASE = "https://witnessatlas.com/images/plates"
TZ = "America/Mexico_City"
DAYS_OUT = 7
AT = "09:00"
CLOSING = "Free on iPhone. Link in bio."


def load(p, default):
    return json.loads(p.read_text()) if p.exists() else default


def live(url):
    try:
        req = urllib.request.Request(url, method="HEAD")
        with urllib.request.urlopen(req, timeout=15) as r:
            return r.status == 200
    except urllib.error.URLError:
        return False


def credits(key):
    """Ask PostPeer, not our own count — a credit is spent at scheduling time,
    not publish time, and the cycle doesn't follow the calendar month. Sum
    monthly + purchased since this workspace tops up with purchased credits
    once the monthly free tier runs dry."""
    try:
        req = urllib.request.Request(USAGE, headers={"x-access-key": key})
        with urllib.request.urlopen(req, timeout=15) as r:
            b = json.loads(r.read())["balance"]
        left = b["monthly"]["remaining"] + b["purchased"]["remaining"]
        return left, b["monthly"]["cycleEnd"][:10]
    except (urllib.error.URLError, KeyError, ValueError):
        return None, None


def caption(species):
    story = species["story"][0]["text"] if species.get("story") else ""
    action = species.get("action", {}).get("summary", "")
    parts = [species["hook"], story, action, CLOSING]
    return "\n\n".join(p for p in parts if p)


def main():
    args = sys.argv[1:]
    dry = "--dry-run" in args
    hours_out = int(args[args.index("--hours") + 1]) if "--hours" in args else DAYS_OUT * 24
    if hours_out < 24:
        sys.exit("refusing to schedule less than 24h out (no review window before it goes live)")
    key = os.environ.get("POSTPEER_API_KEY")
    if not key:
        sys.exit("POSTPEER_API_KEY not set (source /Users/avp/Documents/CLAUDE/WITNESS/IG/.env)")

    left, cycle_end = credits(key)
    if left is None:
        print("! could not read /v1/usage — proceeding, PostPeer will reject if out of credits")
    else:
        print(f"credits: {left} left (monthly + purchased), monthly cycle resets {cycle_end}")
        if left <= 0:
            sys.exit(f"No credits left. Monthly resets {cycle_end}; check purchased balance too.")

    species = load(SPECIES, [])
    posted = set(load(POSTED, []))
    species = sorted(species, key=lambda s: s.get("publishDate", ""))
    next_up = next((s for s in species if s["id"] not in posted), None)
    if not next_up:
        sys.exit("queue exhausted — all approved cards are posted. "
                 "Next batch: content/cards/drafts/ (needs founder fact-check).")

    image_url = f"{IMAGE_BASE}/{next_up['id']}-detail-01.webp"
    if not live(image_url):
        sys.exit(f"image not live: {image_url}")

    text = caption(next_up)
    when = datetime.now(ZoneInfo(TZ)) + timedelta(hours=hours_out)

    print(f"\nnext: {next_up['id']}")
    print(f"scheduled for: {when.isoformat()}")
    print(f"image: {image_url}")
    print(f"\n{text}\n")

    if dry:
        return

    payload = {
        "content": text,
        "mediaItems": [{"url": image_url, "type": "image"}],
        "platforms": [{"platform": "instagram", "accountId": ACCOUNT}],
        "scheduledFor": when.isoformat(),
        "timezone": TZ,
    }
    req = urllib.request.Request(API, data=json.dumps(payload).encode(), method="POST",
                                  headers={"x-access-key": key, "Content-Type": "application/json"})
    try:
        with urllib.request.urlopen(req, timeout=30) as r:
            res = json.loads(r.read())
    except urllib.error.HTTPError as e:
        sys.exit(f"FAILED: {e.code} {e.read().decode()[:300]}")

    posted_list = load(POSTED, [])
    posted_list.append(next_up["id"])
    POSTED.write_text(json.dumps(posted_list, indent=2) + "\n")
    print(f"scheduled: {res}")


if __name__ == "__main__":
    main()
