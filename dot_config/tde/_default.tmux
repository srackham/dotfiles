# vim: set filetype=tmux:

# See X11 color names: https://www.w3schools.com/colors/default.asp
# 256 terminal colors: https://robotmoon.com/256-colors/

#
# tde tmux configuration
#

# Set pane styles
set-option pane-border-lines heavy
set-option pane-border-style fg=color240
set-option pane-active-border-style fg=green

# Format status line
set-option status-left "#[bg=color227,bold] #{pane_index} "
set-option status-right  "#[bg=color227] #H #[bg=color190] %H:%M  %a %d %b %Y "

set-option status-style bg=green,fg=black
set-option window-status-current-style bg=color190,fg=black,bold
set-option window-status-format " #W:#I "
set-option window-status-current-format " #W:#I "

set-hook after-new-window {
  set-option window-status-current-style bg=color190,fg=black,bold
  set-option window-status-format ' #W:#I '
  set-option window-status-current-format ' #W:#I '
}

# Miscellaneous key bindings
bind-key -n M-Enter copy-mode
bind-key -n F11 resize-pane -Z # Toggle full-screen
bind-key -n M-z resize-pane -Z # Toggle full-screen

# Pane key bindings
bind-key -n M-] select-pane -t :.+                                                  # Cycle forwards through panes
bind-key -n M-[ select-pane -t :.-                                                  # Cycle backwards through panes
bind-key -n M-0 split-window -v -c "#{pane_current_path}" \; resize-pane -D -y 100% # Create new full-height pane
bind-key -n M-1 select-pane -Z -t 1 \; resize-pane -D -y 100%                       # Select panes 1..4 with M-1..M-4
bind-key -n M-2 select-pane -Z -t 2 \; resize-pane -D -y 100%
bind-key -n M-3 select-pane -Z -t 3 \; resize-pane -D -y 100%
bind-key -n M-4 select-pane -Z -t 4 \; resize-pane -D -y 100%
bind-key -n M-e select-pane -Z -l \; resize-pane -D -y 100%                         # Previous active pane
# Command-line recall in pane 2 (or pane 1 if there is only one pane)
bind-key -n M-r if-shell "[[ \$(tmux list-panes | wc -l) -eq 1 ]]" \
    "select-pane -Z -t 1 \; resize-pane -D -y 100% \; send-keys M-r" \
    "select-pane -Z -t 2 \; resize-pane -D -y 100% \; send-keys M-r"

bind-key -n M-S-r select-pane -Z -t 2 \; resize-pane -D -y 100% \; \
    run-shell "sync" \; \
    run-shell "sleep 0.1" \; \
    send-keys Up Enter
bind-key -n M-u select-pane -Z -t 2 \; resize-pane -D -y 100% \; select-pane -Z -t 1 # Reset tmux UI (show panes 1 & 2, focus pane 1)

# Window key bindings
bind-key -n M-w last-window                        # Previous active window
bind-key -n 'M-}' next-window                      # Cycle forwards through windows
bind-key -n 'M-{' previous-window                  # Cycle backwards through windows
bind-key k kill-window
bind-key > swap-window -t:+ \; select-window -t:+  # Swap window right
bind-key < swap-window -t:- \; select-window -t:-  # Swap window left
bind-key h split-window -hc "#{pane_current_path}" # Horizontal split
bind-key v split-window -vc "#{pane_current_path}" # Vertical split

