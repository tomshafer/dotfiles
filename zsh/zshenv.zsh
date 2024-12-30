#!/bin/zsh


# Environment
export EDITOR=vim
export VISUAL="$EDITOR"


# Path
typeset -U path


# Homebrew defaults
if command -v brew > /dev/null; then
    export HOMEBREW_NO_ENV_HINTS=1
    PATH="$(brew --prefix)/bin:$(brew --prefix)/sbin:$PATH"
fi


# Avoid issues with `gpg` as installed via Homebrew [1]
GPG_TTY=$(tty)
export GPG_TTY


# References
# --------------------------------------------------------------------
# [1]: https://stackoverflow.com/a/42265848
