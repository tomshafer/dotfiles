# Dotfiles

## Configuration flags

- `TRS_PS1_LABEL`: Label in front of the prompt
- `TRS_PS1_NUM_DIRS`: Number of directories to show in prompt
  `pwd` (Zsh only)
- `TRS_PS1_ICON`: Prompt icon
- `TRS_HOMEBREW_DROP_ZSH_FPATH`: Remove Homebrew additions to `fpath` to fix completion issues

## Installing these dotfiles

Best practice, I think:

1. Create the relevant file
2. Source/include system files
3. Source/include my files

For Git, also should set:

- `user.name`
- `user.email`
- `user.signingkey`

#### macOS

TBC

#### Amazon Linux

TBC

## TODO

- Find out whether common environments have global `inputrc`,
  `bashrc`, or `bash_profile` scripts to be included in my
  versions, or what the delivery system should look like
- Figure out where bash-completion is for common environments
  - What typically should be installed for these to be available?
- Look at GPG Agent Forwarding for SSH
- Figure out command- and alt-arrow in inputrc
