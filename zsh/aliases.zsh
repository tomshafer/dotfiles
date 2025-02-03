#!/bin/zsh


# Listing
# --------------------------------------------------------------------

# Use `lsd` if available, otherwise use builtin `ls`
if command -v lsd > /dev/null 2>&1; then
    alias ls="lsd -Fg"
    alias l="ls -l --no-symlink"
else
    alias ls="command ls -Fh --color=auto"
    alias l="ls -l"
fi

alias ll="l -A"
alias la="l -a"
alias lr="l -rt"
alias lt="l -t"


# Navigation
# --------------------------------------------------------------------

alias ..='cd ..'
alias ...='cd ../..'


# Miscellany
# --------------------------------------------------------------------

# Git
alias g="git"

# Fix systems where `bat` is called `batcat`
if ! command -v bat > /dev/null && command -v batcat > /dev/null; then
    alias bat='batcat'
fi
