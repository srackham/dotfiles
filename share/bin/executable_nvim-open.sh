#!/usr/bin/env bash
#
# Open a file in the tmux Neovim editor pane (pane 1 of the current window).
# Mostly used by fzf scripts to open the first selected file.
#
if [ $# -eq 0 ]; then
    echo "Usage: $0 <file-name>"
    exit 1
fi
file_path=$(realpath "$1")
tmux send-keys -t:.1 Escape && \
tmux send-keys -t:.1 ":edit $file_path" C-m && \
tmux select-pane -Z -t:.1

