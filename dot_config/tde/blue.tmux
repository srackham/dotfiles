# vim: set filetype=tmux:

# tde tmux commands file

# Layout options
set-option main-pane-width 50%

# Set pane styles
set-option pane-border-lines heavy
set-option pane-border-style fg=gray
set-option pane-active-border-style fg=color33

# Format status line
set-option status-left "#[bg=color39,fg=black,bold] #{session_name} "
set-option status-right "#[bg=color39,fg=black] #H #[bg=color19,fg=white] %H:%M  %a %d %b %Y "

set-option status-style bg=color33,fg=white
set-option window-status-current-style bg=color19,fg=white,bold
set-option window-status-format " #W:#I "
set-option window-status-current-format " #W:#I "

set-hook after-new-window {
  set-option window-status-current-style 'bg=color19,fg=white,bold'
  set-option window-status-format ' #W:#I '
  set-option window-status-current-format ' #W:#I '
}

