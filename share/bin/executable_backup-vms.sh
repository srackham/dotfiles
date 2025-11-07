#!/usr/bin/env bash

DRIVE_LABEL=backups

src="$HOME/VirtualBox VMs"
dst="/run/media/srackham/$DRIVE_LABEL/VirtualBox VMs"

echo "Backing up data and VMs from the '$src' to '$dst'"

rclone sync --dry-run --progress --modify-window=5s "$src" "$dst"
rclone check --dry-run --progress --modify-window=5s "$src" "$dst"
