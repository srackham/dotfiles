#!/usr/bin/env bash

set -euo pipefail

# Check for yt-dlp dependency
if ! command -v yt-dlp &>/dev/null; then
    echo "Error: yt-dlp is not installed. Please install it first." >&2
    exit 1
fi

# Ensure URL argument is provided
if [ -z "${1:-}" ]; then
    echo "Usage: $0 <video-url>" >&2
    exit 1
fi

# Create a temporary file prefix
TMPFILE=$(mktemp /tmp/yt_sub_XXXXXX)
trap 'rm -f "${TMPFILE}"*' EXIT

# Download English subtitles (manual or auto-generated) as VTT
yt-dlp --skip-download \
    --write-auto-sub \
    --write-sub \
    --sub-lang "en.*,en" \
    --sub-format vtt \
    -o "${TMPFILE}" \
    "$1" >/dev/null 2>&1 || true

# Find the generated VTT file (yt-dlp appends .en.vtt or similar)
# Enable nullglob so unmatched patterns expand to nothing instead of the literal string
shopt -s nullglob
subfiles=("${TMPFILE}"*.vtt)
shopt -u nullglob

SUBFILE="${subfiles[0]:-}"

if [ -z "$SUBFILE" ] || [ ! -f "$SUBFILE" ]; then
    echo "Error: No English transcript found for this video." >&2
    exit 1
fi

# Clean VTT content:
# 1. Remove VTT headers and timestamp lines
# 2. Strip inline cue/formatting tags like <c> or timestamps inside lines
# 3. Strip duplicate consecutive lines (common in YouTube auto-generated captions)
sed -E \
    -e '/^WEBVTT/d' \
    -e '/^Kind:/d' \
    -e '/^Language:/d' \
    -e '/^NOTE/d' \
    -e '/^[0-9]{2}:[0-9]{2}/d' \
    -e 's/<[^>]*>//g' \
    "$SUBFILE" |
    awk '
    NF {
        # Trim leading/trailing whitespace
        gsub(/^[ \t]+|[ \t]+$/, "")
        # Print line only if it differs from the last printed line
        if ($0 != last) {
            print $0
            last = $0
        }
    }
'
