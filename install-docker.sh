#!/usr/bin/env bash

# Install dotfiles into Docker via VS Code Remote Container.
# Just cat the files into their (maybe nonexistent) counterparts
# Usage: install-docker.sh [PATH_TO_DOTFILES: ~/dotfiles]

dotpath=$([[ -z $1 ]] && echo ~/dotfiles ||echo "$1")

for df in $dotpath/{bash/*,git/*,python/*,hushlogin,screenrc}; do
    target=".$(basename $df)"

    echo "$df -> $target"
    cat "$df" >> "$target"
done

unset dotpath
