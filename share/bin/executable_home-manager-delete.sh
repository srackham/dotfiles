#!/usr/bin/env bash
set -e

#
# Uninstall single-user homa-manager
#

rm -rf ~/.cache/nix
rm -rf ~/.local/state/nix
rm -rf ~/.local/state/home-manager
rm -rf ~/.nix-*
