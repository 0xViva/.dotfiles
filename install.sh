#!/bin/bash

set -e

# Check for OS argument
if [ $# -lt 1 ]; then
  echo "Usage: $0 <OS_TYPE: wsl, macos, arch>"
  exit 1
fi

OS_TYPE=$1
echo "You passed argument: $OS_TYPE"

# Detect platform
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)
        if grep -qi microsoft /proc/version; then
            PLATFORM="WSL"
        else
            PLATFORM="Linux"
        fi;;
    Darwin*) PLATFORM="macOS";;
    *) echo "Unsupported platform: ${unameOut}"; exit 1;;
esac

# Install Homebrew if not already installed
if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew..."

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add brew to PATH for current session
  if [ "$PLATFORM" = "WSL" ] || [ "$PLATFORM" = "Linux" ]; then
    export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  elif [ "$PLATFORM" = "macOS" ]; then
    # Check for Apple Silicon
    if [[ $(uname -m) == 'arm64' ]]; then
      export PATH="/opt/homebrew/bin:$PATH"
      eval "$(/opt/homebrew/bin/brew shellenv)"
    else
      export PATH="/usr/local/bin:$PATH"
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  fi
else
  eval "$(brew shellenv)"
fi

echo "Install everything via Homebrew based on Brewfile..."
brew bundle --file ./brew/Brewfile || true


echo "Check if zsh is already installed..."
if ! command -v zsh >/dev/null 2>&1; then
  echo "zsh not found, installing..."
  sudo apt update
  sudo apt install -y zsh
  ZSH_PATH=$(command -v zsh)
  if ! grep -q "^$ZSH_PATH$" /etc/shells; then
   echo "Adding $ZSH_PATH to /etc/shells..."
   echo "$ZSH_PATH" | sudo tee -a /etc/shells
   echo "change shell to zsh..."
   exec zsh
  fi

  echo "Changing default shell to $ZSH_PATH..."
  chsh -s "$ZSH_PATH"
else
  echo "zsh is already installed."
  echo "change shell to zsh..."
  exec zsh
fi

echo "Cleaning up existing Zsh files..."
rm -f $HOME/.zshrc $HOME/.zshenv $HOME/.zprofile $HOME/.zlogin
zshenv_path="$HOME/.zshenv"
echo 'export ZDOTDIR="$HOME/.dotfiles/zsh"' > "$zshenv_path"
echo "New .zshenv created at $zshenv_path with ZDOTDIR set"

if [[ -z $DOTFILES ]]; then
    DOTFILES="$HOME/.dotfiles"
fi

echo "Set stow folders based on OS $OS_TYPE passed..."
STOW_FOLDERS=$(./OS/${OS_TYPE}) DOTFILES=$DOTFILES ./stow


echo "✅ Done! Your shell is now using zsh with dotfiles."

source $HOME/.dotfiles/zsh/.zshrc
