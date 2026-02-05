# Dotfiles

## Requirements

- **Shell configuration:** Bash 3.2+ or Zsh
- **Utility scripts (`bin/`):** Bash 3.2+ (uses `[[ ]]` and similar features)

## Configuration flags

- `TRS_PS1_LABEL`: Label in front of the prompt
- `TRS_PS1_NUM_DIRS`: Number of directories to show in prompt
  `pwd` (Zsh only)
- `TRS_PS1_ICON`: Prompt icon
- `TRS_HOMEBREW_DROP_ZSH_FPATH`: Remove Homebrew additions to `fpath` to fix completion issues

## Local overrides

If you want machine-specific or private settings, create a local file at:

`~/.config/dotfiles/local.sh`

This file is optional and not tracked. It is loaded at the end of both
`shell/zsh/zshrc` and `shell/bash/bashrc`, so it can override defaults.
Examples: work git identity, extra PATH entries, proxies, secrets.

## SSH configuration

This repo ships shared SSH defaults at `~/.config/dotfiles/ssh/config`.
To use them, add the following to your per-machine `~/.ssh/config`:

```sshconfig
Include ~/.config/dotfiles/ssh/config
Include ~/.ssh/config.local
```

Then keep your host entries in `~/.ssh/config` or `~/.ssh/config.local`
as you prefer.

An example local config is provided at:

`config/dotfiles/ssh/config.local.example`

### 1Password agent (macOS)

Enable the 1Password SSH agent, then set `IdentityAgent` in
`~/.ssh/config.local` using the socket path shown in `$SSH_AUTH_SOCK`:

```sshconfig
Host *
    IdentityAgent "$SSH_AUTH_SOCK"
    AddKeysToAgent no
```

### Without 1Password

Use `IdentityFile` entries and optional agent settings in
`~/.ssh/config.local`, for example:

```sshconfig
Host *
    AddKeysToAgent yes
```

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
