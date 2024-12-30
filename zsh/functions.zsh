#!/bin/zsh


# Run `mkdir` and `cd` together
mkd() {
  [[ $# != 1 ]] && echo >&2 "Usage: mkd DIRECTORY" && return 1
  mkdir -p "$1" && cd "$1" && echo >&2 "mkdir \"$1\""
}


# Use `bat` to show and highlight help pages [1]
help() {
  if command -v bat > /dev/null; then
      "$@" --help 2>&1 | bat --plain --language=help
  fi

  # Pass through to the usual --help argument
  "$@" --help
}


# References
# --------------------------------------------------------------------
# [1]: https://github.com/sharkdp/bat
