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

######################################################################
# Find and activate a virtual env in the directory tree
######################################################################
venv() {
  # If a virtual env is set, deactivate it
  if [[ -n $VIRTUAL_ENV ]]; then
    if command -v deactivate >/dev/null; then
      echo "Deactivated $VIRTUAL_ENV"
      deactivate
    fi
  fi

  local here parent dr
  here="$(pwd)"

  while :; do
    # Try to fine a venv in the directory
    for dr in .venv .env venv env; do
      if [[ -d $here/$dr ]]; then
        echo "Activated   $here/$dr"
        # shellcheck disable=SC1090
        source "$here"/"$dr"/bin/activate
        echo "python:     $(which python)"
        echo "pip:        $(which pip)"
        return
      fi
    done

    # If not, loop again with the parent
    parent=$(dirname "$here")

    # Break when the parent is repeated
    if [[ $parent == "$here" ]]; then
      break
    fi

    here="$parent"
  done
  echo "No venv was located" >&2
}
