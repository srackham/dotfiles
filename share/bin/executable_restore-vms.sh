#!/usr/bin/env bash

# Restore VirtualBox VMs from USB backups drive to NixOS host.

FROM_DRIVE=data

# time rsync -av "/run/media/srackham/$FROM_DRIVE/VirtualBox VMs/" "$HOME/VirtualBox VMs/"
rclone sync --progress --modify-window=5s "/run/media/srackham/$FROM_DRIVE/VirtualBox VMs" "$HOME/VirtualBox VMs"
