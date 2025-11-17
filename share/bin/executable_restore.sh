#!/usr/bin/env bash

set -e
set -o pipefail

read -r -p "Choose a restore option: [L]ocal drive or [R]emovable drive? [L/R/N] " -n 1 -r
echo
REPLY_LOWER=$(echo "$REPLY" | tr '[:upper:]' '[:lower:]')
if [[ $REPLY_LOWER == "l" ]]; then
    SRC_DRIVE_LABEL=data
elif [[ $REPLY_LOWER == "r" ]]; then
    SRC_DRIVE_LABEL=backups
else
    # Handles "N" or any other input
    echo "Operation cancelled."
    exit 1
fi

src_mount_dir="/run/media/$USER/$SRC_DRIVE_LABEL"
src="$src_mount_dir/backups/VirtualBox VMs"
src_device="/dev/disk/by-label/$SRC_DRIVE_LABEL"

dst="$HOME/VirtualBox VMs"

echo
echo "Restoring VirtualBox VMs from '$src' to '$dst'"
echo
read -r -p "Do you want to continue? [y/N] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Operation cancelled."
    exit 1
fi

# Cleanup function to unmount the drive
cleanup() {
    if [ "$SRC_DRIVE_LABEL" == "backups" ]; then
        sleep 1
        udisksctl unmount -b "$src_device" || echo "Failed to unmount $src_device"
    fi
}

# Trap SIGINT (Ctrl+C)
trap cleanup INT

if [ "$SRC_DRIVE_LABEL" == "backups" ]; then
    mount_dir=$(findmnt -nr -o TARGET "$src_device" || :)
    if [ -n "$mount_dir" ]; then
        if [ "$mount_dir" != "$src_mount_dir" ]; then
            echo "Device $src_device is already mounted at $mount_dir"
            exit 1
        fi
    else
        udisksctl mount -b "$src_device"
    fi
fi

rsync -av --delete --inplace "$src/" "$dst"

cleanup
