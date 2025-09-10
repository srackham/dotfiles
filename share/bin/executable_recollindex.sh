#!/usr/bin/env bash
#
# Wrapper for recollindex so it generates a log file.
#

set -u # No unbound variables.
# set -e  # Exit on error.
#set -x  # Echo commands

PATH=/etc/profiles/per-user/srackham/bin:$PATH # NixOS installed user binaries

BASE_NAME="${0##*/}"         # Script name
BASE_NOEXT="${BASE_NAME%.*}" # Script name without extension
LOGFILE="$HOME/bin/$BASE_NOEXT.log"
DATE="date +%Y-%m-%d-%a\ %H:%M:%S"

export RECOLL_CONFDIR=$HOME/.config/recoll

echo $(hostname): $(eval $DATE): Starting $0 | tee -a "$LOGFILE"
(recollindex -k 2>&1) >/dev/null # Drop the noisy output.
exit_code=$?
if [ $exit_code -eq 0 ]; then
	echo $(hostname): $(eval $DATE): Finished $0 | tee -a "$LOGFILE"
else
	{ echo "$(hostname): $(eval $DATE): FAILED $0: exit code: $exit_code"; } 1>&2 | tee -a "$LOGFILE"
fi
exit $exit_code
