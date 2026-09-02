#!/usr/bin/env bash

# Usage:
#     share-clipboard.sh [OPTIONS] COMMAND
#
# Options:
#     -p, --polling-interval INTERVAL   Polling interval in milliseconds (default: 5000)
#     -v, --verbose                     Print clipboard updates to stdout
#
# Description:
#     Reads, writes and appends the $HOME/vboxsf/clipboard.txt clipboard
#     file from and to the system clipboard (Wayland only). Only plain
#     text clipboard content is ever read; anything else (images, files,
#     rich text with no plain-text fallback, etc.) is ignored.
#
# Commands:
#     read        Reads the text from the clipboard file to the system clipboard
#     write       Writes the text from the system clipboard to the clipboard file
#     append      Appends the text starting on a new line from the system
#                 clipboard to the clipboard file
#     cat         Reads the text from the clipboard file to the system clipboard
#                 and writes it to stdout
#     watch       Continuously monitors the clipboard file and system clipboard,
#                 synchronising changes at the polling interval

set -e

CLIP_FILE="$HOME/vboxsf/clipboard.txt"
POLL_INTERVAL=5000

if ! command -v wl-copy >/dev/null 2>&1 || ! command -v wl-paste >/dev/null 2>&1; then
    echo "Error: wl-clipboard (wl-copy/wl-paste) is not installed" >&2
    exit 1
fi

COPY_CMD="wl-copy"
PASTE_CMD="wl-paste -n"

# True if the system clipboard currently offers a plain-text MIME type.
# wl-paste without --type will happily dump the raw bytes of whatever's
# offered (e.g. an image) if no text is present, so anything that reads
# from the clipboard must check this first and skip/ignore otherwise.
clipboard_has_text() {
    local types
    types=$(wl-paste --list-types 2>/dev/null) || return 1
    printf '%s\n' "$types" | grep -qiE '^(text/plain(;.*)?|TEXT|STRING|UTF8_STRING)$'
}

usage() {
    echo "Usage: $(basename "$0") [OPTIONS] COMMAND" >&2
    echo "Options:" >&2
    echo "    -p, --polling-interval INTERVAL   Polling interval in milliseconds (default: 5000)" >&2
    echo "    -v, --verbose                     Print clipboard updates to stdout" >&2
    echo "Commands: read, write, append, cat, watch" >&2
    exit 1
}

VERBOSE=0
command=
while [ $# -gt 0 ]; do
    case "$1" in
    -p | --polling-interval)
        if [ $# -lt 2 ] || [ -z "$2" ]; then
            usage
        fi
        POLL_INTERVAL=$2
        shift
        ;;
    -p=* | --polling-interval=*)
        POLL_INTERVAL="${1#*=}"
        ;;
    -v | --verbose)
        VERBOSE=1
        ;;
    read | write | append | cat | watch)
        command=$1
        ;;
    *)
        usage
        ;;
    esac
    shift
done

touch "$CLIP_FILE"

case "$command" in
read)
    $COPY_CMD <"$CLIP_FILE"
    if [ "$VERBOSE" -eq 1 ]; then
        cat "$CLIP_FILE"
    fi
    ;;
write)
    if clipboard_has_text; then
        $PASTE_CMD 2>/dev/null >"$CLIP_FILE" || : >"$CLIP_FILE"
        if [ "$VERBOSE" -eq 1 ]; then
            cat "$CLIP_FILE"
        fi
    else
        echo "Clipboard does not contain text; ignoring." >&2
    fi
    ;;
append)
    if clipboard_has_text; then
        clip_text=$($PASTE_CMD 2>/dev/null || echo "")
        printf '%s\n' "$clip_text" >>"$CLIP_FILE"
        if [ "$VERBOSE" -eq 1 ]; then
            printf '%s\n' "$clip_text"
        fi
    else
        echo "Clipboard does not contain text; ignoring." >&2
    fi
    ;;
cat)
    $COPY_CMD <"$CLIP_FILE"
    cat "$CLIP_FILE"
    ;;
watch)
    poll_seconds=$(awk -v ms="$POLL_INTERVAL" 'BEGIN { print ms / 1000 }')

    # Returns clipboard text, or "" if the clipboard holds no plain text
    # (e.g. an image) - callers must pair this with clipboard_has_text
    # when they need to distinguish "no text present" from "text present
    # and it happens to be empty".
    read_clip() { wl-paste -n 2>/dev/null || printf ''; }
    read_file() { cat "$CLIP_FILE" 2>/dev/null || printf ''; }
    write_clip() { printf '%s' "$1" | wl-copy; }
    write_file() { printf '%s' "$1" >"$CLIP_FILE"; }
    consume_file() { : >"$CLIP_FILE"; }
    log() {
        if [ "$VERBOSE" -eq 1 ]; then
            echo "▶ $(date "+%Y-%m-%d %H:%M:%S"): $1 ◀"
            printf '%s\n' "$2"
        fi
    }
    warn() { echo "Warning: $1 - will retry next poll" >&2; }

    # Seed baseline state on startup:
    #  - known_clip = whatever is already on the clipboard right now, so a
    #    pre-existing clipboard value is NOT treated as a brand new change
    #    (this is what caused the spurious export/import on guest startup).
    #    If the clipboard currently holds non-text content, treat that as
    #    "nothing" rather than seeding with garbage.
    #  - known_file is left blank so that any genuinely unconsumed content
    #    already sitting in the shared file *is* still picked up and
    #    imported on the first iteration, instead of being silently
    #    discarded.
    if clipboard_has_text; then
        known_clip=$(read_clip)
    else
        known_clip=""
    fi
    known_file=""

    while true; do
        file_now=$(read_file)

        # Only ever look at the clipboard's *text* content. If it currently
        # holds something else (an image, a copied file, etc.) that's not
        # a text change as far as this script is concerned - fall back to
        # known_clip so the comparison below sees no change and nothing
        # gets exported.
        if clipboard_has_text; then
            clip_now=$(read_clip)
        else
            clip_now="$known_clip"
        fi

        if [ "$file_now" != "$known_file" ]; then
            if [ -n "$file_now" ]; then
                # Genuine new content from the peer -> import it.
                # Guard the writes: under `set -e` a transient failure here
                # (wl-copy briefly unavailable, vboxsf hiccup) would
                # otherwise kill the whole watcher instead of just retrying
                # on the next poll.
                if write_clip "$file_now"; then
                    known_clip="$file_now"
                    log "CLIPBOARD IMPORTED" "$file_now"
                    if consume_file; then
                        known_file=""
                    else
                        warn "failed to truncate clipboard file after import"
                        # Leave known_file as-is so the truncation is retried.
                    fi
                else
                    warn "failed to write to system clipboard"
                    # Leave known_file/known_clip untouched so the import
                    # is retried next poll instead of being lost.
                fi
            else
                # File went from non-empty to empty: the peer (or we
                # ourselves) consumed a previous export. This is just an
                # acknowledgement, not new data - do NOT re-import.
                known_file=""
            fi
        elif [ "$clip_now" != "$known_clip" ]; then
            if write_file "$clip_now"; then
                known_file="$clip_now"
                known_clip="$clip_now"
                log "CLIPBOARD EXPORTED" "$clip_now"
            else
                warn "failed to write clipboard file"
                # Leave known_clip untouched so the export is retried.
            fi
        fi

        sleep "$poll_seconds"
    done
    ;;
*)
    usage
    ;;
esac
