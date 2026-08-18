#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
    printf 'Usage: %s REMOTE_HOST PROMPT_COLOR\n' "$0" >&2
    exit 2
fi

remote_host=$1
color=$2

[[ $color =~ ^[[:alnum:]_#.-]+$ ]] || {
    printf 'Invalid color: %s\n' "$color" >&2
    exit 2
}

script_dir=$(
    cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &&
        pwd
)

source_file="$script_dir/omv8-zshrc"
remote_tmp="/tmp/omv8-zshrc.$$"

[[ -f $source_file ]] || {
    printf 'Source file not found: %s\n' "$source_file" >&2
    exit 1
}

scp -- "$source_file" "$remote_host:$remote_tmp"

ssh "$remote_host" bash -s -- "$remote_tmp" "$color" <<'REMOTE'
set -euo pipefail

source_file=$1
color=$2
destination="$HOME/.zshrc"

trap 'rm -f -- "$source_file"' EXIT

# Set prompt color
sed "0,/%F{[^}]*}/s//%F{$color}/" "$source_file" > "$destination"

# Update Debian packages
sudo apt update
sudo apt install --yes curl sshpass parted rsnapshot rclone htop man-db manpages zsh tmux jq bat zsh-syntax-highlighting eza

# Create /root/.zshrc file
sudo zsh -c 'cat > /root/.zshrc' <<'EOF'
source ~super/.zshrc
export PROMPT=$'\n%B%F{white}%n@%m %F{cyan}%~%f%b\n$ '
EOF

REMOTE
