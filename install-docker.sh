# Install dotfiles into Docker via VS Code Remote Container.
# Just cat the files into their (maybe nonexistent) counterparts
# Usage: install-docker.sh [PATH_TO_DOTFILES: ~/dotfiles]

dotpath="~/dotfiles"
if [[ -n $1 ]]; then
    dotpath="$1"
fi

for df in $dotpath/{bash/*,git/*,python/*,hushlogin,screenrc}; do

    target=".$(basename $df)"
    echo "$df -> $target"

    echo "\n" >> "$target"
    cat "$df" >> "$target"

done

unset dotpath
