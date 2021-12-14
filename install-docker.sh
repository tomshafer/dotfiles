#!/usr/bin/env bash

# Install dotfiles into Docker via VS Code Remote Container.
# Just cat the files to the end of their (maybe nonexistent) counterparts.
# Usage: install-docker.sh

for df in bash/* python/* hushlogin screenrc; do
    target="$HOME/.$(basename $df)"

    echo "$df -> $target"
    cat "$df" >> "$target"
done
