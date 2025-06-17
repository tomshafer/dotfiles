# #!/bin/zsh


# # Local variables
# # --------------------------------------------------------------------
# # ${0:a:h} gets this script's directory [3]
# DF="${0:a:h}"


# # General options
# # --------------------------------------------------------------------
# bindkey -e                      # Emacs mode (like I've used with bash)
# bindkey "^[[3~" delete-char     # Forward delete with Delete [2]


# # Components
# # --------------------------------------------------------------------
# source "$DF/functions.zsh"
# source "$DF/aliases.zsh"
# [[ $(uname) == "Darwin" ]] && source "$DF/macos.zsh"  # macOS only [4]
# source "$DF/completions.zsh"



# # References
# # --------------------------------------------------------------------
# # [2]: https://superuser.com/a/1078653
# # [3]: https://unix.stackexchange.com/a/115431
# # [4]: https://stackoverflow.com/a/54618022

# unset DF
