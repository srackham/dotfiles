#!/usr/bin/env bash

set -e
set -o pipefail

DRIVE_LABEL=backups

src="$HOME"
dst="/run/media/srackham/$DRIVE_LABEL"

echo "Backing up data and VMs from '$src' to '$dst'"

rclone sync --progress --links --modify-window=5s "$src/VirtualBox VMs" "$dst/VirtualBox VMs"
rclone sync --progress --links --modify-window=5s "$src/.config/VirtualBox" "$dst/.config/VirtualBox"
rclone sync --progress --links --modify-window=5s --include "/share/**" --include "/public/**" "$src" "$dst"

rclone check --progress --links --modify-window=5s "$src/VirtualBox VMs" "$dst/VirtualBox VMs"
rclone check --progress --links --modify-window=5s "$src/.config/VirtualBox" "$dst/.config/VirtualBox"
rclone check --progress --links --modify-window=5s --include "/share/**" --include "/public/**" "$src" "$dst"
