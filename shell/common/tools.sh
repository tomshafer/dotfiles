# shellcheck shell=bash
# shellcheck disable=SC1090

# Set up additional tools, if available.
# These depend on completion being available.

# Identify the shell for tool setup
if [[ -n $ZSH_VERSION ]]; then
    DOTFILES_SHELL="zsh"
elif [[ -n $BASH_VERSION ]]; then
    DOTFILES_SHELL="bash"
else
    echo "Out of scope shell: \"$SHELL\"" >&2
    exit 1
fi

# uv -------------------------------------------------------

for cmd in uv uvx; do
    if command -v $cmd >/dev/null && [[ -z ${_comps[$cmd]} ]]; then
        eval "$($cmd --generate-shell-completion $DOTFILES_SHELL)"
    fi
done

# Fix completions for `uv run` in zsh
# https://github.com/astral-sh/uv/issues/8432#issuecomment-2867318195
if [[ $DOTFILES_SHELL == "zsh" ]]; then
    _uv_run_mod() {
        # shellcheck disable=SC2154
        if [[ "${words[2]}" == "run" && "${words[CURRENT]}" != -* ]]; then
            _arguments '*:filename:_files'
        else
            _uv "$@"
        fi
    }
    compdef _uv_run_mod uv
fi

# fzf ------------------------------------------------------

if command -v fzf >/dev/null; then
    if script="$(fzf --$DOTFILES_SHELL 2>/dev/null)"; then
        source <(printf '%s\n' "$script")
    fi
    unset script
fi

# https://mike.place/2017/fzf-fd/
if command -v fd >/dev/null; then
    export FZF_DEFAULT_COMMAND="fd . $HOME"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="fd -t d . $HOME"
fi

# zoxide ---------------------------------------------------

if command -v zoxide >/dev/null; then
    eval "$(zoxide init $DOTFILES_SHELL)"
fi

# direnv ---------------------------------------------------

if command -v direnv >/dev/null; then
    eval "$(direnv hook $DOTFILES_SHELL)"
fi

# nvm ------------------------------------------------------

if [[ -d "$HOME/.nvm" ]]; then
    export NVM_DIR="$HOME/.nvm"
    export NVM_AUTO_USE=0

    # Make default node binaries available before nvm lazy-loads.
    # Generated with GPT 5.2 and Codex
    if [[ -s "$NVM_DIR/alias/default" ]]; then
        nvm_default="$(<"$NVM_DIR/alias/default")"
        nvm_default_version=""
        if [[ "$nvm_default" == "node" || "$nvm_default" == "stable" ]]; then
            nvm_default_version="$(ls -1 "$NVM_DIR/versions/node" 2>/dev/null | sort -V | tail -n 1)"
        elif [[ "$nvm_default" == lts/* ]]; then
            lts_alias="$NVM_DIR/alias/${nvm_default#lts/}"
            [[ -s "$lts_alias" ]] && nvm_default_version="$(<"$lts_alias")"
        else
            nvm_default_version="$nvm_default"
        fi

        if [[ -n "$nvm_default_version" ]]; then
            nvm_default_version="${nvm_default_version#v}"
            nvm_default_dir="$NVM_DIR/versions/node/v$nvm_default_version/bin"
            if [[ -d "$nvm_default_dir" ]]; then
                add_to_path "$nvm_default_dir"
                export NVM_BIN="$nvm_default_dir"
            fi
        fi
        unset nvm_default nvm_default_version nvm_default_dir lts_alias
    fi

    [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"

    __nvm_lazy_load() {
        # Source nvm only once
        unset -f node npm npx corepack yarn pnpm nvm __nvm_lazy_load
        [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    }

    # Stubs that load nvm only when needed
    node() {
        __nvm_lazy_load
        node "$@"
    }
    npm() {
        __nvm_lazy_load
        npm "$@"
    }
    npx() {
        __nvm_lazy_load
        npx "$@"
    }
    corepack() {
        __nvm_lazy_load
        corepack "$@"
    }
    yarn() {
        __nvm_lazy_load
        yarn "$@"
    }
    pnpm() {
        __nvm_lazy_load
        pnpm "$@"
    }
    nvm() {
        __nvm_lazy_load
        nvm "$@"
    }
fi

# LM Studio ------------------------------------------------

if [[ -d "$HOME/.lmstudio" ]]; then
    PATH="$PATH:$HOME/.lmstudio/bin"
    export PATH
fi

unset DOTFILES_SHELL
