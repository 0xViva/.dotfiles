#!/bin/bash

set -e

DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

if [ $# -lt 1 ]; then
    echo "Usage: $0 <arch|macos|archmac>"
    exit 1
fi
OS_TYPE=$1
case "$OS_TYPE" in
    arch|macos|archmac) ;;
    *)
        echo "Unknown setup: $OS_TYPE (expected arch, macos, or archmac)"
        exit 1
        ;;
esac
echo "Setting up: $OS_TYPE"

yaml_list() {
    awk -v top="$1" -v sec="$2" '
        /^[a-zA-Z][a-zA-Z0-9_-]*:$/ {
            t = $0; sub(/:$/, "", t); s = ""; next
        }
        t == top && /^  [a-zA-Z][a-zA-Z0-9_-]*:$/ {
            x = $0; sub(/^  /, "", x); sub(/:$/, "", x); s = x; next
        }
        t == top && s == sec && /^    - / {
            x = $0; sub(/^    - /, "", x); print x
        }
    ' "$DOTFILES/packages.yaml"
}

get() { yaml_list "$OS_TYPE" "$1"; }

install_packages() {
    case "$OS_TYPE" in
        arch)
            if ! command -v yay >/dev/null 2>&1; then
                echo "Installing yay..."
                sudo pacman -Sy --noconfirm base-devel git
                git clone https://aur.archlinux.org/yay.git /tmp/yay
                pushd /tmp/yay >/dev/null
                makepkg -si --noconfirm
                popd >/dev/null
                rm -rf /tmp/yay
            fi

            yay -S --noconfirm --needed --quiet -- $(get packages) < /dev/null
            sudo systemctl enable --now bluetooth.service

            if [[ -f "$DOTFILES/udev/rules.d/99-keychron.rules" ]]; then
                echo "Installing keychron udev rule..."
                sudo install -m 644 "$DOTFILES/udev/rules.d/99-keychron.rules" /etc/udev/rules.d/99-keychron.rules
                sudo udevadm control --reload-rules
                sudo udevadm trigger
            fi
            ;;

        archmac)
            if [[ ! -d "${OMARCHY_PATH:-/usr/share/omarchy}" ]]; then
                echo "Omarchy not found. Run this on an existing Omarchy install."
                exit 1
            fi
            sudo pacman -S --noconfirm --needed -- $(get packages) < /dev/null
            ;;

        macos)
            if ! command -v brew >/dev/null 2>&1; then
                echo "Installing Homebrew..."
                NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                eval "$(/opt/homebrew/bin/brew shellenv)"
            fi
            brew install --quiet $(get packages)
            ;;
    esac
}

# rex-sessionizer drives the rex CLI. On Arch, the supported installer adds the
# Rex repository and package; on macOS the Rex app is the only installer, so
# there is nothing to do here.
install_rex() {
    [[ "$OS_TYPE" == "arch" ]] || return 0
    command -v rex >/dev/null 2>&1 && return 0

    echo "Installing Rex..."
    command -v curl >/dev/null 2>&1 ||
        sudo pacman -S --noconfirm --needed curl
    curl -fsSL https://pkgs.superlogical.com/rex/install.sh | sh
    command -v rex >/dev/null 2>&1 || {
        echo "Rex install failed; rex-sessionizer needs the rex CLI"
        exit 1
    }
}

# rexpad draws an agent's todo list in a Rex pane. Go installs it into
# ~/.local/bin so a Go upgrade doesn't drop the binary, and the skill goes
# where OpenCode discovers global skills (~/.config/opencode/skills).
install_rexpad() {
    [[ "$OS_TYPE" == "archmac" ]] && return 0

    if ! command -v go >/dev/null 2>&1; then
        echo "rexpad skipped: Go not found. Run 'mise install go', then rerun setup."
        return 0
    fi

    GOBIN="$HOME/.local/bin" go install github.com/almonk/rexpad@latest
    "$HOME/.local/bin/rexpad" skill install --dir "$HOME/.config/opencode/skills"
}

install_packages
install_rex

if ! command -v fish >/dev/null 2>&1; then
    echo "fish not found — make sure the manifest lists fish for $OS_TYPE"
    exit 1
fi

FISH_PATH=$(command -v fish)
if ! grep -q "^$FISH_PATH$" /etc/shells; then
    echo "Adding $FISH_PATH to /etc/shells..."
    echo "$FISH_PATH" | sudo tee -a /etc/shells
fi
echo "Changing default shell to $FISH_PATH..."
chsh -s "$FISH_PATH"

echo "Cleaning up existing Fish config files..."
rm -f "$HOME/.config/fish/config.fish" "$HOME/.config/fish/fish_plugins"

echo "Running stow for OS type: $OS_TYPE..."
STOW_FOLDERS=$(get stow | paste -sd, -) \
    FORCE_STOW=$(get force_stow | paste -sd, -) \
    DOTFILES=$DOTFILES fish "$DOTFILES/stow.fish"

if [[ "$OS_TYPE" != "archmac" ]]; then
    if ! fish -c 'type -q mise'; then
        echo "mise not found. Make sure packages.yaml installs it for $OS_TYPE."
        exit 1
    fi
    echo "Installing mise tools..."
    fish -c 'mise -C "$HOME" install'
    export PATH="$HOME/.local/share/mise/shims:$PATH"
fi

install_rexpad

echo "Installing fish plugins (fisher)..."
fish -c 'fisher update'

echo "Setup gpg-agent..."
fish "$DOTFILES/gpg/setup.fish"
echo "Done! Your shell is now using fish with dotfiles."

if [[ "$OS_TYPE" == "arch" ]]; then
    echo "Setting up systemd user services..."
    systemctl --user daemon-reload
    if [[ -f "$DOTFILES/.env" ]]; then
        systemctl --user enable --now rclone-drive.service
        systemctl --user enable --now rclone-backup.timer
    else
        echo "rclone-drive.service / rclone-backup.timer not started: create $DOTFILES/.env, then run"
        echo "  systemctl --user enable --now rclone-drive.service rclone-backup.timer"
    fi
    if [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
        echo "We're on arch, reload hyprland config after setup."
        # Target the live instance explicitly: the inherited
        # HYPRLAND_INSTANCE_SIGNATURE can point at a dead instance after a restart.
        hyprctl -i 0 reload
    fi
elif [[ "$OS_TYPE" == "archmac" && -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
    echo "Reloading Hyprland config..."
    hyprctl -i 0 reload
fi

exec fish
