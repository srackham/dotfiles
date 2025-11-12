#!/usr/bin/env bash

# This script is run as root from the OMV server, it extracts backup
# activity from system log files relating to the various cron jobs.

SERVER="nuc1"
DATE="date +%Y-%m-%d-%a\ %H:%M:%S"

if [ "$(hostname)" != "nuc1" ]; then
    echo "$(hostname): $(eval $DATE): FAILED $0: must be executed on host $SERVER" >&2
    exit 1
fi

logfiles="/var/log/messages.1 /var/log/messages"

echo RSNAPSHOT BACKUPS
grep 'rsnapshot.*completed' $logfiles | tail -8
echo

echo BACKUP RSNAPSHOT ARCHIVE TO USB DRIVE
grep 'to removable drive completed successfully' $logfiles | tail -4
echo

echo BACKUP ALL DATA TO nuc2
grep 'to nuc2 completed' $logfiles | tail -4
echo

echo BACKUP ALL DATA TO nuc3
grep 'to nuc3 completed' $logfiles | tail -4
echo

# echo BACKUP ALL DATA TO rpi2
# grep 'to rpi2 completed' $logfiles | tail -4
# echo

echo dell7090 JOBS
grep 'Finished\|FAILED' /files/users/srackham/bin/recollindex.log | tail -1
grep 'Finished\|FAILED' /files/users/srackham/bin/sync-local.log | tail -1
echo

# echo gnome-2204 JOBS
# grep ': gnome-2204:' $logfiles | tail -6
# echo
#
# echo manjaro JOBS
# grep ': manjaro:' $logfiles | tail -6
# echo

echo GOOGLE DRIVE BACKUPS
tail -8 /var/log/rclone-backup.log
echo
