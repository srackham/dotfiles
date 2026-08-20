#!/usr/bin/env bash

# OMV Scheduled Tasks Installer
# Installs scheduled jobs extracted from OMV Web UI
# Usage: sudo ./install-omv-scheduled-jobs.sh [--dry-run]

set -euo pipefail

DRY_RUN=false
if [[ "${1:-}" == "--dry-run" ]]; then
    DRY_RUN=true
    echo "[DRY RUN] No changes will be made."
fi

CRON_FILE="/etc/cron.d/omv-scheduled-jobs"
TMP_FILE="$(mktemp /tmp/omv-scheduled-jobs.XXXXXX)"

# Cleanup temp file on exit
trap 'rm -f "$TMP_FILE"' EXIT

cat >"$TMP_FILE" <<'EOF'
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# At 07:50 AM
50 7 * * * root /home/super/bin/log-summary.sh

# At 15 minutes past the hour, every 4 hours
15 */4 * * * root /usr/bin/rsnapshot hourly && logger "Hourly rsnapshot backup completed successfully"

# At 11:00 AM
0 11 * * * root /usr/bin/rsnapshot daily && logger "Daily rsnapshot backup completed successfully"

# At 10:00 AM, only on Tuesday
0 10 * * 2 root /usr/bin/rsnapshot weekly && logger "Weekly rsnapshot backup completed successfully"

# At 11:30 AM, on day 1 of the month
30 11 1 * * root /usr/bin/rsnapshot monthly && logger "Monthly rsnapshot backup completed successfully"

# At 45 minutes past the hour, every 8 hours
45 */8 * * * root mount -L omv-backups /media/omv-backups && { rsync -aH --delete /files/backups /media/omv-backups/nuc1; RC=$?; umount /media/omv-backups; exit $RC; } && logger "Backup /files/backups/ to removable drive completed successfully"

# At 36 minutes past the hour, every 4 hours (Note: Replace sshpass with SSH keys)
36 */4 * * * root sshpass -p super rsync -aH --delete -e ssh --rsync-path='sudo rsync' --exclude '/aquota.*' --filter 'protect bitcoin/' /files/ super@nuc3:/files && logger "Backup /files/ to nuc3 completed successfully"

# At 20 minutes past the hour, every 4 hours
20 */4 * * * root /home/super/bin/rclone-backup.sh --log-level INFO >/dev/null

# At 08:05 AM
5 8 * * * root /home/super/bin/cryptor valuate -save -aggregate-only -currency nzd -confdir /files/users/srackham/bin/.cryptor
EOF

if [[ "$DRY_RUN" == true ]]; then
    echo "[DRY RUN] Would install the following cron file to: $CRON_FILE"
    echo "----------------------------------------------------------------"
    cat "$TMP_FILE"
    echo "----------------------------------------------------------------"
    exit 0
fi

install -m 0644 "$TMP_FILE" "$CRON_FILE"

echo "Installed cron jobs to $CRON_FILE"
echo "Cron will pick up the new jobs automatically."
