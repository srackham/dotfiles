#!/usr/bin/env bash

# Restore VirtualBox VMs from USB backups drive to NixOS host.

# time rsync -av "/run/media/srackham/backups/VirtualBox VMs/" "$HOME/VirtualBox VMs/"
rclone sync --progress --modify-window=5s "/run/media/srackham/backups/VirtualBox VMs" "$HOME/VirtualBox VMs"
