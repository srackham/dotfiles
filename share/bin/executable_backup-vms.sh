#!/usr/bin/env bash

set -e
set -o pipefail

DRIVE_LABEL=backups

src="$HOME"
dst="/run/media/srackham/$DRIVE_LABEL"

echo "Backing up data and VMs from '$src' to '$dst'"

# rsync is preferable to rclone for strict replication of permissions and ownership.
# --inplace overwrites destination files directly instead of creating a temporary file and renaming whic benefits SSD drives.
rsync -av --delete --inplace --include "/VirtualBox VMs/***" --include "/.config/***" --include "/share/***" --include "/public/***" --exclude "/*" "$src/" "$dst"

rclone check --progress --links --modify-window=5s --include "/VirtualBox VMs/**" --include "/.config/**" --include "/share/**" --include "/public/**" "$src" "$dst"
