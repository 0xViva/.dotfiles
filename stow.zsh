#!/usr/bin/env zsh

pushd "$DOTFILES" || exit 1

for folder in ${(s:,:)STOW_FOLDERS}; do
    if [[ "$folder" == "zsh" ]]; then
        target="$HOME"
    else
        target="$HOME/.config/$folder"
        mkdir -p "$target"
    fi

    echo "stow $folder -> $target"
    stow -D -t "$target" "$folder"
    stow -t "$target" "$folder"
done

popd
