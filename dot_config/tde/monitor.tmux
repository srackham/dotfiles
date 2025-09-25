# vim: set filetype=tmux:
#
# monitor session customisation (see ~/.config/tde/monitor.conf)
#

# See X11 color names: https://www.w3schools.com/colors/default.asp
# 256 terminal colors: https://robotmoon.com/256-colors/

# Set pane styles
set-option pane-border-lines heavy
set-option pane-border-style fg=gray       # vivid pink border
set-option pane-active-border-style fg=hotpink # active border in red

# Format status line
set-option status-left "#[bg=pink,fg=black,bold] #{pane_index} "
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

