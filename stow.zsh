#!/usr/bin/env zsh

set -e

pushd "$DOTFILES" >/dev/null || exit 1

for folder in ${(s:,:)STOW_FOLDERS}; do

    case "$folder" in
        zsh)
            target="$HOME"
            ;;
        .ssh)
            target="$HOME/.ssh"
            mkdir -p "$target"
            chmod 700 "$target"
            ;;
        *)
            target="$HOME/.config/$folder"
            ;;
    esac
    mkdir -p "$target"

    echo "processing: $folder -> $target"

    rm -f "$target/.stow"

    if [[ "$folder" == "hypr" ]]; then

        for stub in hyprland.conf hyprland.lua; do
            src="$DOTFILES/$folder/$stub"
            if [[ -f "$target/$stub" && ! -L "$target/$stub" && -f "$src" ]]; then
                rel=$(realpath --relative-to="$target" "$src")
                ln -sfn "$rel" "$target/$stub.new"
                mv -f "$target/$stub.new" "$target/$stub"
            fi
        done
        stow -t "$target" "$folder"

        for link in "$target"/*(N); do
            if [[ -L "$link" ]]; then
                case "$(readlink "$link")" in
                    */".dotfiles/hypr/"*)
                        src="$DOTFILES/$folder/${link:t}"
                        [[ -e "$src" || -L "$src" ]] || rm -f "$link" ;;
                esac
            fi
        done
        continue
    fi

    if [[ "$folder" == "wlogout" ]]; then

        rm -f "$target/style.css"
        stow -t "$target" "$folder"
        rm -f "$target/style.css"
        sed "s|@XDG@|$HOME/.config|g" "$DOTFILES/$folder/style.css" > "$target/style.css"
        continue
    fi

    stow -D -t "$target" "$folder" >/dev/null 2>&1 || true

    stow -t "$target" "$folder"

done

popd >/dev/null
