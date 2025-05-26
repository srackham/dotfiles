#!/usr/bin/env bash

#
# Mirror top-level projects in ~/local/projects directories to ~/share/projects
#

# Source and destination directories
SRC="$HOME/local/projects"
DEST="$HOME/share/projects"

# Get a list of top-level directories in the source
top_level_dirs=$(find "$SRC" -maxdepth 1 -type d -printf '%P\n' | grep -v '^$')

# Sync each top-level directory individually
for dir in $top_level_dirs; do
    echo rsync -avz --delete "$SRC/$dir/" "$DEST/$dir/"
    rsync -avz --delete "$SRC/$dir/" "$DEST/$dir/"
done
