#!/usr/bin/env zsh

if [[ -n "$DOTFILES" && -d "$DOTFILES" ]]; then
    pushd "$DOTFILES"
    for folder in ${(s:,:)STOW_FOLDERS}; do
        echo "Removing ~/.config/$folder"
        stow -D -t "$HOME/.config/$folder" "$folder"
    done
    popd
fi

echo "Cleaning up git configuration..."
rm -f $HOME/.gitconfig $HOME/.gitignore_global
rm -rf $HOME/.config/git
unset GIT_CONFIG_GLOBAL GIT_DIR GIT_WORK_TREE

if command -v zb >/dev/null 2>&1; then
    echo "Resetting Zerobrew packages..."
    zb reset 
    echo "Removing Zerobrew installation..."
    rm -rf "$HOME/.zerobrew"  
    export PATH=$(echo $PATH | sed -E 's|:/opt/zerobrew/prefix/bin||g')
fi

if [[ -d "/opt/homebrew" ]] || command -v brew >/dev/null 2>&1; then
    echo "Uninstalling Homebrew..."
    sudo rm -rf /opt/homebrew
    sudo rm -rf /usr/local/Homebrew
    rm -rf ~/Library/Caches/Homebrew
    rm -rf ~/Library/Logs/Homebrew
fi

if command -v mise >/dev/null 2>&1; then
    echo "Removing Mise-managed tools and cache..."
    rm -rf "$HOME/.local/share/mise"
    rm -rf "$HOME/.config/mise"
fi

echo "✅ Environment cleaned. Package managers and dotfiles removed."
exec zsh
