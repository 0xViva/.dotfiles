# dotfiles

Minimal, opinionated dotfiles managed with [GNU stow](https://www.gnu.org/software/stow/).
One manifest, one command, two OSes.

## Install

```bash
./setup.sh <arch|macos>
```

Installs packages from `packages.yaml`, sets up fish (the default shell), and
stows configs. Safe to re-run — every step is idempotent.

## Structure

```
setup.sh          # entry point: read packages.yaml → install → stow
packages.yaml     # single source of truth: packages + aurs + stow per OS
stow.fish         # symlink targets: .ssh→~/.ssh, rest→~/.config/<name>
bin/              # helper scripts (~/.config/bin, on PATH via hypr/noctalia)
docs/             # keybindings, theming, ghostty/tmux, nvim, keychron, AI stack, webtools, rclone notes
rclone/           # non-secret rclone settings (secrets live in the gitignored .env)
<config dirs>/    # one stowed folder per app (hypr, noctalia, nvim, tmux, …)
```

## Config inventory

Every tracked dir is either stowed above, or deliberate:
`gpg/` = setup script run by `setup.sh`, `udev/` = root-installed rule,
`rclone/` = settings env read by the mount service and `rclone-backup`
(secrets live in the gitignored `.env`; see `.env.example`).

Fresh machine: get `setup.sh` + `packages.yaml` (or clone the repo) and run it —
no manual steps beyond your package manager.