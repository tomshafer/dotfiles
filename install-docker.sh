#!/usr/bin/env bash

# Install dotfiles into Docker via VS Code Remote Container.
# Just cat the files to the end of their (maybe nonexistent) counterparts.

for df in bash/* git/* python/* hushlogin screenrc; do
    target="$HOME/.$(basename $df)"

    echo "$df -> $target"
    cat "$df" >> "$target"
done
