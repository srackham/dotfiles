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

set -e

CLIPBOARD_FILE="$HOME/vboxsf/clipboard.txt"

usage() {
    echo "Usage: $(basename "$0") COMMAND" >&2
    echo "Commands: read, write, append, cat" >&2
    exit 1
}

[ $# -eq 1 ] || usage

case "$1" in
    read)
        wl-copy <"$CLIPBOARD_FILE"
        ;;
    write)
        wl-paste >"$CLIPBOARD_FILE"
        ;;
    append)
        wl-paste >>"$CLIPBOARD_FILE"
        printf '\n' >>"$CLIPBOARD_FILE"
        ;;
    cat)
        wl-copy <"$CLIPBOARD_FILE"
        cat "$CLIPBOARD_FILE"
        ;;
    *)
        usage
        ;;
esac