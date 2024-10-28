#!/usr/bin/env bash
#
# Distrubution agnostic script that installs configuration settings
# managed by chezmoi and custom GNOME settings.
#

# If it doesn't already exist create local chezmoi repo, pull from Github, then update dotfiles.
if [ ! -d "$HOME/.local/share/chezmoi" ]; then
    echo installing dotfiles...
    chezmoi init --apply https://github.com/srackham/dotfiles.git
fi

if command -v dconf >/dev/null 2>&1; then
    echo installing GNOME configuration settings...

    # Load GNOME desktop window manager custom key bindings. Created with:
    #
    #   dconf dump /org/gnome/desktop/wm/keybindings/ > gnome-custom-key-bindings.dconf
    #
    dconf load /org/gnome/desktop/wm/keybindings/ < gnome-custom-key-bindings.dconf

    # Load GNOME desktop media custom key bindings. Created with:
    #
    #   dconf dump /org/gnome/settings-daemon/plugins/media-keys/ > gnome-custom-media-keys.dconf
    #
    dconf load /org/gnome/settings-daemon/plugins/media-keys/ < gnome-custom-media-keys.dconf

    # Load GNOME Terminal profiles. Created with:
    #
    #   dconf dump /org/gnome/terminal/legacy/profiles:/ > gnome-terminal-profiles.dconf
    #
    dconf load /org/gnome/terminal/legacy/profiles:/ < gnome-terminal-profiles.dconf
fi
