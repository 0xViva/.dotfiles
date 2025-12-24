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
  sudo systemctl --user enable --now elephant

elif [[ "$OS_TYPE" == "wsl" ]]; then
  sudo apt update -y
  sudo apt install -qq -y "${PACKAGES[@]}"
  sudo apt autoremove -qq
  curl -sS https://ohmyposh.dev/install.sh | bash -s >/dev/null

elif [[ "$OS_TYPE" == "macos" ]]; then
  if ! command -v brew >/dev/null 2>&1; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Apple Silicon vs Intel
        if [[ $(uname -m) == 'arm64' ]]; then
          eval "$(/opt/homebrew/bin/brew shellenv)"
        else
          eval "$(/usr/local/bin/brew shellenv)"
        fi
      else
        eval "$(brew shellenv)"
      fi

      echo "Installing packages from Brewfile..."
      brew bundle --file ./brew/Brewfile || true

fi

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

# Cleanup old zsh config
echo "Cleaning up existing Zsh config files..."
rm -f $HOME/.zshrc $HOME/.zshenv $HOME/.zprofile $HOME/.zlogin

# Set ZDOTDIR via .zshenv
zshenv_path="$HOME/.zshenv"
echo 'export ZDOTDIR="$HOME/.dotfiles/zsh"' > "$zshenv_path"
echo "New .zshenv created at $zshenv_path"

# Set DOTFILES location
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


