#!/usr/bin/env bash

set -e
set -o pipefail

read -r -p "Choose a restore option: [L]ocal drive or [R]emovable drive? [L/R/N] " -n 1 -r
echo
REPLY_LOWER=$(echo "$REPLY" | tr '[:upper:]' '[:lower:]')
if [[ $REPLY_LOWER == "l" ]]; then
    DRIVE_LABEL=data
elif [[ $REPLY_LOWER == "r" ]]; then
    DRIVE_LABEL=backups
else
    # Handles "N" or any other input
    echo "Operation cancelled."
    exit 1
fi

src="/run/media/srackham/$DRIVE_LABEL/backups/VirtualBox VMs"
dst="$HOME/VirtualBox VMs"

echo
echo "Restoring VirtualBox VMs from '$src' to '$dst'"
echo
read -r -p "Do you want to continue? [y/N] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Operation cancelled."
    exit 1
fi

rsync -av --delete --inplace "$src/" "$dst"
