#!/bin/zsh

# Define the path to your dotfiles directory
DOTFILES_DIR="$HOME/.dotfiles"

# Check if the dotfiles directory exists
if [[ ! -d "$DOTFILES_DIR" ]]; then
  echo "Dotfiles directory not found at $DOTFILES_DIR"
  exit 1
fi

# Clean up .DS_Store files in the dotfiles directory
echo "Cleaning up .DS_Store files..."
find "$DOTFILES_DIR" -name ".DS_Store" -exec rm -f {} \;

# Iterate over all directories in the dotfiles directory
for dir in "$DOTFILES_DIR"/*/; do
  # Ensure it's a directory before running stow
  if [[ -d "$dir" ]]; then
    dir_name=$(basename "$dir")
    echo "Stowing $dir_name..."
    
    # Use stow with --adopt to avoid conflict with existing files
    stow --adopt "$dir_name"
    
    if [[ $? -ne 0 ]]; then
      echo "Failed to stow $dir_name"
    else
      echo "$dir_name stowed successfully!"
    fi
  fi
done

echo "All stow operations completed!"

