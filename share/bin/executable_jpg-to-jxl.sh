#!/usr/bin/env bash

# Convert JPEG files to same-name JPEG XL (.jxl) files using ImageMagick.
#
# Source files are deleted after successful conversion unless -k/--keep is given.

set -uo pipefail

QUALITY=90
EFFORT=5

usage() {
    cat <<'EOF'
USAGE:
  jpg-to-jxl.sh [-k, --keep] [-n, --dry-run] DIR | FILE...

Convert JPEG files to same-name JPEG XL (.jxl) files.

  DIR      Recursively convert all .jpg, .JPG, .jpeg and .JPEG files in DIR.
  FILE...  Convert each FILE (any format ImageMagick can read).

OPTIONS:
  -k, --keep     Keep source files (default: delete them after conversion).
  -n, --dry-run  Show what would be converted without changing any files.
  -h, --help     Show this help and exit.
EOF
}

keep=false
dry_run=false
while [ $# -gt 0 ]; do
    case "$1" in
        -k | --keep) keep=true ;;
        -n | --dry-run) dry_run=true ;;
        -h | --help) usage; exit 0 ;;
        --) shift; break ;;
        -*) echo "Error: unknown option: $1" >&2; usage >&2; exit 2 ;;
        *) break ;;
    esac
    shift
done

if [ $# -eq 0 ]; then
    usage >&2
    exit 2
fi

if ! command -v magick >/dev/null 2>&1; then
    echo "Error: 'magick' (ImageMagick) not found in PATH." >&2
    exit 1
fi

# Collect source files: directories are searched recursively, files are used as-is.
sources=()
status=0
for arg in "$@"; do
    if [ -d "$arg" ]; then
        while IFS= read -r -d '' file; do
            sources+=("$file")
        done < <(find "$arg" -type f \( -name '*.jpg' -o -name '*.JPG' -o -name '*.jpeg' -o -name '*.JPEG' \) -print0)
    elif [ -f "$arg" ]; then
        sources+=("$arg")
    else
        echo "Error: no such file or directory: $arg" >&2
        status=1
    fi
done

if [ "${#sources[@]}" -eq 0 ]; then
    echo "No files to convert."
    exit "$status"
fi

src_total=0
dst_total=0
converted=0
skipped=0
failed=0
would_convert=0
would_src_total=0

for src in "${sources[@]}"; do
    name=${src##*/}
    case "$name" in
        *.*) dst="${src%.*}.jxl" ;;
        *)   dst="$src.jxl" ;;
    esac

    if [ "$dst" = "$src" ]; then
        echo "Skipping (already JPEG XL): $src"
        skipped=$((skipped + 1))
        continue
    fi
    if [ -e "$dst" ]; then
        echo "Skipping (output exists): $dst" >&2
        skipped=$((skipped + 1))
        continue
    fi

    if [ "$dry_run" = true ]; then
        printf '%q ' magick "$src" -quality "$QUALITY" -define jxl:effort="$EFFORT" "$dst"
        echo
        src_size=$(stat -c %s -- "$src")
        would_src_total=$((would_src_total + src_size))
        would_convert=$((would_convert + 1))
        continue
    fi

    echo "Converting: $src -> $dst"
    if magick "$src" -quality "$QUALITY" -define jxl:effort="$EFFORT" "$dst"; then
        src_size=$(stat -c %s -- "$src")
        dst_size=$(stat -c %s -- "$dst")
        src_total=$((src_total + src_size))
        dst_total=$((dst_total + dst_size))
        converted=$((converted + 1))

        if [ "$keep" = false ] && ! rm -f -- "$src"; then
            echo "Error: could not delete source: $src" >&2
            status=1
        fi
    else
        echo "Error: conversion failed: $src" >&2
        rm -f -- "$dst"
        failed=$((failed + 1))
        status=1
    fi
done

echo
if [ "$dry_run" = true ]; then
    echo "Dry run: no files were changed."
    echo "Would convert:  $would_convert file(s) (skipped: $skipped)"
    echo "Source size:    $(numfmt --to=iec-i --suffix=B "$would_src_total")"
    if [ "$keep" = false ]; then
        echo "Sources would be deleted after conversion."
    fi
elif [ "$converted" -eq 0 ]; then
    echo "No files converted (skipped: $skipped, failed: $failed)."
else
    percent=$(awk -v s="$src_total" -v d="$dst_total" \
        'BEGIN { printf "%.1f", (s > 0 ? (s - d) * 100 / s : 0) }')
    echo "Converted:      $converted file(s) (skipped: $skipped, failed: $failed)"
    echo "Source size:    $(numfmt --to=iec-i --suffix=B "$src_total")"
    echo "Generated size: $(numfmt --to=iec-i --suffix=B "$dst_total")"
    echo "Compression:    $percent%"
fi

exit "$status"
