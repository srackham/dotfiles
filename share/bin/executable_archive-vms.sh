#!/usr/bin/env bash

set -e
set -o pipefail

SRC_DRIVE_LABEL=backups
DST_DRIVE_LABEL=archives

src="/run/media/srackham/$SRC_DRIVE_LABEL"
dst="/run/media/srackham/$DST_DRIVE_LABEL"

echo "Archiving data and VMs from '$src' to '$dst'"

rclone sync --progress --links --modify-window=5s "$src" "$dst"
rclone check --progress --links --modify-window=5s "$src" "$dst"
