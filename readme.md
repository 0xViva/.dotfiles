# dotfiles

Minimal, opinionated dotfiles managed with [GNU stow](https://www.gnu.org/software/stow/).
One manifest, one command, two setups: Arch and macOS.

## Install

```bash
./setup.sh <arch|macos>
```

Installs system packages from `packages.yaml`, stows configs, installs CLI
tools with `mise`, and sets up fish (the default shell). Safe to re-run. Every
step is idempotent.

On the Apple Silicon machine, `arch` sees the hardware layer at
`/usr/share/omarchy` and uses the archmac manifest instead: the same Hyprland +
Noctalia setup as plain Arch, on the Apple Silicon hardware layer. The manifest
lists the packages the dotfiles need; Chromium and Alacritty stand in for Zen
and Ghostty, which have no Arch Linux ARM packages outside the hardware layer's
repo. SDDM starts `bin/hyprland-session` directly (no uwsm or vendor session
entry) and uses the stock `maya` theme; Plymouth uses `bgrt`. The hardware layer
stays installed for its kernel, firmware and boot packages, but none of its
desktop config starts: `bin/archmac-system-setup` installs the native session
and stock themes, and setup masks the extra desktop user services. Update the
hardware stack with `hardware-update` (keyrings, system packages, boot
verification) instead of the full desktop update, which would migrate the
desktop config and restart its shell. Noctalia handles idle/lock
(`noctalia/config.toml`); a small user service follows AC/battery changes using
`powerprofilesctl` directly.

## Structure

```
setup.sh          # entry point: system packages → stow → mise install
packages.yaml     # system packages + stow targets per OS
mise/config.toml  # user CLI tool versions, installed by setup after stow
stow.fish         # symlink targets: .ssh→~/.ssh, hypr→~/.config/hypr, rest→~/.config/<name>
bin/              # helper scripts (stowed to ~/.config/bin, on PATH via fish)
docs/             # human notes (pstack setup)
rclone/           # non-secret rclone settings (secrets live in the gitignored .env)
<config dirs>/    # one stowed folder per app (hypr, noctalia, nvim, rex, …)
```

## Package management

`packages.yaml` owns system packages and AUR packages. That covers the desktop,
fish, stow, git, gpg, systemd integration, and rclone because the user service
calls `/usr/bin/rclone`. `mise/config.toml` owns user CLI tools, with pinned or
`latest` versions. On plain Arch and macOS, `setup.sh` runs `mise install`
after stowing. Arch Linux ARM has no `mise` package, so archmac installs only
the upstream CLI into `~/.local/bin`; the hardware layer's tool config is left
alone. Fish puts the mise shims on PATH before the tty1 session starts, so
keybindings and scripts see the same tools as an interactive shell.

## Config inventory

Every tracked dir is either stowed above, or deliberate:
`docs/` = human notes (not stowed), `gpg/` = setup script run by `setup.sh`,
`udev/` = root-installed rule, `rclone/` = settings env read by the mount
service and `rclone-backup` (secrets live in the gitignored `.env`; see
`.env.example`). `hypr/` is stowed on Arch and read in place on archmac.
Fresh machine: clone the repo and run setup. The package manager installs fish,
stow, git, gpg, and mise; setup installs the rest of the CLI tools.
