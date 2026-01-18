# shellcheck shell=bash

# Confirm common XDG format --------------------------------

# XDG Base Directory Specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# Homebrew -------------------------------------------------

# This has to be right at the top to find utilities
if command -v brew >/dev/null 2>&1; then
    eval "$(brew shellenv)"        # Set up paths and exports
    export HOMEBREW_NO_ANALYTICS=1 # Disable telemetry
    export HOMEBREW_NO_ENV_HINTS=1 # Disable env hints

    # Homebrew can mess up the path
    if [[ -n ${ZSH_VERSION-} ]]; then
        # shellcheck disable=SC2034
        typeset -U path
    fi
fi

# System defaults ------------------------------------------

export TZ=America/New_York # The one true time zone
export LANG=en_US.UTF-8    # Locale & language

# Editors --------------------------------------------------

# Use (n)vim as default editor
if command -v nvim >/dev/null 2>&1; then
    export EDITOR=nvim
    export VISUAL=nvim
elif command -v vim >/dev/null 2>&1; then
    export EDITOR=vim
    export VISUAL="$EDITOR"
fi

# Pagers ---------------------------------------------------

# TODO: Add termcap colors if we don't have bat

# Don't reset the screen
export LESS="-RF"
export LESSHISTFILE="-"  # Don't store a less history file
export PAGER="less"
export MANPAGER="less -R"

# Less termcap colors (safe defaults when not using bat)
export LESS_TERMCAP_mb=$'\033[1;31m'
export LESS_TERMCAP_md=$'\033[1;36m'
export LESS_TERMCAP_me=$'\033[0m'
export LESS_TERMCAP_so=$'\033[01;44;33m'
export LESS_TERMCAP_se=$'\033[0m'
export LESS_TERMCAP_us=$'\033[1;32m'
export LESS_TERMCAP_ue=$'\033[0m'

# Use bat: https://github.com/sharkdp/bat?tab=readme-ov-file#man
if command -v bat >/dev/null 2>&1; then
    export MANPAGER="sh -c 'col -bx | bat -l man -p --pager=\"less\"'"
fi

# Colors ---------------------------------------------------

# Consistent defaults
export LSCOLORS="exfxcxdxbxegedabagacadah"
