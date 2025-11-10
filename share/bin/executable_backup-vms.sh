#!/usr/bin/env bash

set -e
set -o pipefail

DRIVE_LABEL=backups

src="$HOME"
dst="/run/media/srackham/$DRIVE_LABEL"

echo "Backing up data and VMs from '$src' to '$dst'"

# rclone sync --progress --links --modify-window=5s "$src/VirtualBox VMs" "$dst/VirtualBox VMs"
# rclone sync --progress --links --modify-window=5s "$src/.config/VirtualBox" "$dst/.config/VirtualBox"
# rclone sync --progress --links --modify-window=5s --include "/share/**" --include "/public/**" "$src" "$dst"

# rsync is preferable to rclone for strict replication of permissions and ownership.
# --inplace overwrites destination files directly instead of creating a temporary file and renaming whic benefits SSD drives.
rsync -av --delete --inplace "$src/VirtualBox VMs/" "$dst/VirtualBox VMs"
rsync -av --delete --inplace "$src/.config/VirtualBox/" "$dst/.config/VirtualBox"
rsync -av --delete --inplace --include "/share/*** " --include "/public/*** " --exclude "/*" "$src/" "$dst"

rclone check --progress --links --modify-window=5s "$src/VirtualBox VMs" "$dst/VirtualBox VMs"
rclone check --progress --links --modify-window=5s "$src/.config/VirtualBox" "$dst/.config/VirtualBox"
rclone check --progress --links --modify-window=5s --include "/share/**" --include "/public/**" "$src" "$dst"
