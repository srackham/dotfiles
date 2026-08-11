#!/usr/bin/env bash

# This script is run as root from the OMV server, it extracts backup
# activity from system log files relating to the various cron jobs.

SERVER="nuc2"
DATE="date +%Y-%m-%d-%a\ %H:%M:%S"

if [ "$(hostname)" != "nuc2" ]; then
    echo "$(hostname): $(eval $DATE): FAILED $0: must be executed on host $SERVER" >&2
    exit 1
fi

journal_log="journalctl -t root --no-pager"

echo RSNAPSHOT BACKUPS
$journal_log | grep 'rsnapshot.*completed' | tail -8
echo

echo BACKUP RSNAPSHOT ARCHIVE TO USB DRIVE
$journal_log | grep 'to removable drive completed successfully' | tail -4
echo

echo BACKUP ALL DATA TO nuc2
$journal_log | grep 'to nuc2 completed' | tail -4
echo

echo BACKUP ALL DATA TO nuc3
$journal_log | grep 'to nuc3 completed' | tail -4
echo

# echo BACKUP ALL DATA TO rpi2
# $journal_log | grep 'to rpi2 completed' | tail -4
# echo

echo dell7090 JOBS
grep 'Finished\|FAILED' /files/users/srackham/bin/recollindex.log | tail -1
grep 'Finished\|FAILED' /files/users/srackham/bin/sync-local.log | tail -1
echo

# echo gnome-2204 JOBS
# $journal_log | grep ': gnome-2204:' | tail -6
# echo
#
# echo manjaro JOBS
# $journal_log | grep ': manjaro:' | tail -6
# echo

echo GOOGLE DRIVE BACKUPS
tail -8 /var/log/rclone-backup.log
echo
