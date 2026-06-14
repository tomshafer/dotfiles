# Dotfiles

Small configurations for a Zsh/Neovim workstation or a Bash/Vim server.

## Install

Install the workstation profile:

```sh
./install
```

This installs the common configuration, adds `shell/zshrc` to `~/.zshrc`,
adds the minimal `shell/zshenv` to `~/.zshenv`, and links the Neovim config.

Install the server profile:

```sh
./install server
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

The Zsh setup follows the fast DIY++ ordering from `zsh-bench`:

- global startup files are disabled from `.zshenv`
- Powerlevel10k instant prompt loads before normal initialization
- completion metadata and generated tool integrations are cached
- `zsh-autosuggestions` uses one-time widget binding
- Powerlevel10k handles Git status asynchronously

Plugins are optional and discovered from Homebrew, common system paths, or
`$XDG_DATA_HOME/zsh`. The expected local layout is:

```text
~/.local/share/zsh/powerlevel10k/
~/.local/share/zsh/zsh-autosuggestions/
```

An existing `~/.p10k.zsh` is used when present. Otherwise the small default at
`shell/p10k.zsh` is loaded.

On macOS, disabling global startup files avoids `/etc/zprofile` invoking
`path_helper` and `/etc/zshrc` rebuilding defaults this config replaces. The
shared environment reads `/etc/paths` and `/etc/paths.d` directly so installed
tool paths are retained without spawning `path_helper`.

Machine-specific settings go in one optional file:

```text
~/.config/dotfiles/local.sh
```

It is sourced by both shells after shared aliases and functions, but before
completion and optional tools. Portable settings can be written normally; use
shell guards for shell-specific settings:

```sh
add_to_path "$HOME/work/bin"
export PATH

if [ -n "${ZSH_VERSION-}" ]; then
    fpath=("$HOME/work/zsh/site-functions" $fpath)
fi

alias work='cd "$HOME/work"'
```

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
