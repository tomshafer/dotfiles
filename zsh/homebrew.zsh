#! /usr/bin/env zsh
#  Homebrew configuration options

export HOMEBREW_NO_ANALYTICS=1  # Turn off Homebrew analytics

# Add ZSH completions to the fpath
if [[ -d $(brew --prefix)/share/zsh-completions ]]; then
    fpath+=/opt/homebrew/share/zsh-completions
fi
