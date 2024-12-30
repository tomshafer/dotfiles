#!/bin/zsh

# Environment
export EDITOR=vim
export VISUAL="$EDITOR"


# Path
# [[ $(type -t brew) ]] && PATH="$(brew --prefix)/bin:$(brew --prefix)/sbin:$PATH"
# [[ -d $HOME/bin ]] && PATH="$HOME/bin:$PATH"
# typeset -U path
# export PATH="$PATH"

# if [[ $(type -t bat) ]]; then
#   export MANPAGER="sh -c 'col -bx | bat -l man -p --pager=\"less -RF\"'"
# else
#   export MANPAGER="less -X"
# fi

# Avoid issues with `gpg` as installed via Homebrew.
# https://stackoverflow.com/a/42265848
GPG_TTY=$(tty)
export GPG_TTY

# # Homebrew defaults
# if [[ $(type -t brew) ]]; then
#   export HOMEBREW_NO_ENV_HINTS=1
# fi
