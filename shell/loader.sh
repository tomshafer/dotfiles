#!/usr/bin/env sh
# shellcheck disable=SC1090
# Load configurations into Bash or Zsh.

# set -eu

DOTFILES=${DOTFILES:-"$HOME/dotfiles"}

load_shell_files() {
    dir="$1"
    if [ -n "${ZSH_VERSION-}" ]; then
        setopt localoptions nonomatch
    fi
    for f in "$dir"/*.sh; do
        [ -r "$f" ] && . "$f"
    done
    unset dir f
}

# 1. Load commons first
load_shell_files "$DOTFILES/shell/common"

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
    zsh)  load_shell_files "$DOTFILES/shell/zsh" ;;
    bash) load_shell_files "$DOTFILES/shell/bash" ;;
esac
unset shell_name
unset -f load_shell_files
