#!/bin/sh
# Voice audition for Field Season narration (founder decision 2026-08-26).
# Synthesizes the chapter-1 field note in the three Polly long-form voices
# so the founder can choose by ear. Synchronous API — no S3 bucket needed.
# Usage: content/field-season-1/audio/audition.sh [aws-profile]
# Cost: ~1.1k chars x 3 voices at $100/1M chars ≈ $0.35 total.
set -eu
cd "$(dirname "$0")"

PROFILE="${1:-lullable}"
OUT="${TMPDIR:-/tmp}/witness-audition"
mkdir -p "$OUT"

for VOICE in Ruth Danielle Gregory; do
    echo "Synthesizing $VOICE (long-form)..."
    aws polly synthesize-speech \
        --profile "$PROFILE" \
        --region us-east-1 \
        --engine long-form \
        --voice-id "$VOICE" \
        --output-format mp3 \
        --text-type ssml \
        --text "file://audition-excerpt.ssml" \
        "$OUT/vaquita-audition-$(echo "$VOICE" | tr '[:upper:]' '[:lower:]').mp3"
done

echo
echo "Done. Auditions in $OUT:"
ls -la "$OUT"
