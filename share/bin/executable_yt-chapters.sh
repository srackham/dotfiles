#!/usr/bin/env bash

set -euo pipefail

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <youtube-url>" >&2
    exit 1
fi

url="$1"

json=$(yt-dlp --dump-json "$url")

# Check if chapters exist before attempting to iterate over them
if echo "$json" | jq -e '.chapters == null or (.chapters | length == 0)' >/dev/null; then
    echo "Error: No chapters found for this video." >&2
    exit 1
fi

echo "$json" | jq -r --arg url "$url" '
    .chapters[] |
    "- [" + .title + "](" + $url + "&t=" +
    (.start_time | floor | tostring) + "s)"
'
