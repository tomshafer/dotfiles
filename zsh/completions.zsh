#!/bin/zsh

# Additional Homebrew completions

if command -v brew > /dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
fi

autoload -Uz compinit
compinit
