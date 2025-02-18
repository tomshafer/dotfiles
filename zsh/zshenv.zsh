#!/bin/zsh

# Environment
export EDITOR=vim
export VISUAL="$EDITOR"

# Avoid issues with `gpg` as installed via Homebrew [1]
GPG_TTY=$(tty)
export GPG_TTY

# References
# --------------------------------------------------------------------
# [1]: https://stackoverflow.com/a/42265848
