# shellcheck shell=bash disable=SC1090,SC1091,SC2012
# Optional tools shared by Bash and Zsh.

if [ -n "${ZSH_VERSION-}" ]; then
    DOTFILES_SHELL=zsh
elif [ -n "${BASH_VERSION-}" ]; then
    DOTFILES_SHELL=bash
else
    return 0
fi

if [ "$DOTFILES_SHELL" = zsh ]; then
    __dotfiles_cache_init() {
        local cache_file=$1 command_path
        shift
        command_path=$(command -v "$1") || return

        if [ ! -r "$cache_file" ] || [ "$command_path" -nt "$cache_file" ]; then
            if ! { "$@" >| "$cache_file.tmp"; } 2>/dev/null; then
                rm -f "$cache_file.tmp"
                return
            fi
            mv -f "$cache_file.tmp" "$cache_file"
        fi
        if [ ! -s "$cache_file.zwc" ] || [ "$cache_file" -nt "$cache_file.zwc" ]; then
            zcompile -R -- "$cache_file.zwc" "$cache_file" 2>/dev/null || true
        fi
        . "$cache_file"
    }

    for tool in uv uvx; do
        command -v "$tool" >/dev/null 2>&1 || continue
        __dotfiles_cache_init "$ZSH_CACHE_DIR/$tool-completion.zsh" \
            "$tool" --generate-shell-completion zsh
    done
    unset tool

    command -v fzf >/dev/null 2>&1 && \
        __dotfiles_cache_init "$ZSH_CACHE_DIR/fzf.zsh" fzf --zsh
    command -v zoxide >/dev/null 2>&1 && \
        __dotfiles_cache_init "$ZSH_CACHE_DIR/zoxide.zsh" zoxide init zsh
    command -v direnv >/dev/null 2>&1 && \
        __dotfiles_cache_init "$ZSH_CACHE_DIR/direnv.zsh" direnv hook zsh

    unset -f __dotfiles_cache_init
else
    for tool in uv uvx; do
        command -v "$tool" >/dev/null 2>&1 || continue
        if ! complete -p "$tool" >/dev/null 2>&1; then
        eval "$("$tool" --generate-shell-completion bash)"
        fi
    done
    unset tool

    if command -v fzf >/dev/null 2>&1; then
        tool_init=$(fzf --bash 2>/dev/null) && . <(printf '%s\n' "$tool_init")
        unset tool_init
    fi

    if command -v zoxide >/dev/null 2>&1; then
        eval "$(zoxide init bash)"
    fi

    if command -v direnv >/dev/null 2>&1; then
        eval "$(direnv hook bash)"
    fi
fi

if command -v fd >/dev/null 2>&1; then
    fd_excludes='-E .git -E node_modules -E .venv -E __pycache__ -E .ruff_cache -E .mypy_cache -E .pytest_cache -E .tox -E .nox -E .Rproj.user -E .renv'
    [ -n "${FZF_DEFAULT_COMMAND-}" ] || FZF_DEFAULT_COMMAND="fd . $HOME -H $fd_excludes"
    [ -n "${FZF_CTRL_T_COMMAND-}" ] || FZF_CTRL_T_COMMAND="fd . -H $fd_excludes"
    [ -n "${FZF_ALT_C_COMMAND-}" ] || FZF_ALT_C_COMMAND="fd -t d . -H $fd_excludes"
    export FZF_DEFAULT_COMMAND FZF_CTRL_T_COMMAND FZF_ALT_C_COMMAND
    unset fd_excludes
fi

if [ -s "$HOME/.nvm/nvm.sh" ]; then
    export NVM_DIR="$HOME/.nvm"

    __dotfiles_load_nvm() {
        unset -f node npm npx corepack yarn pnpm nvm __dotfiles_load_nvm
        . "$NVM_DIR/nvm.sh"
    }
    node() { __dotfiles_load_nvm; node "$@"; }
    npm() { __dotfiles_load_nvm; npm "$@"; }
    npx() { __dotfiles_load_nvm; npx "$@"; }
    corepack() { __dotfiles_load_nvm; corepack "$@"; }
    yarn() { __dotfiles_load_nvm; yarn "$@"; }
    pnpm() { __dotfiles_load_nvm; pnpm "$@"; }
    nvm() { __dotfiles_load_nvm; nvm "$@"; }

    if [ "$DOTFILES_SHELL" = bash ] && [ -r "$NVM_DIR/bash_completion" ]; then
        . "$NVM_DIR/bash_completion"
    fi
fi

unset DOTFILES_SHELL
