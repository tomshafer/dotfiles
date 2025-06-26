# shellcheck shell=bash

######################################################################
# Add PATH entries, skipping duplicates.
# Globals:
#   PATH
# Arguments:
#   New candidate entry to PATH.
# Outputs:
#   None.
######################################################################
add_to_path() {
    if [[ -d "$1" && ":$PATH:" != *":$1:"* ]]; then
        PATH="$1:$PATH"
    fi
}

# Homebrew and binaries
add_to_path "/opt/homebrew/bin"
add_to_path "/usr/local/bin"

# npm
add_to_path "$HOME/.npm-packages/bin"

# User binaries
add_to_path "$HOME/.local/bin"
add_to_path "$HOME/bin"

export PATH
