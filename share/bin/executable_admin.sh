#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status or in a pipeline
set -e
set -o pipefail

# Import shell aliases
shopt -s expand_aliases
# shellcheck source=/dev/null # Suppress spurious "No such file or directory" warning
source "$HOME/.bashrc"

# --- Task functions ---

do_other() {
    npm i -g opencode-ai@latest
    npm install -g @google/gemini-cli
    go install github.com/charmbracelet/crush@latest
}

do_gnome() {
    local chezmoi_repo_dir="$HOME/share/projects/chezmoi"
    dconf load /org/gnome/desktop/wm/keybindings/ <"$chezmoi_repo_dir/exported/wm-keybindings.dconf"
    dconf load /org/gnome/settings-daemon/plugins/media-keys/ <"$chezmoi_repo_dir/exported/media-keys-keybindings.dconf"
    dconf load /org/gnome/shell/keybindings/ <"$chezmoi_repo_dir/exported/shell-keybindings.dconf"
}

# --- fzf menu ---

# Define admin task menu items
tasks=(
    "Apply Chezmoi dot files::chezmoi apply"
    'Install Lazyvim plugins::nvim --headless -c "Lazy! sync" -c "qa"'
    "Install other applications::do_other"
    "Load GNOME keyboard shortcuts::do_gnome"
    "Build and activate NixOS::nixos switch"
    "Update and optimise NixOS::upgrade-nixos"
    ""
    "List block device info::lsblk -f"
    "Restart networking::sudo systemctl restart networking"
    "Show active services::systemctl list-units --type=service --state=active"
    "View system logs::journalctl -xe"
)

# Extract descriptions for menu display
descriptions=("${tasks[@]%%::*}")

# header=$'\nSelect tasks (Tab to select, Enter to confirm):\n'
header=$'\nSelect tasks (Up/Down: CtrlP/Ctrl+N, Select/Deselect: Tab/Shift+Tab, Select All: Alt+A, Accept: Enter, Abort: Ctrl+C, Esc)\n'
selected_descriptions=$(printf '%s\n' "${descriptions[@]}" | fzf --multi --no-sort --tac --bind 'alt-a:toggle-all' --info=hidden --header="$header")

# Check for no selection
if [ -z "$selected_descriptions" ]; then
    echo "No tasks selected. Exiting."
    exit 0
fi

# Show selections and prompt to proceed
selected_descriptions="$(tac <<<"$selected_descriptions")" # Fix fzf reversed order
echo "You selected:"
echo "$selected_descriptions"
echo
read -rp "Execute these tasks? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi

# Execute selected tasks in original order
echo
for task in "${tasks[@]}"; do
    desc="${task%%::*}"
    cmd="${task#*::}"
    if printf '%s\n' "$selected_descriptions" | grep -Fxq "$desc"; then
        echo "Executing: $desc"
        # eval "$cmd"
        echo "$cmd"
        echo
    fi
done
