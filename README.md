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

###  Browser Bookmarks

Exported from Brave browser.

* Open [Bookmarks Manager](brave://bookmarks/) (C-S-o).
* Run the _Export bookmarks_ command in the ⋮ menu (vertical ellipsis menu, top right) and save bookmarks file to `~/.local/share/chezmoi/exported/bookmarks.html`.

### GNOME Desktop key bindings

- Export GNOME custom key bindings with:

  ```
  chezmoi-dump-gnome-bindings     # Alias

  dconf dump /org/gnome/desktop/wm/keybindings/ > exported/wm-keybindings.dconf && \
  dconf dump /org/gnome/settings-daemon/plugins/media-keys/ > exported/media-keys-keybindings.dconf && \
  dconf dump /org/gnome/shell/keybindings/ > exported/shell-keybindings.dconf
    ```

- Use the dconf load command to restore custom GNOME key binding from the dump file. See `./exported/post-install-config.sh` for details.

```
dconf load /org/gnome/desktop/wm/keybindings/ < exported/wm-keybindings.dconf
dconf load /org/gnome/settings-daemon/plugins/media-keys/ < exported/media-keys-keybindings.dconf
dconf load /org/gnome/shell/keybindings/ < exported/shell-keybindings.dconf
```

###  Vimium Options

The Vimium browser extension options are in the `vimium-options.json` file. Manually save and restore them using the backup and restore commands on the _Backup and Restore_ section of the Vimium extension Options page.
