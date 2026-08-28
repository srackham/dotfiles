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

CLIPBOARD_FILE="$HOME/vboxsf/clipboard.txt"
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

case "$1" in
    read)
        $COPY_CMD <"$CLIPBOARD_FILE"
        ;;
    write)
        $PASTE_CMD >"$CLIPBOARD_FILE"
        ;;
    append)
        $PASTE_CMD >>"$CLIPBOARD_FILE"
        printf '\n' >>"$CLIPBOARD_FILE"
        ;;
    cat)
        $COPY_CMD <"$CLIPBOARD_FILE"
        cat "$CLIPBOARD_FILE"
        ;;
    watch)
        prev_file=$(cat "$CLIPBOARD_FILE" 2>/dev/null || true)
        prev_clipboard=$($PASTE_CMD 2>/dev/null || true)
        trap 'exit 0' INT TERM HUP
        while sleep "$POLL_INTERVAL"; do
            new_file=$(cat "$CLIPBOARD_FILE" 2>/dev/null || true)
            if [ "$new_file" != "$prev_file" ]; then
                $COPY_CMD <"$CLIPBOARD_FILE"
                prev_clipboard=$($PASTE_CMD 2>/dev/null || true)
                prev_file=$new_file
            else
                new_clipboard=$($PASTE_CMD 2>/dev/null || true)
                if [ "$new_clipboard" != "$prev_clipboard" ]; then
                    $PASTE_CMD >"$CLIPBOARD_FILE"
                    prev_file=$(cat "$CLIPBOARD_FILE" 2>/dev/null || true)
                    prev_clipboard=$new_clipboard
                fi
            fi
        done
        ;;
    *)
        usage
        ;;
esac