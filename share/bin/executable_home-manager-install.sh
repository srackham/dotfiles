#!/usr/bin/env bash
set -e

#
# Single-user homa-manager install
#

delete_home_manager=false
delete_chezmoi=false

# Check for ~/.nix-profile directory
if [ -d "$HOME/.nix-profile" ]; then
    echo
    echo "Directory ~/.nix-profile exists: Nix home-manager appears to be installed."
    echo "If you continue the home-manager configuration will be erased."
    read -p "Do you want to continue? (y/n): " -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        delete_home_manager=true
    else
        exit 1
    fi
fi

# Check for ~/.local/share/chezmoi directory
if [ -d "$HOME/.local/share/chezmoi" ]; then
    echo
    echo "Directory ~/.local/share/chezmoi exists: Chezmoi appears to be installed."
    echo "If you continue the Chezmoi configuration will be erased."
    read -p "Do you want to continue? (y/n): " -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        delete_chezmoi=true
    else
        exit 1
    fi
fi

# Final confirmation
if $delete_home_manager || $delete_chezmoi; then
    echo
    echo "About to permanently delete existing home-manager and Chezmoi configurations."
    read -p "Do you want to continue? (y/n): " -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi

    # Perform deletions as requested
    if $delete_home_manager; then
        rm -rf ~/.cache/nix
        rm -rf ~/.local/state/nix
        rm -rf ~/.local/state/home-manager
        rm -rf ~/.nix-*
        echo
        echo "home-manager configuration deleted."
    fi

    if $delete_chezmoi; then
        rm -rf ~/.local/share/chezmoi
        echo
        echo "Chezmoi configuration deleted."
    fi
fi

# Install the Nix package manager in single-user mode.
sh <(curl -L https://nixos.org/nix/install) --no-daemon     # See https://nixos.org/download/

source ~/.nix-profile/etc/profile.d/nix.sh  # Set up the per-user profile

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
# Create local repo, pull from Github, then update dotfiles with a single command (clones repo to `$HOME/.local/share/chezmoi`)
chezmoi init https://github.com/srackham/dotfiles.git

# Install the dotfiles
chezmoi apply

echo
echo "Install completed successfully."
echo
echo "1. Logout and log back in."
echo "2. Start nvim and wait for all the plugin updates to complete."
echo
echo "NOTE: Wait for all the Neovim plugins to install, don't quit do anything until complete (may take a couple of minutes), just keep an eye on the Neovim status messages line."
echo ""
echo "If you need the secrets, remote copy secrets.toml and reapply Chezmoi:"
echo
echo "    scp srackham@nixos1:/home/srackham/.local/share/chezmoi/.chezmoidata/secrets.toml ~/.local/share/chezmoi/.chezmoidata/"
echo "    chezmoi apply"
