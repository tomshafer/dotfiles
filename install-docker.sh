# Install dotfiles into Docker via VS Code Remote Container.
# Just cat the files into their (maybe nonexistent) counterparts

for df in bash/* git/* python/* hushlogin screenrc; do
    target=".$(basename $df)"
    echo "\n" >> "$target"
    cat "$df" >> "$target"
done
