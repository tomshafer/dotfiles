# shellcheck shell=bash
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
