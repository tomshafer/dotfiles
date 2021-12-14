#!/usr/bin/env bash

# Install dotfiles into Docker via VS Code Remote Container.
# Just cat the files to the end of their (maybe nonexistent) counterparts.
# Usage: install-docker.sh [--no-git]

for df in bash/* git/* python/* hushlogin screenrc; do
    target="$HOME/.$(basename $df)"

    [[ $1 == "--no-git" && $target =~ gitconfig$ ]] && continue

    echo "$df -> $target"
    cat "$df" >> "$target"
done
