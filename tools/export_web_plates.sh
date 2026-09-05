#!/usr/bin/env bash
# Export the approved catalog art, the app screenshots, and the free opening
# letter (audio + narrated text) into the website. Idempotent: an output newer
# than its source is skipped. Run from anywhere: tools/export_web_plates.sh
set -euo pipefail
cd "$(dirname "$0")/.."
SITE=witness_web/site
ASSETS=WitnessApp/Assets.xcassets
mkdir -p "$SITE/public/images/plates" "$SITE/public/images/app" "$SITE/public/audio" "$SITE/data"

# 1. Plates: every gallery asset of every record, plus the Field Season plate.
#    Ids come from gallery[] because monarch-butterfly's assets are prefixed "monarch-".
n=0
for id in $(jq -r '.[].gallery[]' "$SITE/data/species.json") season-plate-01; do
  in="$ASSETS/$id.imageset/$id.png"; out="$SITE/public/images/plates/$id.webp"
  [ -f "$in" ] || { echo "missing $in" >&2; exit 1; }
  [ "$out" -nt "$in" ] && continue
  cwebp -q 80 -quiet "$in" -o "$out"; n=$((n + 1))
done
echo "plates: $n converted, $(ls "$SITE/public/images/plates" | wc -l | tr -d ' ') total"

# 2. App screenshots: raw simulator captures in docs/appstore/screenshots/web/,
#    top 7% (the status bar) cropped so one CSS bezel fits every shot.
for in in docs/appstore/screenshots/web/*.png; do
  [ -e "$in" ] || break
  out="$SITE/public/images/app/$(basename "${in%.png}").webp"
  [ "$out" -nt "$in" ] && continue
  w=$(sips -g pixelWidth "$in" | awk '/pixelWidth/{print $2}')
  h=$(sips -g pixelHeight "$in" | awk '/pixelHeight/{print $2}')
  top=$((h * 7 / 100))
  cwebp -q 82 -quiet -crop 0 "$top" "$w" $((h - top)) "$in" -o "$out"
  echo "screenshot: $out $w x $((h - top))"
done

# 3. The free opening letter: the bundled narration and its exact narrated text.
cp -p WitnessApp/Resources/letter-the-thin-line-ruth.mp3 "$SITE/public/audio/letter-the-thin-line.mp3"
grep -o '<p>.*</p>' content/field-season-1/audio/letter-the-thin-line.ssml | sed -e 's/<[^>]*>//g' > "$SITE/data/letter-transcript.txt"
echo "transcript: $(wc -l < "$SITE/data/letter-transcript.txt" | tr -d ' ') paragraphs"
