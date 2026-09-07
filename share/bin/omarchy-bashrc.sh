# Omarchy environment (OMARCHY_PATH + PATH), needed even for non-interactive shells
[[ -r /usr/share/omarchy/default/bash/env-bootstrap ]] && source /usr/share/omarchy/default/bash/env-bootstrap

# If not running interactively, don't do anything else (leave this above the rc source)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source "$OMARCHY_PATH/default/bash/rc"

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly

# --- custom options ---
bind -s 'set completion-ignore-case on' >/dev/null
set -o vi
shopt -s extglob
shopt -s globstar # the ** pattern recursively matches subdirectories and files.
shopt -s histappend

# --- custom exports ---
export PATH="$HOME/bin:$PATH"
export EDITOR="nvim"

# --- custom aliases ---
alias ,="cd -"
alias ..="cd .."
alias ...="cd ../.."

alias b="brave"
alias btc='echo $(date +'%H:%M'): $(ccp BTC)'
alias cryptor-plot="cryptor history -confdir ~/bin/.cryptor -portfolio aggregate | plot-history.sh"
alias cryptor-summary="cryptor valuate -currency nzd -confdir ~/bin/.cryptor -aggregate-only"
alias diff="diff --color=always -u"
alias dmesg="sudo dmesg --human --color=always"
alias drake="deno run -A Drakefile.ts"
alias gg="git grep -P"
alias gl="git log --graph --color=always --pretty=format:'%C(auto)%h %C(auto)%d %Cgreen%cr%Creset %s' | fzf --ansi --preview 'git show --color {2}'"
alias gls="git ls-files"
alias grep="grep --color=auto"
alias g="rg -i"
alias gs="git status --short 2>/dev/null"
alias h="history -a && history -r && history" # List history from all shell instances.
alias l="bat --plain"
alias lsa="ls -a"
alias ls="eza -l --group-directories-first --icons=auto"
alias lsf="eza"
alias lsm="lsa --sort modified"
alias lsp="eza --absolute"
alias lta="lt -a"
alias ltd="lt --only-dirs"
alias lt="eza --tree --long --icons --level=2"
alias ltg="lt --git-ignore"
alias nls="npm list --depth 0 --silent"
alias pass-clip="pass-names | fzf | xargs -d '\n' pass show -c"                                                      # Copy password from pass password manager to the clipboard
alias pass-names='find ~/.password-store -name '\''*.gpg'\'' -type f | sed "s|^$HOME/.password-store/||; s|\.gpg||"' # List name paths of pass entries
alias pass-show="pass-names | fzf | xargs -d '\n' pass show"                                                         # Print entry from pass password manager stdout
alias paste-browser="paste-image >/tmp/clipboard.png && b /tmp/clipboard.png 2>/dev/null"                            # Paste image to browser
alias paste-image="wl-paste -t image/png"                                                                            # Paste clipboard PNG image to stdout
alias paste-text="wl-paste -t text/plain"                                                                            # Paste clipboard text to stdout
alias resize-image="mogrify -quality 25 -resize 800"                                                                 # Resize and compress images
alias rg="rg --colors path:style:bold  --colors path:fg:yellow"
alias stylua-all="stylua \$(find . -name '*.lua')" # Recursively format all .lua files in the current directory
alias stylua='stylua --config-path "$HOME/.config/nvim/stylua.toml"'
alias sudo='sudo ' # So aliases can be used
