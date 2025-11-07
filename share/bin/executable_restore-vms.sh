#!/usr/bin/env bash

DRIVE_LABEL=backups

src="/run/media/srackham/$DRIVE_LABEL/VirtualBox VMs"
dst="$HOME/VirtualBox VMs"

echo "Restoring VirtualBox VMs from '$src' to '$dst'"

rclone sync --dry-run --progress --modify-window=5s "$src" "$dst"
