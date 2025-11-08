#!/usr/bin/env bash

set -e
set -o pipefail

DRIVE_LABEL=backups

src="/run/media/srackham/$DRIVE_LABEL/VirtualBox VMs"
dst="$HOME/VirtualBox VMs"

echo "Restoring VirtualBox VMs from '$src' to '$dst'"
read -r -p "Do you want to continue? [y/N] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi

rclone sync --dry-run --progress --modify-window=5s "$src" "$dst"
