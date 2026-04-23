#!/usr/bin/env zsh

set -e

pushd "$DOTFILES" >/dev/null || exit 1

for folder in ${(s:,:)STOW_FOLDERS}; do

    if [[ "$folder" == "zsh" ]]; then
        target="$HOME"
    else
        target="$HOME/.config/$folder"
        mkdir -p "$target"
    fi

    echo "processing: $folder -> $target"

    # safe unstow (ignore failures)
    stow -D -t "$target" "$folder" >/dev/null 2>&1 || true

    # ensure clean reapply
    stow -t "$target" "$folder"

done

popd >/dev/null
