#!/bin/zsh
# Render a Field Season plate SVG into its app imageset.
# Usage: tools/render_plate.sh season-plate-01
# Boring tech on purpose: qlmanage (WebKit) renders the SVG, sips crops the
# square thumbnail back to the plate's 940:1400 aspect. Rerun after any SVG
# edit, then: xcodegen generate is NOT needed (imageset already registered),
# but commit the PNG.
set -e
NAME=${1:?plate name, e.g. season-plate-01}
ROOT=$(cd "$(dirname "$0")/.." && pwd)
SVG="$ROOT/content/field-season-1/plate/$NAME.svg"
OUT="$ROOT/WitnessApp/Assets.xcassets/$NAME.imageset"
TMP=$(mktemp -d)
qlmanage -t -s 2100 -o "$TMP" "$SVG" > /dev/null 2>&1
sips --cropToHeightWidth 2100 1410 "$TMP/$NAME.svg.png" --out "$OUT/$NAME.png" > /dev/null
rm -rf "$TMP"
echo "rendered $OUT/$NAME.png ($(sips -g pixelWidth -g pixelHeight "$OUT/$NAME.png" | awk '/pixel/{printf "%s ", $2}'))"
