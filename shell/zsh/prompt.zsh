#! /usr/bin/env zsh
#  Define a baseline prompt configuration.

# Expand PROMPT and RPROMPT
setopt PROMPT_SUBST

autoload -Uz colors && colors  # Enable ZSH color names
autoload -Uz vcs_info          # Enable ZSH VCS info

# Configure VCS display
zstyle ':vcs_info:*' enable                  # Enable for everything
zstyle ':vcs_info:*' check-for-changes true  # Allow checking for repo changes
zstyle ':vcs_info:*' stagedstr "+"           # Plus sign if any staged changes
zstyle ':vcs_info:*' unstagedstr "*"         # Asterisk if any unstaged changes
zstyle ':vcs_info:*' formats "%{$fg[magenta]%}%b%u%c%{$reset_color%}"

# precmd() runs actions before the prompt, collecting VCS details
precmd() {
    vcs_info
}

# LHS prompt is CWD and prompt symbol
PROMPT=$'%{$fg[blue]%}%~%{$reset_color%} %(!.#.$) '

# RHS prompt shows VCS info
RPROMPT='$vcs_info_msg_0_'
