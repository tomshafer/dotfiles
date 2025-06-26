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

if command -v uv >/dev/null; then
    eval "$(uv generate-shell-completion $DOTFILES_SHELL)"
fi

if command -v uvx >/dev/null; then
    eval "$(uvx --generate-shell-completion $DOTFILES_SHELL)"
fi

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
    source <(fzf --${DOTFILES_SHELL})
fi

# zoxide ---------------------------------------------------

if command -v zoxide >/dev/null; then
    eval "$(zoxide init --cmd cd $DOTFILES_SHELL)"
fi

# nvm ------------------------------------------------------

if [[ -d "$HOME/.nvm" ]]; then
    export NVM_DIR="$HOME/.nvm"

    [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
    [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
fi

# LM Studio ------------------------------------------------

if [[ -d "$HOME/.lmstudio" ]]; then
    PATH="$PATH:$HOME/.lmstudio/bin"
    export PATH
fi

unset DOTFILES_SHELL
