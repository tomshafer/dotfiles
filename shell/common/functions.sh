# shellcheck shell=bash disable=SC1090
# Functions shared by Bash and Zsh.

# Shortcut for checking commands
if ! command -v have > /dev/null 2>&1; then
  have() {
    command -v "$1" > /dev/null 2>&1
  }
fi

mkcd() {
  [ "$#" -eq 1 ] || {
    echo 'usage: mkcd DIRECTORY' >&2
    return 1
  }
  mkdir -p "$1" && cd "$1" || return
}

mktmp() {
  [ "$#" -eq 0 ] || {
    echo 'usage: mktmp' >&2
    return 1
  }
  local directory
  directory=$(mktemp -d) || return
  echo "$directory" >&2
  cd "$directory" || return
}

if have code; then
  cn() {
    code -n "${1:-.}"
  }
fi

venv() {
  if [ -n "${VIRTUAL_ENV-}" ] && have deactivate; then
    deactivate
  fi

  local here parent name
  here=$PWD
  while :; do
    for name in .venv .env venv env; do
      if [ -r "$here/$name/bin/activate" ]; then
        source "$here/$name/bin/activate"
        echo "Activated $here/$name" >&2
        return
      fi
    done
    parent=$(dirname "$here")
    [ "$parent" = "$here" ] && break
    here=$parent
  done
  echo 'No virtual environment found' >&2
  return 1
}

croot() {
  local root
  root=$(git rev-parse --show-toplevel 2> /dev/null) || return
  cd "$root" || return
}

serve() {
  local port=${1:-8000}
  if have uv; then
    uv run --no-project python -m http.server "$port"
  elif have python3; then
    python3 -m http.server "$port"
  else
    python -m http.server "$port"
  fi
}

cdf() {
  have fd && have fzf || return 1
  local directory
  directory=$(fd -t d . "${1:-.}" -H 2> /dev/null | fzf) || return
  [ -n "$directory" ] && cd "$directory" || return
}

vf() {
  have fd && have fzf || return 1
  local file
  file=$(fd -t f . "${1:-.}" -H 2> /dev/null | fzf) || return
  [ -n "$file" ] && "${EDITOR:-vi}" "$file"
}
