# Dotfiles

Small configurations for a Zsh/Neovim workstation or a Bash/Vim server.

## Install

Install the workstation profile:

```sh
./install.sh
```

This installs the common configuration, adds `shell/zshrc` to `~/.zshrc`,
and links the Neovim config.

Install the server profile:

```sh
./install.sh server
```

This installs the same common configuration and utilities, adds `shell/bashrc`
to `~/.bashrc`, and links `inputrc` and the plugin-free Vim config. Bash,
inputrc, and Vim are installed only by this profile.

The installer preserves existing shell files by appending one idempotent source
line. It refuses to replace other existing configuration files or links.

## Shell layout

Both Bash and Zsh source:

- `shell/common/env.sh`: PATH and exported environment
- `shell/common/aliases.sh`: shared aliases
- `shell/common/functions.sh`: shared helper functions
- `shell/common/tools.sh`: optional `uv`, `fzf`, `zoxide`, `direnv`, and NVM setup

If an optional tool is installed, it is initialized in either shell. Completion,
history, prompts, keybindings, and shell options remain in `shell/bashrc` and
`shell/zshrc` because their implementations are shell-specific.

Machine-specific settings can go in:

```text
~/.config/dotfiles/local.sh
```

It is sourced last by both shells.

Prompt settings:

- `TRS_PS1_LABEL`: optional label before the prompt
- `TRS_PS1_NUM_DIRS`: number of path components to show
- `TRS_PS1_ICON`: prompt character

## SSH

Shared SSH defaults are installed at `~/.config/dotfiles/ssh/config`. Include
them from `~/.ssh/config`:

```sshconfig
Include ~/.config/dotfiles/ssh/config
Include ~/.ssh/config.local
```

Keep host and machine-specific settings in `~/.ssh/config.local`.

## Checks

```sh
just check
```
