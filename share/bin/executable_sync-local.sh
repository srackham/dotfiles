#!/usr/bin/env bash

#
# Mirror top-level projects in ~/local/projects directories to ~/share/projects
#

BASE_NAME="${0##*/}"         # Script name
BASE_NOEXT="${BASE_NAME%.*}" # Script name without extension
LOGFILE="$HOME/bin/$BASE_NOEXT.log"
DATE="date +%Y-%m-%d-%a\ %H:%M:%S"

SRC="$HOME/local/projects"
DEST="$HOME/share/projects"

echo $(hostname): $(eval $DATE): Starting $0 | tee --append "$LOGFILE"

# Get a list of top-level directories in the source
top_level_dirs=$(find "$SRC" -maxdepth 1 -type d -printf '%P\n' | grep -v '^$')

# Sync each top-level directory individually
for dir in $top_level_dirs; do
	cmd="rsync -avz --delete "$SRC/$dir/" "$DEST/$dir/""
	echo $cmd | tee --append "$LOGFILE"
	rsync -avz --delete "$SRC/$dir/" "$DEST/$dir/"
done
exit_code=$?
if [ $exit_code -eq 0 ]; then
	echo $(hostname): $(eval $DATE): Finished $0 | tee --append "$LOGFILE"
else
	{ echo "$(hostname): $(eval $DATE): FAILED $0: exit code: $exit_code"; } 1>&2 | tee --append "$LOGFILE"
fi
exit $exit_code
