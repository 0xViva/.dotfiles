#!/bin/zsh

# Define the path to your dotfiles directory
DOTFILES_DIR="$HOME/dotfiles"

# Check if the dotfiles directory exists
if [[ ! -d "$DOTFILES_DIR" ]]; then
  echo "Dotfiles directory not found at $DOTFILES_DIR"
  exit 1
fi

# Iterate over all directories in the dotfiles directory
for dir in "$DOTFILES_DIR"/*/; do
  # Ensure it's a directory before running stow
  if [[ -d "$dir" ]]; then
    dir_name=$(basename "$dir")
    echo "Stowing $dir_name..."
    stow "$dir_name"
  fi
done

echo "All stow operations completed!"

