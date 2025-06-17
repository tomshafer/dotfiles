#! /usr/bin/env zsh
#  ZSH completions

# History-based autocompletion with arrow keys:
# https://unix.stackexchange.com/a/100860
bindkey "\e[A" history-search-backward
bindkey "\e[B" history-search-forward

# Case-insensitive completion: https://superuser.com/a/1092328
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Completion engine startup
autoload -Uz compinit && compinit -u

# Add ZSH completions to the fpath
if [[ -d $(brew --prefix)/share/zsh-completions ]]; then
    fpath+=/opt/homebrew/share/zsh-completions
fi
