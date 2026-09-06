# dotfiles

Minimal, opinionated dotfiles managed with [GNU stow](https://www.gnu.org/software/stow/).
One manifest, one command, three OSes.

## Install

```bash
./setup.sh <arch|macos|wsl>
```

Installs packages from `packages.yaml`, sets up zsh, and stows configs.
Safe to re-run — every step is idempotent.

## Structure

```
setup.sh          # entry point: read packages.yaml → install → stow
packages.yaml     # single source of truth: packages + aurs + stow per OS
stow.zsh          # symlink targets: zsh→$HOME, .ssh→~/.ssh, rest→~/.config/<name>
bin/              # helper scripts (~/.config/bin, on PATH via hypr/waybar)
docs/             # keychron, AI stack, webtools notes
<config dirs>/    # one stowed folder per app (hypr, waybar, nvim, tmux, …)
```

## Config inventory

Every tracked dir is either stowed above, or deliberate:
`gpg/` = setup script sourced by `setup.sh`, `udev/` = root-installed rule,
`winterm/` = Windows-side reference only.

Fresh machine: get `setup.sh` + `packages.yaml` (or clone the repo) and run it —
no manual steps beyond your package manager.