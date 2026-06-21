# shellcheck shell=bash
# Completions to be sourced ahead of, e.g., compinit

[[ -z $DOTFILES_SHELL && -n ${ZSH_VERSION-} ]] && DOTFILES_SHELL=zsh
[[ -z $DOTFILES_SHELL && -n ${BASH_VERSION-} ]] && DOTFILES_SHELL=bash
[[ -z $DOTFILES_SHELL ]] && return 0

# Do we have a given command?
command -v have >/dev/null 2>&1 || have() { command -v "$1" >/dev/null 2>&1; }

# Build completions for bash and zsh
build_completions() {
  local tool cmdpath compfile tmpfile

  tool="$1"
  cmdpath=$(command -v "$tool") || return

  # Completion file depends on the shell
  if [[ $DOTFILES_SHELL == "zsh" ]]; then
    compfile="$HOME/.zfunc/_$tool"
    [[ -d $HOME/.zfunc ]] || mkdir -p "$HOME/.zfunc"
  elif [[ $DOTFILES_SHELL == "bash" ]]; then
    compfile="${XDG_DATA_HOME:-$HOME/.local/share}/bash-completion/completions/$tool"
    [[ -d ${XDG_DATA_HOME:-$HOME/.local/share}/bash-completion/completions ]] || mkdir -p "${XDG_DATA_HOME:-$HOME/.local/share}/bash-completion/completions"
  else
    return
  fi

  # If the completion file doesn't exist write it
  if [[ ! -r $compfile || $cmdpath -nt $compfile ]]; then
    tmpfile=$(mktemp "${TMPDIR:-/tmp}/$tool.tmp.XXXXXX") || return

    if ! "$@" >|"$tmpfile" 2>/dev/null; then
      rm -f "$tmpfile"
      return
    fi

    if ! mv -f "$tmpfile" "$compfile"; then
      rm -f "$tmpfile"
      return
    fi
  fi
}

have fd && build_completions fd --gen-completions "$DOTFILES_SHELL"
have uv && build_completions uv --generate-shell-completion "$DOTFILES_SHELL"
have uvx && build_completions uvx --generate-shell-completion "$DOTFILES_SHELL"

unset DOTFILES_SHELL
unfunction build_completions have
