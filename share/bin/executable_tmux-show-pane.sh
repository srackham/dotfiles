#!/usr/bin/env bash
# Usage: tmux-show-pane.sh N  (where N is 2..9)
set -euo pipefail

# Check if N is provided
if [ $# -eq 0 ]; then
	echo "Usage: $0 N   (where N is between 2 and 9)" >&2
	exit 1
fi

N="$1"

# Validate N: must be a single digit 2..9
if [[ ! "$N" =~ ^[2-9]$ ]]; then
	echo "Usage: $0 N   (where N is between 2 and 9)" >&2
	exit 1
fi

# For pane 1 reference
LEFT_PANE=1

# Iterate panes 2..9
for i in {2..9}; do
	# Check if pane i exists
	if tmux list-panes -F "#{pane_index}" | grep -qx "$i"; then
		# Pane exists, select it to perform resize
		tmux select-pane -t "$i"
	else
		# Pane does not exist
		if [ "$i" -eq 2 ]; then
			# For i==2, split pane 1 horizontally, detached, then select the new pane
			tmux select-pane -t "$LEFT_PANE"
			tmux split-window -h -t "$LEFT_PANE"
			tmux select-pane -t "$i"
		elif [ "$i" -ge 3 ] && [ "$i" -le "$N" ]; then
			# For 3..N, split current pane vertically, then select the new pane
			tmux split-window -v -t "$i" # split current pane vertically
			tmux select-pane -t "$i"
		else
			# i > N and pane i does not exist: break enumeration
			break
		fi
	fi

	# Resize panes: minimize all but i == N
	if [ "$i" -eq "$N" ]; then
		# Maximize height to full window height
		HEIGHT=$(tmux display-message -p "#{window_height}")
		tmux resize-pane -y "$HEIGHT"
	else
		# Minimize height to 1 (minimum)
		tmux resize-pane -y 1
	fi
done

# Finally, select pane N to focus
tmux select-pane -t "$N"
