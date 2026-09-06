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

    # drop stale stow marker so the target dir can never be silently skipped
    rm -f "$target/.stow"

    if [[ "$folder" == "hypr" ]]; then
        # hyprland writes a default stub the moment hyprland.conf goes missing,
        # and a running session then writes that stub *through* the recreated
        # symlink straight into the repo, replacing the real config.
        # `stow -D` unlinks the config for a moment, so skip unstow entirely:
        # swap any conflicting stub for a symlink atomically (rename), which
        # never empties the path, then let plain `stow` (re)install.
        for stub in hyprland.conf hyprland.lua; do
            src="$DOTFILES/$folder/$stub"
            if [[ -f "$target/$stub" && ! -L "$target/$stub" && -f "$src" ]]; then
                rel=$(realpath --relative-to="$target" "$src")
                ln -sfn "$rel" "$target/$stub.new"
                mv -f "$target/$stub.new" "$target/$stub"
            fi
        done
        stow -t "$target" "$folder"

        # prune repo-owned links whose source no longer exists (replaces the
        # stale-link cleanup `stow -D` used to do)
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
        # style.css is a template (@XDG@ → real config path). Materialize it
        # as a real file so no username ever leaks into the repo.
        rm -f "$target/style.css"
        stow -t "$target" "$folder"
        rm -f "$target/style.css"
        sed "s|@XDG@|$HOME/.config|g" "$DOTFILES/$folder/style.css" > "$target/style.css"
        continue
    fi

    # safe unstow (ignore failures)
    stow -D -t "$target" "$folder" >/dev/null 2>&1 || true

    # ensure clean reapply
    stow -t "$target" "$folder"

done

popd >/dev/null
