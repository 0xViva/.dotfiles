#!/usr/bin/env fish
# Stow each folder in $STOW_FOLDERS (comma-separated) into its target.

if not set -q DOTFILES
    echo "stow.fish: DOTFILES is not set" >&2
    exit 1
end
if not set -q STOW_FOLDERS
    echo "stow.fish: STOW_FOLDERS is not set" >&2
    exit 1
end

cd $DOTFILES; or exit 1

for folder in (string split , $STOW_FOLDERS)
    set -l target
    switch $folder
        case .ssh
            set target $HOME/.ssh
            mkdir -p $target; or exit 1
            chmod 700 $target; or exit 1
        case '*'
            set target $HOME/.config/$folder
    end
    mkdir -p $target; or exit 1

    echo "processing: $folder -> $target"

    rm -f $target/.stow

    if test "$folder" = hypr
        for stub in hyprland.conf hyprland.lua
            set -l src $DOTFILES/$folder/$stub
            if test -f $target/$stub; and not test -L $target/$stub; and test -f $src
                set -l rel (realpath --relative-to=$target $src); or exit 1
                ln -sfn $rel $target/$stub.new; or exit 1
                mv -f $target/$stub.new $target/$stub; or exit 1
            end
        end
        stow -t $target $folder; or exit 1

        for link in $target/*
            if test -L $link
                if string match -q '*/.dotfiles/hypr/*' (readlink $link)
                    set -l src $DOTFILES/$folder/(path basename $link)
                    if not test -e $src; and not test -L $src
                        rm -f $link; or exit 1
                    end
                end
            end
        end
        continue
    end

    stow -D -t $target $folder >/dev/null 2>&1; or true

    stow -t $target $folder; or exit 1
end
