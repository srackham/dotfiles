#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status or in a pipeline
set -e
set -o pipefail

# Import shell aliases
shopt -s expand_aliases
# shellcheck source=/dev/null # Suppress spurious "No such file or directory" warning
source "$HOME/.bashrc"

SOURCE_HOST="dell7090" # The source of the up to date configuration data

# --- Task functions ---

apply-dotfiles() {
    chezmoi apply
}

install-ollama-models() {
    models=(
        "deepseek-v3.1:671b-cloud"
        "gemini-3-flash-preview:cloud"
        "glm-5:cloud"
        "kimi-k2.5:cloud"
        "minimax-m2.5:cloud"
        "qwen3-coder:480b-cloud"
    )
    for model in "${models[@]}"; do
        echo "Installing model: $model"
        ollama pull "$model"
        echo "--"
    done
}

install-tools() {
    # Install global mise tools
    tools=(
        "age@latest"
        "fnox@latest"
    )
    for tool in "${tools[@]}"; do
        echo "Installing mise tool: $tool"
        mise use --global "$tool"
        echo "--"
    done
    # Update applications
    pi update
}

daily-backup() {
    backup.sh
}

weekly-archive() {
    archive.sh
}

restore-vms() {
    restore.sh
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
    npm install -g opencode-ai@latest
    npm install -g @google/gemini-cli
    go install github.com/charmbracelet/crush@latest
    cargo install --locked bacon
}

gnome-settings() {
    local chezmoi_repo_dir="$HOME/share/projects/chezmoi"
    dconf load /org/gnome/desktop/wm/keybindings/ <"$chezmoi_repo_dir/exported/wm-keybindings.dconf"
    dconf load /org/gnome/settings-daemon/plugins/media-keys/ <"$chezmoi_repo_dir/exported/media-keys-keybindings.dconf"
    dconf load /org/gnome/shell/keybindings/ <"$chezmoi_repo_dir/exported/shell-keybindings.dconf"
}

copy-pass() {
    if [ "$(hostname -s)" = "$SOURCE_HOST" ]; then
        printf '%s\n' "you cannot copy to self" >&2
        return 1
    fi

    rm -rf "$HOME/.password-store.BAK"
    mv "$HOME/.password-store" "$HOME/.password-store.BAK"
    scp -r "$SOURCE_HOST":.password-store/ "$HOME"
    scp -r "$SOURCE_HOST":.gnupg/keyfile "$HOME/.gnupg/keyfile"
    gpg2 --import ~/.gnupg/keyfile
}

copy-fnox() {
    if [ "$(hostname -s)" = "$SOURCE_HOST" ]; then
        printf '%s\n' "you cannot copy to self" >&2
        return 1
    fi

    scp -r "$SOURCE_HOST":.config/fnox ~/.config/
}

# --- fzf menu ---

# Define admin task menu items
tasks=(
    "Apply Chezmoi dot files::apply-dotfiles"
    'Install Lazyvim plugins::nvim-plugins'
    "Install/Update pi, mise tools::install-tools"
    "Install/Update opencode, gemini-cli, crush::install-other"
    "Install/Update Ollama models::install-ollama-models"
    "Load GNOME keyboard shortcuts::gnome-settings"
    ""
    "Copy pass password store from $SOURCE_HOST::copy-pass"
    "Copy fnox secrets store from $SOURCE_HOST::copy-fnox"
    ""
    "Daily backup::daily-backup"
    "Weekly archive::weekly-archive"
    "Restore VirtualBox VMs::restore-vms"
    ""
    "Build and activate NixOS::build-nixos"
    "Update, optimise, and rebuild NixOS::update-nixos"
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

# Generate an array of selected commands in menu order.
cmds=()
descriptions=()
for task in "${tasks[@]}"; do
    desc="${task%%::*}"
    cmd="${task#*::}"
    if [ -n "$cmd" ]; then
        if printf '%s\n' "$selected_descriptions" | grep -Fxq "$desc"; then
            cmds+=("$cmd")
            descriptions+=("$desc")
        fi
    fi
done

# Show selections and prompt to proceed
echo "You selected:"
echo
printf "%s\n" "${descriptions[@]}"
echo
read -rp "Execute these tasks? [Y/n]: " confirm
if [[ "$confirm" =~ ^[Nn]$ ]]; then
    echo "Operation cancelled."
    exit 1
fi
# Execute selected tasks in original order
echo
for cmd in "${cmds[@]}"; do
    echo "Executing: $cmd"
    eval "$cmd"
    # echo "$cmd"
    echo
done
