#!/usr/bin/env bash

set -e
set -o pipefail

DRIVE_LABEL=backups

src="$HOME"
dst="/run/media/srackham/$DRIVE_LABEL"

echo "Backing up data and VMs from '$src' to '$dst'"

rclone sync --progress --modify-window=5s "$src/VirtualBox VMs" "$dst/VirtualBox VMs"
rclone sync --progress --modify-window=5s "$src/.config/VirtualBox" "$dst/.config/VirtualBox"
rclone sync --progress --modify-window=5s --include "/share/methods/prs/**" --include "/public/prs2k_methods/**" --include "/public/licmgr/**" "$src" "$dst"

rclone check --progress --modify-window=5s "$src/VirtualBox VMs" "$dst/VirtualBox VMs"
rclone check --progress --modify-window=5s "$src/.config/VirtualBox" "$dst/.config/VirtualBox"
rclone check --progress --modify-window=5s --include "/share/methods/prs/**" --include "/public/prs2k_methods/**" --include "/public/licmgr/**" "$src" "$dst"
