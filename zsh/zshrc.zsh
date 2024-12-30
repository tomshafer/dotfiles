#!/bin/zsh


# Local variables
# --------------------------------------------------------------------
# ${0:a:h} gets this script's directory [3]
DF="${0:a:h}"


# General options
# --------------------------------------------------------------------
setopt AUTO_CD                  # Change dirs without `cd`
setopt NO_BEEP                  # Do not beep the terminal [1]

bindkey -e                      # Emacs mode (like I've used with bash)
bindkey "^[[3~" delete-char     # Forward delete with Delete [2]


# Components
# --------------------------------------------------------------------
source "$DF/functions.zsh"
source "$DF/aliases.zsh"

# macOS only [4]
if [[ $(uname) == "Darwin" ]]; then
    source "$DF/macos.zsh"
fi

source "$DF/completions.zsh"


# Misc
# --------------------------------------------------------------------
# Use bat for paging [5]
if command -v bat > /dev/null; then
    export MANPAGER="sh -c 'col -bx | bat -l man -p --pager=\"less -RF\"'"
else 
    export MANPAGER="less -X"
fi


# References
# --------------------------------------------------------------------
# [1]: https://dev.to/rossijonas/how-to-set-up-history-based-autocompletion-in-zsh-k7o
# [2]: https://superuser.com/a/1078653
# [3]: https://unix.stackexchange.com/a/115431
# [4]: https://stackoverflow.com/a/54618022
# [5]: https://github.com/sharkdp/bat?tab=readme-ov-file#man

unset DF
