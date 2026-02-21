#!/usr/bin/env bash
#
# Open a file in the tmux Neovim editor pane (pane 1 of the current window).
# If the file is not plain text, open it in the default web browser.
# Mostly used by fzf scripts to open the first selected file.
#

if [ $# -eq 0 ]; then
    echo "Usage: $(basename "$0") <file-name>"
    exit 1
fi

file_path=$(realpath "$1")

# Check the MIME type of the file
mime_type=$(file --mime-type -b "$file_path")

if [[ "$mime_type" != text/* ]]; then
    # Not a plain text file, open in web browser
    if command -v xdg-open >/dev/null 2>&1; then
        xdg-open "$file_path"
    else
        echo "No suitable command found to open the file in a browser."
        exit 1
    fi
else
    # # Plain text file, open in tmux Neovim pane 1
    # tmux send-keys -t:.1 Escape &&
    # 	tmux send-keys -t:.1 ":edit $file_path" C-m &&
    # 	tmux select-pane -Z -t:.1

    # Plain text file, open in the first pane in the current WezTerm tab (assumed to be running Neovim)
    PANE_ID=$(
        wezterm cli list --format json |
            jq -r --arg cur "$WEZTERM_PANE" '
      (map(select(.pane_id == ($cur|tonumber)))[0].tab_id) as $tab
      | map(select(.tab_id == $tab))
      | sort_by(.pane_index)
      | .[0].pane_id
    '
    )
    wezterm cli send-text --pane-id "$PANE_ID" --no-paste ":edit $file_path"$'\r'
fi
