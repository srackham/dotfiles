#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status or in a pipeline
set -e
set -o pipefail

# Import shell aliases
shopt -s expand_aliases
# shellcheck source=/dev/null # Suppress spurious "No such file or directory" warning
source "$HOME/.bashrc"

# --- Task functions ---

apply-dotfiles() {
    chezmoi apply
}

nvim-plugins() {
    nvim --headless -c "Lazy! sync" -c "qa"
}

build-nixos() {
    mknixos switch
}

update-nixos() {
    upgrade-nixos
}

list-services() {
    systemctl list-units --type=service --state=active
}

view-journal() {
    journalctl -xe
}

install-other() {
    npm i -g opencode-ai@latest
    npm install -g @google/gemini-cli
    go install github.com/charmbracelet/crush@latest
}

gnome-settings() {
    local chezmoi_repo_dir="$HOME/share/projects/chezmoi"
    dconf load /org/gnome/desktop/wm/keybindings/ <"$chezmoi_repo_dir/exported/wm-keybindings.dconf"
    dconf load /org/gnome/settings-daemon/plugins/media-keys/ <"$chezmoi_repo_dir/exported/media-keys-keybindings.dconf"
    dconf load /org/gnome/shell/keybindings/ <"$chezmoi_repo_dir/exported/shell-keybindings.dconf"
}

# --- fzf menu ---

# Define admin task menu items
tasks=(
    "Apply Chezmoi dot files::apply-dotfiles"
    'Install Lazyvim plugins::nvim-plugins'
    "Install other applications::install-other"
    "Load GNOME keyboard shortcuts::gnome-settings"
    "Build and activate NixOS::build-nixos"
    "Update and optimise NixOS::update-nixos"
    ""
    "Show active services::list-services"
    "View system logs::view-journal"
)

# Extract descriptions for menu display
descriptions=("${tasks[@]%%::*}")

# header=$'\nSelect tasks (Tab to select, Enter to confirm):\n'
header=$'\nSelect tasks (Up/Down: CtrlP/Ctrl+N, Select/Deselect: Tab/Shift+Tab, Select All: Alt+A, Accept: Enter, Abort: Ctrl+C, Esc)\n'
selected_descriptions=$(printf '%s\n' "${descriptions[@]}" | fzf --multi --no-sort --tac --bind 'alt-a:toggle-all' --info=hidden --header="$header")

# Filter out blank lines
selected_descriptions=$(echo "$selected_descriptions" | grep -v '^$')

# Check for no selection
if [ -z "$selected_descriptions" ]; then
    echo "No tasks selected. Exiting."
    exit 0
fi

# Show selections and prompt to proceed
selected_descriptions="$(tac <<<"$selected_descriptions")" # Fix fzf reversed order
echo "You selected:"
echo
echo "$selected_descriptions"
echo
read -rp "Execute these tasks? [Y/n]: " confirm
if [[ "$confirm" =~ ^[Nn]$ ]]; then
    echo "Operation cancelled."
    exit 1
fi
# Execute selected tasks in original order
echo
for task in "${tasks[@]}"; do
    desc="${task%%::*}"
    cmd="${task#*::}"
    if [ -n "$cmd" ]; then
        if printf '%s\n' "$selected_descriptions" | grep -Fxq "$desc"; then
            echo "Executing: $desc ($cmd)"
            # eval "$cmd"
            echo "$cmd"
            echo
        fi
    fi
done
