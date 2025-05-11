#!/usr/bin/env bash
set -e

#
# Single-user homa-manager install
#

# Install the Nix package manager
sh <(curl -L https://nixos.org/nix/install) --no-daemon     # See https://nixos.org/download/

# Install nixpkgs (Nix ecosystem) and home-manager channels then install them along with home-manager.
# These are for version 24.11 (the stable channel) and both must be the same version.
nix-channel --add https://nixos.org/channels/nixpkgs-24.11-darwin nixpkgs
nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

# Copy my home.nix from Github
curl -o ~/.config/home-manager/home.nix https://raw.githubusercontent.com/srackham/dotfiles/main/dot_config/home-manager/home.nix


# Install the packages
home-manager switch

# Install my dotfiles with Chezmoi
# Create local repo, pull from Github, then update dotfiles with a single command
# Clones repo to `$HOME/.local/share/chezmoi`
# NOTE: If there is an existing Chezmoi repo delete or move it first
chezmoi init https://github.com/srackham/dotfiles.git

# Get the non-repo secrets file
mkdir ~/.local/share/chezmoi/.chezmoidata/
scp srackham@nixos1:/home/srackham/.local/share/chezmoi/.chezmoidata/secrets.toml ~/.local/share/chezmoi/.chezmoidata/

# Install the dotfiles
chezmoi apply

# Logout and log back in.

# Start nvim and wait for all the plugin updates to complete
# NOTE: Wait for all the Neovim plugins to install, don't quit do anything until complete (may take a couple of minutes), just keep an eye on the Neovim status messages line.
