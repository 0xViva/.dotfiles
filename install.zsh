#!/bin/zsh

DOTFILES_DIR="$HOME/.dotfiles"

if [[ ! -d "$DOTFILES_DIR" ]]; then
  echo "Dotfiles directory not found at $DOTFILES_DIR"
  exit 1
fi

echo "Cleaning up .DS_Store files..."
find "$DOTFILES_DIR" -name ".DS_Store" -exec rm -f {} \;

for dir in "$DOTFILES_DIR"/*/; do
  if [[ -d "$dir" ]]; then
    dir_name=$(basename "$dir")
    echo "Stowing $dir_name..."
    
    stow --adopt "$dir_name"
    
    if [[ $? -ne 0 ]]; then
      echo "Failed to stow $dir_name"
    else
      echo "$dir_name stowed successfully!"
    fi
  fi
done

echo "All stow operations completed!"

