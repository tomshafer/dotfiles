# shellcheck shell=bash
# Aliases shared by Bash and Zsh.

for alias_name in ls l ll la lr; do
    unalias "$alias_name" 2>/dev/null || true
done
unset alias_name

if command -v lsd >/dev/null 2>&1; then
    alias ls='lsd --classify'
elif command ls --color=auto -d . >/dev/null 2>&1; then
    alias ls='command ls -Fh --color=auto'
else
    alias ls='command ls -FGh'
fi
alias l='ls -l'
alias ll='l -A'
alias la='l -a'
alias lr='l -rt'

alias -- -='cd -'
alias ..='cd ..'
alias ...='cd ../..'

alias g=git
alias mkd=mkcd
alias reload='exec "$SHELL" -l'
alias grep='grep --color=auto'
alias path='printf "%s\n" ${PATH//:/\\n}'

if command -v nvim >/dev/null 2>&1; then
    alias vim=nvim
fi
if command -v vim >/dev/null 2>&1; then
    alias vi=vim
fi
if ! command -v bat >/dev/null 2>&1 && command -v batcat >/dev/null 2>&1; then
    alias bat=batcat
fi
if command -v bat >/dev/null 2>&1; then
    alias cat='bat -pp'
fi
if command -v rg >/dev/null 2>&1; then
    alias rgi='rg -i'
fi

case ${OSTYPE-} in
darwin*)
    alias o=open
    alias oo='open .'
    [ -d /Applications/RStudio.app ] && alias rstudio='open -a /Applications/RStudio.app'
    [ -d /Applications/Skim.app ] && alias skim='open -a /Applications/Skim.app'
    ;;
esac
