#!/usr/bin/env sh
# Common environmental configuration.

set -eu


# Use vim as default editor
export EDITOR=vim
export VISUAL="$EDITOR"

# Avoid issues with gpg as installed via Homebrew [1]
GPG_TTY=$(tty)
export GPG_TTY

# Use bat for paging [2]
if command -v bat >/dev/null 2>&1; then
    MANPAGER="sh -c 'col -bx | bat -l man -p --pager=\"less -RF\"'"
else
    MANPAGER="less -X"
fi
export MANPAGER


# References ---------------------------------------------------------
# [1]: https://stackoverflow.com/a/42265848
# [2]: https://github.com/sharkdp/bat?tab=readme-ov-file#man
