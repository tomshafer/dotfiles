#! /usr/bin/env zsh
#  Better/longer history settings
#  https://www.reddit.com/r/zsh/comments/wy0sm6/comment/ilujd15/
#  https://www.reddit.com/r/zsh/comments/wy0sm6/comment/l44blcd/

HISTFILE=$HOME/.zsh_history
HISTSIZE=2000000                # Current session history limit
SAVEHIST=1000000                # Save this many lines upon shell exit

setopt APPEND_HISTORY           # Append to the history file
setopt EXTENDED_HISTORY         # Write in ':start:elapsed;command' format
setopt HIST_EXPIRE_DUPS_FIRST   # Expire dups first when trimming history
setopt HIST_FIND_NO_DUPS        # Do not display a previously found event
setopt HIST_IGNORE_ALL_DUPS     # Delete old event if a new event is a duplicate
setopt HIST_IGNORE_DUPS         # Do not record an event that was just recorded again
setopt HIST_IGNORE_SPACE        # Do not record an event starting with a space
setopt HIST_SAVE_NO_DUPS        # Do not write a duplicate event to the history file
setopt INC_APPEND_HISTORY_TIME  # Update history file as soon as command is done
