#!/usr/bin/env bash

# Resets the Obsidian notes vault to a single Git baseline commit.
# This allows Git to track the changes made during my current editing session without the
# unnecessary overhead of maintaining a full commit history.

# Exit immediately if a command exits with a non-zero status or in a pipeline
set -e
set -o pipefail

cd ~/share/notes
if [[ -d .git ]]; then
    git add -A
    git commit --amend -qm "session baseline"
else
    git init -q
    git add -A
    git commit -qm "session baseline"
fi
git add -N ':(glob)**/*.md' # Make new files visible in git diff
echo "Session baseline reset"
