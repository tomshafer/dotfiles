# shellcheck shell=sh
# Common aliases

# Remove unwanted preset aliases -------------------------------------

# I've seen these on various remote systems
for alias in ls ll l la lt lr xx l2; do
    [ "$(command -v "$alias" | cut -d ' ' -f 1)" = "alias" ] && unalias "$alias"
done

# Listing ------------------------------------------------------------

# Use lsd if available, otherwise use builtin ls
if command -v lsd >/dev/null 2>&1; then
    alias ls="lsd -Fg"
else
    alias ls="command ls -Fh --color=auto"
fi

alias l="ls -l"
alias ll="l -A"
alias la="l -a"
alias lr="l -rt"
alias lt="l -t"

# Navigation ---------------------------------------------------------

alias -- -='cd -'
alias ..='cd ..'
alias ...='cd ../..'

# Miscellany ---------------------------------------------------------

# Git
alias g="git"

# Fix systems where `bat` is called `batcat`
if ! command -v bat >/dev/null && command -v batcat >/dev/null; then
    alias bat='batcat'
fi
