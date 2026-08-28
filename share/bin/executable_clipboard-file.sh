#!/usr/bin/env bash

# Usage:
#     clipboard-file.sh COMMAND
#
# Description:
#     Reads, writes and appends the $HOME/vboxsf/clipboard.txt clipboard
#     file from and to the system clipboard.
#
# Commands:
#     read        Reads the text from the clipboard file to the system clipboard
#     write       Writes the text from the system clipboard to the clipboard file
#     append      Appends the text starting on a new line from the system
#                 clipboard to the clipboard file
#     cat         Reads the text from the clipboard file to the system clipboard
#                 and writes it to stdout
#     watch       Continuously monitors the clipboard file and system clipboard,
#                 synchronising changes at a 5 second polling interval

set -e

CLIP_FILE="$HOME/vboxsf/clipboard.txt"
POLL_INTERVAL=5

if command -v wl-copy >/dev/null 2>&1; then
    COPY_CMD=wl-copy
    PASTE_CMD=wl-paste
elif command -v xclip >/dev/null 2>&1; then
    COPY_CMD='xclip -selection clipboard'
    PASTE_CMD='xclip -selection clipboard -o'
else
    echo "Error: neither wl-copy nor xclip is installed" >&2
    exit 1
fi

usage() {
    echo "Usage: $(basename "$0") COMMAND" >&2
    echo "Commands: read, write, append, cat, watch" >&2
    exit 1
}

[ $# -eq 1 ] || usage

touch "$CLIP_FILE"

case "$1" in
read)
    $COPY_CMD <"$CLIP_FILE"
    ;;
write)
    $PASTE_CMD >"$CLIP_FILE"
    ;;
append)
    $PASTE_CMD >>"$CLIP_FILE"
    printf '\n' >>"$CLIP_FILE"
    ;;
cat)
    $COPY_CMD <"$CLIP_FILE"
    cat "$CLIP_FILE"
    ;;
watch)
    prev_file=$(cat "$CLIP_FILE")
    prev_clip=$($PASTE_CMD 2>/dev/null || echo "")

    while true; do
        cur_file=$(cat "$CLIP_FILE")
        cur_clip=$($PASTE_CMD 2>/dev/null || echo "")

        if [ "$cur_file" != "$prev_file" ]; then
            printf '%s' "$cur_file" | $COPY_CMD
            prev_clip="$cur_file"
        elif [ "$cur_clip" != "$prev_clip" ]; then
            printf '%s' "$cur_clip" >"$CLIP_FILE"
            prev_file="$cur_clip"
        fi

        prev_file="$cur_file"
        prev_clip="$cur_clip"

        sleep "$POLL_INTERVAL"
    done
    ;;
*)
    usage
    ;;
esac
