#!/usr/bin/env bash

# Make a local copy of VirtualBox VMs to the permanently attached USB drive.

TO_DRIVE=data

rclone sync --progress --modify-window=5s "$HOME/VirtualBox VMs" "/run/media/srackham/$TO_DRIVE/VirtualBox VMs"
