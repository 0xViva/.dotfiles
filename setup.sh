#!/bin/bash

set -e

# Check for OS argument
if [ $# -lt 1 ]; then
    echo "Usage: $0 <OS_TYPE: wsl, macos, arch>"
    exit 1
fi

OS_TYPE=$1
echo "You passed argument: $OS_TYPE"

source "./OS/$OS_TYPE"

if [[ "$OS_TYPE" == "arch" ]]; then
    if ! command -v yay >/dev/null 2>&1; then
        echo "Installing yay..."
        sudo pacman -Sy --noconfirm base-devel git
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        pushd /tmp/yay
        makepkg -si --noconfirm
        popd
        rm -rf /tmp/yay
    fi

    yay -S --noconfirm --needed --quiet "${PACKAGES[@]}" < /dev/null
    sudo systemctl enable --now bluetooth.service

elif [[ "$OS_TYPE" == "wsl" ]]; then
    sudo apt update
    sudo apt install -y "${PACKAGES[@]}"
elif [[ "$OS_TYPE" == "macos" ]]; then
    if ! command -v zb >/dev/null 2>&1; then
        echo "Installing zerobrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/lucasgelfond/zerobrew/main/install.sh)"
    fi

    if ! command -v brew >/dev/null 2>&1; then
        echo "Installing Homebrew..."
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    PACKAGES=($(grep -vE '^\s*(#|$)' "./macos.packages"))
    MISSING_FROM_ZB=()

    echo "🚀 Processing packages..."
    for pkg in "${PACKAGES[@]}"; do
        if zb install "$pkg" >/dev/null 2>&1; then
            echo "✅ $pkg (zerobrew)"
        else
            MISSING_FROM_ZB+=("$pkg")
        fi
    done

    echo "📦 Installing core/missing packages via Homebrew..."
    brew install stow gnupg "${MISSING_FROM_ZB[@]}"

    export PATH="/opt/homebrew/bin:/opt/zerobrew/prefix/bin:$PATH"
    echo "🔄 Refreshing PATH for current session..."
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    export PATH="/opt/homebrew/bin:/opt/zerobrew/prefix/bin:$PATH"

    if ! command -v stow >/dev/null 2>&1; then
        echo "❌ Error: stow still not found in PATH. Checking /opt/homebrew/bin..."
        ls /opt/homebrew/bin/stow
    fi
fi

#mise install

# Zsh installation and setup
echo "Check if zsh is already installed..."
if ! command -v zsh >/dev/null 2>&1; then
    echo "zsh missing"
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

if [[ -z $DOTFILES ]]; then
    DOTFILES="$HOME/.dotfiles"
fi

echo "Running stow for OS type: $OS_TYPE..."
STOW_FOLDERS=$STOW_FOLDERS DOTFILES=$DOTFILES ./stow.zsh

echo "Setup gpg-agent..."
source "$DOTFILES/gpg/setup.zsh"
echo "✅ Done! Your shell is now using zsh with dotfiles."

if [[ "$OS_TYPE" == "arch" ]]; then
    echo "We're on arch, reload hyprland config after setup."
    hyprctl reload
fi

exec zsh
