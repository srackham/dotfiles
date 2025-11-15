#!/usr/bin/env bash

# Copy local backups to removable USB backups drive.

set -e
set -o pipefail

SRC_DRIVE_LABEL=data
DST_DRIVE_LABEL=backups

src="/run/media/srackham/$SRC_DRIVE_LABEL/backups"
dst="/run/media/srackham/$DST_DRIVE_LABEL/backups"

echo "Archiving data and VMs from '$src' to '$dst'"

sudo rsync -av --delete --inplace "$src/" "$dst"
rclone check --progress --links --modify-window=5s "$src" "$dst"
