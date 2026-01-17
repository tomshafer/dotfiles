# shellcheck shell=bash
# Generated with Codex

# Resolve a path without depending on Python.
resolve_realpath() {
    local target="$1"
    local dir link

    if command -v realpath >/dev/null 2>&1; then
        realpath "$target"
        return
    fi

    if [ -d "$target" ]; then
        (cd -P "$target" 2>/dev/null && pwd -P) && return
    fi

    case "$target" in
    /*) ;;
    *) target="$PWD/$target" ;;
    esac

    if command -v readlink >/dev/null 2>&1; then
        while [ -L "$target" ]; do
            link="$(readlink "$target")" || break
            case "$link" in
            /*) target="$link" ;;
            *)
                dir="$(dirname "$target")"
                target="$dir/$link"
                ;;
            esac
        done
    fi

    dir="$(cd -P "$(dirname "$target")" 2>/dev/null && pwd -P)" || return 1
    printf '%s/%s\n' "$dir" "$(basename "$target")"
}
