# dotfiles

Minimal, opinionated dotfiles managed with [GNU stow](https://www.gnu.org/software/stow/).
One manifest, one command, three setups: Arch, Arch on Mac, macOS.

## Install

```bash
./setup.sh <arch|macos|archmac>
```

Installs system packages from `packages.yaml`, stows configs, installs CLI
tools with `mise`, and sets up fish (the default shell). Safe to re-run. Every
step is idempotent.

`archmac` layers config onto an existing Omarchy 4.5 install (x86_64 or Apple
Silicon). Omarchy keeps its packages, mise tooling and desktop defaults; this
repo replaces only the user config files those things load. The custom Arch and
Noctalia setup is not brought over. Hyprland gets `input.lua`, `looknfeel.lua`
and `bindings.lua` from `hypr-mac/`, on top of Omarchy's own defaults.

## Structure

```
setup.sh          # entry point: system packages → stow → mise install
packages.yaml     # system packages + stow targets per OS
mise/config.toml  # user CLI tool versions, installed by setup after stow
stow.fish         # symlink targets: .ssh→~/.ssh, hypr*→~/.config/hypr, rest→~/.config/<name>
bin/              # helper scripts (stowed to ~/.config/bin, on PATH via fish)
docs/             # human notes (pstack setup)
rclone/           # non-secret rclone settings (secrets live in the gitignored .env)
<config dirs>/    # one stowed folder per app (hypr, noctalia, nvim, rex, …)
```

## Package management

`packages.yaml` owns system packages and AUR packages. That covers the desktop,
fish, stow, git, gpg, systemd integration, and rclone because the user service
calls `/usr/bin/rclone`. `mise/config.toml` owns user CLI tools, with pinned or
`latest` versions. On Arch and macOS, `setup.sh` runs `mise install` after
stowing; Omarchy keeps its own mise tooling. Fish puts the
mise shims on PATH before the tty1 session starts, so keybindings and scripts
see the same tools as an interactive shell.

## Config inventory

Every tracked dir is either stowed above, or deliberate:
`docs/` = human notes (not stowed), `gpg/` = setup script run by `setup.sh`,
`udev/` = root-installed rule, `rclone/` = settings env read by the mount
service and `rclone-backup` (secrets live in the gitignored `.env`; see
`.env.example`).

Fresh machine: clone the repo and run setup. The package manager installs fish,
stow, git, gpg, and mise; setup installs the rest of the CLI tools.
