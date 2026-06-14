# shellcheck shell=bash
# Shared environment for Bash and Zsh.

add_to_path() {
    [ -d "$1" ] || return 0
    case ":$PATH:" in
        *":$1:"*) ;;
        *) PATH="$1:$PATH" ;;
    esac
}

append_to_path() {
    [ -d "$1" ] || return 0
    case ":$PATH:" in
        *":$1:"*) ;;
        *) PATH="$PATH:$1" ;;
    esac
}

append_to_manpath() {
    [ -d "$1" ] || return 0
    case ":${MANPATH-}:" in
        *":$1:"*) ;;
        *) MANPATH="${MANPATH:+$MANPATH:}$1" ;;
    esac
}

: "${XDG_CONFIG_HOME:=$HOME/.config}"
: "${XDG_DATA_HOME:=$HOME/.local/share}"
: "${XDG_CACHE_HOME:=$HOME/.cache}"
export XDG_CONFIG_HOME XDG_DATA_HOME XDG_CACHE_HOME

# Preserve macOS package paths without invoking /usr/libexec/path_helper from
# /etc/zprofile. Existing PATH order wins; missing system entries are appended.
case ${OSTYPE-} in
darwin*)
    for path_file in /etc/paths /etc/paths.d/*; do
        [ -r "$path_file" ] || continue
        while IFS= read -r path_entry; do
            [ -n "$path_entry" ] && append_to_path "$path_entry"
        done < "$path_file"
    done
    unset path_entry path_file

    if [ "${MANPATH+x}" = x ]; then
        for manpath_file in /etc/manpaths /etc/manpaths.d/*; do
            [ -r "$manpath_file" ] || continue
            while IFS= read -r manpath_entry; do
                [ -n "$manpath_entry" ] && append_to_manpath "$manpath_entry"
            done < "$manpath_file"
        done
        MANPATH="${MANPATH%:}:"
        export MANPATH
        unset manpath_entry manpath_file
    fi
    ;;
esac

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

unset -f append_to_path append_to_manpath
