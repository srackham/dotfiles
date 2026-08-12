#!/usr/bin/env bash

# This script is run as root from the OMV server, it extracts backup
# activity from system log files relating to the various cron jobs.

SERVER="nuc2"
DATE="date +%Y-%m-%d-%a\ %H:%M:%S"
SUPER_HOME=/home/super

if [ "$(hostname)" != "nuc2" ]; then
    echo "$(hostname): $(eval "$DATE"): FAILED $0: must be executed on host $SERVER" >&2
    exit 1
fi

journal_log="journalctl -t root --no-pager"

echo RSNAPSHOT BACKUPS
$journal_log | grep 'rsnapshot.*completed' | tail -8
echo

echo BACKUP RSNAPSHOT ARCHIVE TO USB DRIVE
$journal_log | grep 'to removable drive completed successfully' | tail -4
echo

echo BACKUP ALL DATA TO nuc1
$journal_log | grep 'to nuc1 completed' | tail -4
echo

echo BACKUP ALL DATA TO nuc3
$journal_log | grep 'to nuc3 completed' | tail -4
echo

# echo BACKUP ALL DATA TO rpi2
# $journal_log | grep 'to rpi2 completed' | tail -4
# echo

echo dell7090 JOBS
grep --text -E 'Finished|FAILED' /files/users/srackham/bin/recollindex.log | tail -1
echo

echo GOOGLE DRIVE BACKUPS
tail -8 $SUPER_HOME/var/rclone-backup.log
echo
