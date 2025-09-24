# vim: set filetype=tmux:

# See X11 color names: https://www.w3schools.com/colors/default.asp

# Set pane styles
set-option pane-border-lines heavy
set-option pane-border-style fg=gray       # vivid pink border
set-option pane-active-border-style fg=hotpink # active border in red

# Format status line
set-option status-style bg=hotpink
set-option status-left "#[bg=pink,fg=black,bold] #{pane_index} "
set-option status-right "#[bg=pink,fg=black] #H #[bg=crimson,fg=white] %H:%M  %a %d %b %Y "
set-option window-status-format " #W:#I "
set-option window-status-current-style bg=crimson,fg=white,bold

# Pane key bindings
bind-key -n M-1 select-pane -Z -t 1 # Select panes 1..4 with M-1..M-4
bind-key -n M-2 select-pane -Z -t 2
bind-key -n M-3 select-pane -Z -t 3
bind-key -n M-4 select-pane -Z -t 4
