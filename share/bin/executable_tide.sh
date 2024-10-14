#!/usr/bin/env bash
#
# Mini tmux IDE: editor in left pane; terminal in right pane; a third lazygit pane if in a Git repo
#

usage() {
    echo "Usage: $(basename "$0") [-h | --help] [<dir>]"
    echo "  <dir>           Working directory (default: current directory)"
    echo "  -h, --help      Display this help message"
}

# Check if we're in a tmux session
if [ -z "$TMUX" ]; then
    echo "This command must be run inside a tmux session."
    exit 1
fi

rootdir=""

while (( $# > 0 )); do
    case "$1" in
        -h|--help)
            usage
            exit 0
            ;;
        *)
            rootdir="$1"
            shift
            ;;
    esac
done

if [ -z "$rootdir" ]; then
    rootdir="$(pwd)"
fi

if [[ ! -d "$rootdir" ]]; then
    echo "'$rootdir' is not a valid directory" >&2
    exit 1
fi

rootdir=$(realpath "$rootdir")

tmux \
    new-window -c "$rootdir" -n "$(basename "$rootdir")"\; \
    split-window -c "$rootdir" -h\; \
    if-shell "[ -d "$rootdir/.git" ]" "split-window -c "$rootdir" -v"\; \
    if-shell "[ -d "$rootdir/.git" ]" "send-keys lazygit Enter"\; \
    select-pane -L\; \
    send-keys "hx -w ." Enter\; \
    send-keys " f"
