#!/usr/bin/env sh
# shellcheck disable=SC1090
# Load configurations into Bash or Zsh.

set -eu

DOTFILES=${DOTFILES:-"$HOME/dotfiles"}

# 1. Load commons first
for f in "$DOTFILES"/shell/common/*.sh; do
    [ -r "$f" ] && . "$f"
done

# 2. Load shell-specific add-ons
case "$(ps -p $$ -o comm=)" in
    *zsh)  for f in "$DOTFILES"/shell/zsh/*.zsh; do [ -r "$f" ] && . "$f"; done ;;
    *bash) for f in "$DOTFILES"/shell/bash/*.sh; do [ -r "$f" ] && . "$f"; done ;;
esac
