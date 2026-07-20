#!/usr/bin/env bash

set -e
set -o pipefail

vms="/run/media/srackham/vms"
backups="/run/media/srackham/backups"

echo "Backing up data from $HOME and VMs from '$vms' to '$backups'"

# rsync is preferable to rclone for strict replication of permissions and ownership.
# --inplace overwrites destination files directly instead of creating a temporary file and renaming which benefits SSD drives.
sudo rsync -av --delete --inplace \
    --include "/.config/***" \
    --include "/share/***" \
    --include "/public/***" \
    --exclude "/*" \
    "$HOME/" "$backups/home"

sudo rsync -av --delete --inplace --exclude='/lost+found' --exclude='/*.OLD' "$vms/" "$backups/vms"
