# shellcheck shell=bash disable=SC1090,SC1091
# Tools to setup/configure after compinit

[[ -z $DOTFILES_SHELL && -n ${ZSH_VERSION-} ]] && DOTFILES_SHELL=zsh
[[ -z $DOTFILES_SHELL && -n ${BASH_VERSION-} ]] && DOTFILES_SHELL=bash
[[ -z $DOTFILES_SHELL ]] && return 0

DOTFILES_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/$DOTFILES_SHELL"
[[ -d $DOTFILES_CACHE_DIR ]] || mkdir -p "$DOTFILES_CACHE_DIR"

# Do we have a given command?
command -v have >/dev/null 2>&1 || have() { command -v "$1" >/dev/null 2>&1; }

# Source the correct shell-specific configurations
source_with_cache() {
  local tool cmdpath cachefile tmpfile

  tool="$1"
  cmdpath=$(command -v "$tool") || return
  cachefile="$DOTFILES_CACHE_DIR/$tool.$DOTFILES_SHELL"

  # Cache the tool script if the cache file is old or doesn't exist
  if [[ ! -r $cachefile || $cmdpath -nt $cachefile ]]; then
    tmpfile=$(mktemp "${tool}.tmp.XXXXXX") || return

    if ! "$@" >|"$tmpfile" 2>/dev/null; then
      rm -f "$tmpfile"
      return
    fi

    if ! mv -f "$tmpfile" "$cachefile"; then
      rm -f "$tmpfile"
      return
    fi
  fi

  # Compile the tool script if zsh
  if [[ $DOTFILES_SHELL == "zsh" ]]; then
    if [[ ! -s $cachefile.zwc || $cachefile -nt $cachefile.zwc ]]; then
      zcompile -R -- "$cachefile.zwc" "$cachefile" 2>/dev/null || :
    fi
  fi

  source "$cachefile"
}

have direnv && source_with_cache direnv hook "$DOTFILES_SHELL"
have fzf && source_with_cache fzf "--$DOTFILES_SHELL"
have zoxide && source_with_cache zoxide init "$DOTFILES_SHELL"

unset DOTFILES_SHELL DOTFILES_CACHE_DIR
unfunction have source_with_cache
