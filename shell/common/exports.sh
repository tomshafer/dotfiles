# shellcheck shell=bash

# Homebrew -------------------------------------------------

# This has to be right at the top to find utilities
if command -v brew >/dev/null 2>&1; then
    eval "$(brew shellenv)"        # Set up paths and exports
    export HOMEBREW_NO_ANALYTICS=1 # Disable telemetry
fi

# System defaults ----------------------------------------------------

export TZ=America/New_York # The one true time zone
export LANG=en_US.UTF-8    # Locale & language

# Editors ------------------------------------------------------------

# Use vim as default editor
if command -v vim >/dev/null 2>&1; then
    export EDITOR=vim
fi

# Pagers -------------------------------------------------------------

# TODO: Add termcap colors if we don't have bat

# Don't reset the screen
export LESS="-RF"
export PAGER="less"
export MANPAGER="less"

# Use bat: https://github.com/sharkdp/bat?tab=readme-ov-file#man
if command -v bat >/dev/null 2>&1; then
    export MANPAGER="sh -c 'col -bx | bat -l man -p --pager=\"less\"'"
fi
