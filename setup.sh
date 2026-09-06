#!/bin/bash

set -e

DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

if [ $# -lt 1 ]; then
    echo "Usage: $0 <arch|macos|wsl>"
    exit 1
fi
OS_TYPE=$1
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

            yay -S --noconfirm --needed --quiet -- $(get packages) $(get aurs) < /dev/null
            sudo systemctl enable --now bluetooth.service

            if [[ -f "$DOTFILES/udev/rules.d/99-keychron.rules" ]]; then
                echo "Installing keychron udev rule..."
                sudo install -m 644 "$DOTFILES/udev/rules.d/99-keychron.rules" /etc/udev/rules.d/99-keychron.rules
                sudo udevadm control --reload-rules
                sudo udevadm trigger
            fi
            ;;

        macos)
            if ! command -v brew >/dev/null 2>&1; then
                echo "Installing Homebrew..."
                NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                eval "$(/opt/homebrew/bin/brew shellenv)"
            fi
            brew install --quiet $(get packages)
            ;;

        wsl)
            sudo apt update
            sudo apt install -y $(get packages)
            ;;
    esac
}

install_packages

if ! command -v zsh >/dev/null 2>&1; then
    echo "zsh not found — make sure the manifest lists zsh for $OS_TYPE"
    exit 1
fi

ZSH_PATH=$(command -v zsh)
if ! grep -q "^$ZSH_PATH$" /etc/shells; then
    echo "Adding $ZSH_PATH to /etc/shells..."
    echo "$ZSH_PATH" | sudo tee -a /etc/shells
fi
echo "Changing default shell to $ZSH_PATH..."
chsh -s "$ZSH_PATH"

echo "Cleaning up existing Zsh config files..."
rm -f $HOME/.zshrc $HOME/.zshenv $HOME/.zprofile $HOME/.zlogin

echo "Running stow for OS type: $OS_TYPE..."
STOW_FOLDERS=$(get stow | paste -sd, -) DOTFILES=$DOTFILES ./stow.zsh

echo "Setup gpg-agent..."
source "$DOTFILES/gpg/setup.zsh"
echo "Done! Your shell is now using zsh with dotfiles."

if [[ "$OS_TYPE" == "arch" ]]; then
    echo "Setting up systemd user services..."
    systemctl --user daemon-reload
    elephant service enable
    echo "We're on arch, reload hyprland config after setup."
    hyprctl reload
fi

exec zsh
