# Chezmoi Managed Dotfiles

17-Sep-2024

My cross-distribution Linux dotfiles managed by [chezmoi](https://www.chezmoi.io/).

### TODO:

- `,fn` - replace `$HOME` with `~`.
- `,fN` - file name only.
- `,fp` - file directory path only.
- `,bd` - If buffer is modified prompt user "Save changes? (y/N)".
- ✅`,eq` - check for running terminal window process before exiting an prompt user "Running job(s) in terminal window. Close? (y/N)".
- ✅ `O` - in outline window to go to and close outline window, equals `o<Esc>`.

## Applications

Here's the list of some of the application configurations managed by Chezmoi (run `git ls-files` for a full list):

- bash
- GNOME desktop shortcuts (installed manually)
- Helix
- lazygit
- mise
- neovim
- nushell
- recoll
- Remmina
- tmux
- Vim
- Vimium (installed manually)
- zsh

## Installing and updating on secondary machines from Github repository

My desktop machines NFS-mount my shared documents directory to `~/share`; the local chezmoi repository is in `~/share/projects/chezmoi` and it's just a matter of:

1. Copying the `~/.config/chezmoi/chezmoi.toml` file from the primary desktop PC which points chezmoi to the shared NFS location.
2. Run `chezmoi apply` to copy the chezmoi source files to their target locations.

### Machines that do not have access to the NFS projects directory mounts

See _Using chezmoi across multiple machines_ in `~/share/notes/chezmoi-notes.md`.

## Manually Exported/Imported Configurations

The `exported` directory contains files that are managed manually:

### Browser Bookmarks

Exported from Brave browser.

- Open [Bookmarks Manager](brave://bookmarks/) (C-S-o).
- Run the _Export bookmarks_ command in the ⋮ menu (vertical ellipsis menu, top right) and save bookmarks file to `~/.local/share/chezmoi/exported/bookmarks.html`.

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
dconf load /org/gnome/desktop/wm/keybindings/ < exported/wm-keybindings.dconf && \
dconf load /org/gnome/settings-daemon/plugins/media-keys/ < exported/media-keys-keybindings.dconf && \
dconf load /org/gnome/shell/keybindings/ < exported/shell-keybindings.dconf
```

### Vimium Options

The Vimium browser extension options are in the `vimium-options.json` file. Manually save and restore them using the backup and restore commands on the _Backup and Restore_ section of the Vimium extension Options page.
