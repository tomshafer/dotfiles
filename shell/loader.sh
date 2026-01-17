#!/usr/bin/env sh
# shellcheck disable=SC1090
# Load configurations into Bash or Zsh.

# set -eu

DOTFILES=${DOTFILES:-"$HOME/dotfiles"}

# 1. Load commons first
for f in "$DOTFILES"/shell/common/*.sh; do
    [ -r "$f" ] && . "$f"
done
unset f

# 2. Load shell-specific add-ons
shell_name=""
if [ -n "${ZSH_VERSION-}" ]; then
    shell_name="zsh"
elif [ -n "${BASH_VERSION-}" ]; then
    shell_name="bash"
elif [ -n "${SHELL-}" ]; then
    case "$SHELL" in
        *zsh) shell_name="zsh" ;;
        *bash) shell_name="bash" ;;
    esac
fi

if [ -z "$shell_name" ]; then
    case "$(ps -p $$ -o comm= 2>/dev/null)" in
        *zsh) shell_name="zsh" ;;
        *bash) shell_name="bash" ;;
    esac
fi

case "$shell_name" in
    zsh)  for f in "$DOTFILES"/shell/zsh/*.sh; do [ -r "$f" ] && . "$f"; done ;;
    bash) for f in "$DOTFILES"/shell/bash/*.sh; do [ -r "$f" ] && . "$f"; done ;;
esac
unset shell_name
