#!/bin/zsh


# Environment
export EDITOR=vim
export VISUAL="$EDITOR"


# Homebrew defaults
export HOMEBREW_NO_ENV_HINTS=1


# Avoid issues with `gpg` as installed via Homebrew [1]
GPG_TTY=$(tty)
export GPG_TTY


# References
# --------------------------------------------------------------------
# [1]: https://stackoverflow.com/a/42265848
