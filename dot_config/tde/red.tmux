# vim: set filetype=tmux:

# tde tmux commands file

# Set pane styles
set-option pane-border-lines heavy
set-option pane-border-style fg=gray
set-option pane-active-border-style fg=hotpink

# Format status line
set-option status-left "#[bg=pink,fg=black,bold] #{session_name} "
set-option status-right "#[bg=pink,fg=black] #H #[bg=crimson,fg=white] %H:%M  %a %d %b %Y "

set-option status-style bg=hotpink,fg=white
set-option window-status-current-style bg=crimson,fg=white,bold
set-option window-status-format " #W:#I "
set-option window-status-current-format " #W:#I "

set-hook after-new-window {
  set-option window-status-current-style 'bg=crimson,fg=white,bold'
  set-option window-status-format ' #W:#I '
  set-option window-status-current-format ' #W:#I '
}

