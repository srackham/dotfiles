#!/usr/bin/env bash

set -e
set -o pipefail

SRC_DRIVE_LABEL=backups
DST_DRIVE_LABEL=archives

src="/run/media/srackham/$SRC_DRIVE_LABEL"
dst="/run/media/srackham/$DST_DRIVE_LABEL"

echo "Archiving data and VMs from '$src' to '$dst'"

# rclone used instead of rsync to allow the destination archive to be an NTFS USB drive.
rclone sync --progress --links --modify-window=5s --exclude "/lost+found" "$src" "$dst"
rclone check --progress --links --modify-window=5s --exclude "/lost+found" "$src" "$dst"
