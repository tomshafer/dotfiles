#!/bin/zsh

# Aliases
# --------------------------------------------------------------------

# Open applications from the command line
alias o='open'
alias oo='o .'

# Open various macOS-specific applications
for appname in RStudio Skim; do
    apppath="/Applications/${appname}.app"
    if [[ -e $apppath ]]; then
        eval "alias ${appname:l}='open -a \"$apppath\"'"
    fi
done
unset appname apppath
