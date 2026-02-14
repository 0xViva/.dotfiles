#!/usr/bin/env zsh

pushd "$DOTFILES"

for folder in ${(s:,:)STOW_FOLDERS}; do
    if [[ "$folder" == "tmux" ]]; then
        echo "stow $folder -> $HOME"
        stow -D "$folder"
        stow "$folder"
    else
        echo "stow $folder -> ~/.config/$folder"
        mkdir -p "$HOME/.config/$folder"
        stow -D -t "$HOME/.config/$folder" "$folder"
        stow -t "$HOME/.config/$folder" "$folder"
    fi
done

popd
