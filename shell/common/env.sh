# shellcheck shell=bash

# Do we have a given command?
command -v have >/dev/null 2>&1 || have() { command -v "$1" >/dev/null 2>&1; }

if have nvim; then
  export EDITOR=nvim VISUAL=nvim
elif have vim; then
  export EDITOR=vim VISUAL=vim
fi

export LESS=-RF
export LESSHISTFILE=-

export PAGER=less
export MANPAGER='less -R'

export LSCOLORS=exfxcxdxbxegedabagacadah
: "${LS_COLORS:=di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43}"
export LS_COLORS
