#!/usr/bin/env sh
# Common, useful functions.

######################################################################
# Run `mkdir` and `cd` together
# Arguments:
#   Directory name to create and move to.
# Outputs:
#   Writes `mkdir` call to stderr.
######################################################################
mkd() {
  [ $# != 1 ] && echo >&2 "Usage: mkd DIRECTORY" && return 1
  mkdir -p "$1" && cd "$1" && echo >&2 "mkdir \"$1\""
}

######################################################################
# Use `bat` to show and highlight help pages [1]
# Arguments:
#   Command name and optional arguments.
# Outputs:
#   The command's `--help` output, using `bat` if possible.
######################################################################
help() {
  if command -v bat >/dev/null 2>&1; then
    "$@" --help 2>&1 | bat --plain --language=help
  fi

  # Pass through to the usual --help argument
  "$@" --help
}

# References ---------------------------------------------------------
# [1]: https://github.com/sharkdp/bat
