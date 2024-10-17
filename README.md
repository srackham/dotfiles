# Chezmoi Managed Dotfiles

17-Sep-2024

My cross-distribution Linux dotfiles managed by [chezmoi](https://www.chezmoi.io/).

## Applications
Here's the list of application configurations managed by Chezmoi:

- bash
- GNOME desktop shortcuts (installed manually)
- Helix
- lazygit
- neovim
- nushell
- recoll
- Remmina
- tmux
- Vim
- Vimium (installed manually)
- zsh

## Manually Exported/Imported Configurations
The `exported` directory contains files that are managed manually:

- _Browser Bookmarks_: Exported from Brave browser.

- _GNOME Desktop key bindings_: Use the dconf load command to restore custom GNOME key binding from the `*.dconf` dump file. See the _Configuring GNOME Settings_ section in `~/doc/distros/nixos-notes.md` for details.


- _Vimium Options_: The Vimium browser extension options are in the `vimium-options.json` file, manually restore them with the restore command on the Vimium extension Options page.
