#!/usr/bin/env bash

# Usage:
#     clipboard-file.sh COMMAND
#
# Description:
#     Reads, writes and appends the $HOME/vboxsf/clipboard.txt clipboard
#     file from and to the system clipboard.
#
# Commands:
#     copy        Reads the text from the clipboard file to the system clipboard
#     paste       Writes the text from the system clipboard to the clipboard file
#     append      Appends the text starting on a new line from the system
#                 clipboard to the clipboard file

set -e

CLIPBOARD_FILE="$HOME/vboxsf/clipboard.txt"

usage() {
    echo "Usage: $(basename "$0") COMMAND" >&2
    echo "Commands: copy, paste, append" >&2
    exit 1
}

[ $# -eq 1 ] || usage

case "$1" in
    copy)
        wl-copy <"$CLIPBOARD_FILE"
        ;;
    paste)
        wl-paste >"$CLIPBOARD_FILE"
        ;;
    append)
        wl-paste >>"$CLIPBOARD_FILE"
        printf '\n' >>"$CLIPBOARD_FILE"
        ;;
    *)
        usage
        ;;
esac