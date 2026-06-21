# shellcheck shell=bash
# Aliases shared by Bash and Zsh.

# Shortcut for checking commands
if ! command -v have > /dev/null 2>&1; then
  have() {
    command -v "$1" > /dev/null 2>&1
  }
fi

# Remove unwanted preset aliases
for a in ls ll l la lt lr xx l2; do
  unalias "$a" 2> /dev/null
done
unset a

# Listing
alias l="ls -l"
alias ll="l -A"
alias la="l -a"
alias lr="l -rt"

# Prefer lsd if available, then set flags by OS
if have lsd; then
  alias ls="lsd --classify"
elif [[ $OSTYPE == darwin* ]]; then
  alias ls="command ls -FGh"
else
  alias ls="command ls -Fh --color=auto"
fi

# Navigation
alias -- -="cd -"
alias ..="cd .."
alias ...="cd ../.."

# Git
alias g="git"

# use 'mkd' instead of 'mkcd'
alias mkd="mkcd"

# Fix systems where `bat` is called `batcat`
if ! have bat && have batcat; then
  alias bat="batcat"
fi

# Alias `cat` to `bat`
if have bat; then
  alias cat="bat"
fi

# Reload the shell
alias reload='exec "$SHELL" -l'

# Use color with grep
alias grep="grep --color=auto"

# ripgrep in case-insensitive mode
if have rg; then
  alias rgi="rg -i"
fi

# Pretty print paths
alias path='printf "%s\n" ${PATH//:/\\n}'

# macOS
if [[ $OSTYPE == darwin* ]]; then
  # Open applications from the command line
  alias o='open'
  alias oo='o .'

  # Open various macOS-specific applications
  [[ -d /Applications/RStudio.app ]] && alias rstudio='open -a "/Applications/RStudio.app"'
  [[ -d /Applications/Skim.app ]] && alias skim='open -a "/Applications/Skim.app"'
fi
