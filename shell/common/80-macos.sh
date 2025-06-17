# shellcheck shell=sh
# macOS-specific configurations.

# Aliases ------------------------------------------------------------

# Open applications from the command line
alias o='open'
alias oo='o .'

# Open various macOS-specific applications
for appname in RStudio Skim; do
    apppath="/Applications/${appname}.app"

    if [ -e $apppath ]; then
        lowername=$(echo "$appname" | tr '[:upper:]' '[:lower:]')
        eval "alias $lowername='open -a \"$apppath\"'"
    fi
done
unset appname apppath lowername
