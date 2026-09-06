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

install-ollama-models() {
    models=(
        "gemma4:e4b" # Local model
        "dolphin3"   # Local model
        "deepseek-v4-flash:cloud"
        "glm-5.2:cloud"
        "kimi-k2.6:cloud"
        "minimax-m2.7:cloud"
        "qwen3.5:cloud"
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
        MISE_GITHUB_ATTESTATIONS=false mise use --global "$tool"
        echo "--"
    done
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
    dconf load /org/gnome/shell/keybindings/ <"$chezmoi_repo_dir/exported/shell-keybindings.dconf"
    install-shared-clipboard-bindings-gnome.sh
}

configure-nfs() {
    # Install NFS client services
    sudo pacman -S --needed --noconfirm nfs-utils
    sudo systemctl enable --now rpcbind # NFS client-side RPC support
    sudo systemctl daemon-reload

    # Create mount points
    mkdir -p "$HOME/public" "$HOME/share"

    # Add mounts to /etc/fstab (skip lines that are already present)
    local fstab_entries=(
        "nuc2:/public  /home/srackham/public  nfs4  defaults,vers=4.2,_netdev,x-systemd.automount  0  0"
        "nuc2:/srackham /home/srackham/share  nfs4  defaults,vers=4.2,_netdev,x-systemd.automount  0  0"
    )
    for entry in "${fstab_entries[@]}"; do
        if ! grep -Fxq "$entry" /etc/fstab; then
            echo "$entry" | sudo tee -a /etc/fstab >/dev/null
        else
            echo "Already present in /etc/fstab: $entry"
        fi
    done

    sudo systemctl daemon-reload
}

check-recovery-mode() {
    # Recovery mode means: logged in at a real Linux virtual console (not an
    # SSH session or a GUI terminal emulator), with the system isolated to
    # multi-user.target (no display manager / graphical desktop running).
    local console
    console=$(tty 2>/dev/null || true)
    if [[ ! "$console" =~ ^/dev/tty[0-9]+$ ]]; then
        printf 'Error: not at a Linux virtual console (found: %s). See recovery mode notes.\n' "${console:-none}" >&2
        exit 1
    fi
    if systemctl is-active --quiet graphical.target; then
        printf '%s\n' "Error: system is in graphical mode. Run 'systemctl isolate multi-user.target' first." >&2
        exit 1
    fi
    if ! systemctl is-active --quiet multi-user.target; then
        printf '%s\n' "Error: system is not in multi-user.target (recovery) mode." >&2
        exit 1
    fi
}

change-uid-gid() {
    check-recovery-mode

    read -rp "Enter user name: " username

    if ! id "$username" &>/dev/null; then
        printf 'Error: user "%s" does not exist.\n' "$username" >&2
        return 1
    fi

    local uid gid groupname
    uid=$(id -u "$username")
    gid=$(id -g "$username")
    groupname=$(id -gn "$username")

    if [ "$uid" != "1000" ] || [ "$gid" != "1000" ]; then
        printf 'Error: user "%s" does not have UID 1000 and GID 1000 (found UID=%s, GID=%s).\n' "$username" "$uid" "$gid" >&2
        return 1
    fi

    echo "Changing UID and GID for user '$username' (group '$groupname') from 1000 to 1001..."
    sudo usermod -u 1001 "$username"
    sudo groupmod -g 1001 "$groupname"
    sudo find / -xdev -uid 1000 -exec chown 1001 {} +
    sudo find / -xdev -gid 1000 -exec chgrp 1001 {} +

    echo "Done. New ID:"
    id "$username"
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
    "Apply Chezmoi dot files::chezmoi apply"
    'Install Lazyvim plugins::nvim --headless -c "Lazy! sync" -c "qa"'
    "Install/Update mise tools::install-tools"
    "Install/Update opencode, gemini-cli, crush::install-other"
    "Install/Update Ollama models::install-ollama-models"
    "Load GNOME keyboard shortcuts::gnome-settings"
    ""
    "Omarchy — Configure NFS::configure-nfs"
    "Omarchy: Change user UID and GID from 1000 to 1001::change-uid-gid"
    ""
    "Copy pass password store from $SOURCE_HOST::copy-pass"
    "Copy fnox secrets store from $SOURCE_HOST::copy-fnox"
    ""
    "Daily backup::backup.sh"
    "Weekly archive::archive.sh"
    "Restore VirtualBox VMs::restore.sh"
    ""
    "Build and activate NixOS::mknixos switch"
    "Update, optimise, and rebuild NixOS::upgrade-nixos"
    ""
    "OpenRouter month to date cost::openrouter-cost.sh -s"
    "OpenRouter cost monitor::openrouter-cost.sh -l ~/.local/state/openrouter_cost.log 5"
    ""
    "LAN inventory scan::net-inventory.sh"
    ""
    "Show active services::systemctl list-units --type=service --state=active"
    "View system logs::journalctl -xe"
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
