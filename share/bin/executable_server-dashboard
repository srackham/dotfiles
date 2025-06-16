#!/usr/bin/env bash
#
# Open tmux dashboard on servers.
#
# +-------------------------+-------------------------+-------------------------+
# |         1               |           3             |           4             |
# |   htop (top-left)       |      (middle pane)      |   sudo iotop -o         |
# |                         |                         |   (top-right)           |
# +-------------------------+                         +-------------------------+
# |         2               |                         |           5             |
# | tail -f /files/bitcoin- |                         |   sudo nethogs          |
# | data/debug.log          |                         |   (bottom-right)        |
# | (bottom-left)           |                         |                         |
# +-------------------------+-------------------------+-------------------------+
#

SESSION="dashboard"
WINDOW="main"

# Check if the tmux session exists; if yes then attach it and exit
if tmux has-session -t "$SESSION" 2>/dev/null; then
  tmux attach-session -t "$SESSION"
  exit 0
fi

# Otherwise, create a tmux session called `dashboard`
tmux new-session -d -s "$SESSION" -n "$WINDOW"

# Split the session window into 3 equal-width vertical panes
tmux split-window -h -t "$SESSION:$WINDOW"           # Pane 1 (right)
tmux split-window -h -t "$SESSION:$WINDOW".1         # Pane 2 (middle)

# Split the left pane horizontally (htop top left, tail bottom left)
tmux split-window -v -t "$SESSION:$WINDOW".1
tmux send-keys    -t "$SESSION:$WINDOW".1 'htop' C-m
tmux send-keys    -t "$SESSION:$WINDOW".2 'tail -f /files/bitcoin-data/debug.log' C-m

# Split the right pane horizontally (iotop top right, nethogs bottom right)
tmux split-window -v -t "$SESSION:$WINDOW".4
tmux send-keys    -t "$SESSION:$WINDOW".4 'sudo iotop -o' C-m
tmux send-keys    -t "$SESSION:$WINDOW".5 'sudo nethogs' C-m

# Select middle pane
tmux select-pane -t "$SESSION:$WINDOW".3

# Attach the session
tmux attach-session -t "$SESSION"
