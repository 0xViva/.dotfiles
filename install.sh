#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 <pass OS_TYPE: WSL, MacOS, Arch>"
  exit 1
fi

OS_TYPE=$1
echo "You passed argument: $ARG"

echo "Install Homebrew if not already installed"
if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$(brew shellenv)"

if ! command -v zsh >/dev/null 2>&1; then
  echo "Installing zsh via Homebrew..."
  brew install zsh
fi
echo "Install everything via Homebrew based on Brewfile..."
brew bundle --file ./brew/Brewfile
NEW_ZSH_PATH="$(brew --prefix)/bin/zsh"

if ! grep -q "^${NEW_ZSH_PATH}$" /etc/shells; then
  echo "Adding ${NEW_ZSH_PATH} to /etc/shells..."
  echo "${NEW_ZSH_PATH}" | sudo tee -a /etc/shells
fi

echo "Changing default shell to Homebrew-installed zsh..."
chsh -s "${NEW_ZSH_PATH}"

echo "Done! Your default shell is now zsh."
echo "Remove all existing .zsh files and use .dotfiles zsh files..."
rm -f $HOME/.zshrc $HOME/.zshenv $HOME/.zprofile $HOME/.zlogin
zshenv_path="$HOME/.zshenv"
echo 'Export ZDOTDIR="$HOME/.dotfiles/zsh"' > "$zshenv_path"
echo "new .zshenv created at $zshenv_path with ZDOTDIR set to ~/.dotfiles/zsh"
echo "Set dotfiles dir to $HOME/.dotfiles."
if [[ -z $DOTFILES ]]; then
    DOTFILES=$HOME/.dotfiles
fi
echo "Set stow folders based on OS $OS_TYPE passed."
STOW_FOLDERS=$(./OS/${OS_TYPE}) DOTFILES=$DOTFILES ./stow
