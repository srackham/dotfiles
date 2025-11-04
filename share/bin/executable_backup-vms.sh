#!/usr/bin/env bash

# Backup the local copy of VirtualBox VMs to the attached USB backups drive.

FROM_DRIVE=data
TO_DRIVE=backups

rclone sync --progress --modify-window=5s "/run/media/srackham/$FROM_DRIVE/VirtualBox VMs" "/run/media/srackham/$TO_DRIVE/VirtualBox VMs"
