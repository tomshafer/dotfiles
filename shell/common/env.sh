# shellcheck shell=bash
# Shared environment for Bash and Zsh.

add_to_path() {
    [ -d "$1" ] || return 0
    case ":$PATH:" in
        *":$1:"*) ;;
        *) PATH="$1:$PATH" ;;
    esac
}

: "${XDG_CONFIG_HOME:=$HOME/.config}"
: "${XDG_DATA_HOME:=$HOME/.local/share}"
: "${XDG_CACHE_HOME:=$HOME/.cache}"
export XDG_CONFIG_HOME XDG_DATA_HOME XDG_CACHE_HOME

# Homebrew is installed in one of these locations on supported Macs.
if [ -x /opt/homebrew/bin/brew ]; then
    HOMEBREW_PREFIX=/opt/homebrew
elif [ -x /usr/local/bin/brew ]; then
    HOMEBREW_PREFIX=/usr/local
fi
if [ -n "${HOMEBREW_PREFIX-}" ]; then
    export HOMEBREW_PREFIX HOMEBREW_NO_ANALYTICS=1 HOMEBREW_NO_ENV_HINTS=1
    add_to_path "$HOMEBREW_PREFIX/bin"
    add_to_path "$HOMEBREW_PREFIX/sbin"
fi

add_to_path "$HOME/.npm-packages/bin"
add_to_path "$HOME/.local/bin"
add_to_path "$HOME/bin"
add_to_path "$HOME/.lmstudio/bin"
export PATH

export TZ=America/New_York
export LANG=en_US.UTF-8

if command -v nvim >/dev/null 2>&1; then
    export EDITOR=nvim VISUAL=nvim
elif command -v vim >/dev/null 2>&1; then
    export EDITOR=vim VISUAL=vim
else
    export EDITOR=vi VISUAL=vi
fi

export LESS=-RF
export LESSHISTFILE=-
export PAGER=less
export MANPAGER='less -R'
export LSCOLORS=exfxcxdxbxegedabagacadah
: "${LS_COLORS:=di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43}"
export LS_COLORS
