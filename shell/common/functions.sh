# shellcheck shell=bash
# Common, useful functions.

######################################################################
# Run `mkdir` and `cd` together
# Arguments:
#   Directory name to create and move to.
# Outputs:
#   Writes `mkdir` call to stderr.
######################################################################
mkcd() {
  [ $# != 1 ] && echo >&2 "Usage: mkcd DIRECTORY" && return 1
  mkdir -p "$1" && echo >&2 "mkdir \"$1\"" && cd "$1"
}

######################################################################
# Launch a new VS Code window
# Arguments:
#   Directory or file to open in a new window.
######################################################################
if command -v code >/dev/null; then
  cn() {
    local target="${1:-.}"
    code -n "$target"
  }  
fi

######################################################################
# Activate the nearest virtual env
######################################################################
venv() {
  # If a virtual env is set, deactivate it
  if [[ -n ${VIRTUAL_ENV-} ]]; then
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
        echo >&2 "Activated   $here/$dr"
        # shellcheck disable=SC1090
        source "$here"/"$dr"/bin/activate
        echo >&2 "python:     $(which python)"
        echo >&2 "pip:        $(which pip)"
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
  echo >&2 "No venv was located"
}
