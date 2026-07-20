#!/usr/bin/env bash

set -e
set -o pipefail

SRC_DRIVE_LABEL=archives

src_mount_dir="/run/media/$USER/$SRC_DRIVE_LABEL"
src="$src_mount_dir/vms"
src_device="/dev/disk/by-label/$SRC_DRIVE_LABEL"

dst="$HOME/VirtualBox VMs"

echo
echo "Restoring VirtualBox VMs from '$src' to '$dst'"
echo
read -rp "Do you want to continue? [y/N] " confirm
echo
if [[ ! $confirm =~ ^[Yy]$ ]]; then
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
