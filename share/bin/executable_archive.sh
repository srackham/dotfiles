#!/usr/bin/env bash

# Copy local backups to removable USB backups drive.

set -e
set -o pipefail

SRC_DRIVE_LABEL=data
DST_DRIVE_LABEL=backups

src_mount_dir="/run/media/$USER/$SRC_DRIVE_LABEL"
src="$src_mount_dir/backups"

dst_mount_dir="/run/media/$USER/$DST_DRIVE_LABEL"
dst="$dst_mount_dir/backups"
dst_device="/dev/disk/by-label/$DST_DRIVE_LABEL"

# Cleanup function to unmount the drive
cleanup() {
    sleep 1
    echo -e "\n\nCleaning up: unmounting $dst_device\n"
    udisksctl unmount -b "$dst_device" || echo "Failed to unmount $dst_device"
}

# Trap SIGINT (Ctrl+C), SIGTERM, and EXIT signals to run cleanup
trap cleanup EXIT

echo "Archiving data and VMs from '$src' to '$dst'"
mount_dir=$(findmnt -nr -o TARGET "$dst_device" || :)
if [ -n "$mount_dir" ]; then
    if [ "$mount_dir" != "$dst_mount_dir" ]; then
        echo "Device $dst_device is already mounted at $mount_dir"
        exit 1
    fi
else
    echo "Mounting $dst_device..."
    udisksctl mount -b "$dst_device"
fi

sudo rsync -av --delete --inplace "$src/" "$dst"
rclone check --progress --links --modify-window=5s "$src" "$dst"

udisksctl unmount -b "$dst_device"
