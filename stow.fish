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

# Replace a package's existing target files with relative symlinks so stow can
# take over config files that another installer created.
function adopt_conflicts --argument-names folder target
    for src in $DOTFILES/$folder/**
        test -f $src; or continue
        set -l dst $target/(string replace "$DOTFILES/$folder/" "" $src)
        test -f $dst; or continue
        test -L $dst; and continue
        # A symlinked target directory can place $dst inside the repo itself.
        test (realpath -m $dst) != (realpath -m $src); or continue
        mkdir -p (path dirname $dst); or exit 1
        set -l link (realpath --relative-to=(path dirname $dst) $src); or exit 1
        ln -sfn $link $dst.new; or exit 1
        mv -f $dst.new $dst; or exit 1
    end
end

set -l force_folders
if set -q FORCE_STOW
    set force_folders (string split , $FORCE_STOW)
end

for folder in (string split , $STOW_FOLDERS)
    set -l target
    switch $folder
        case .ssh
            set target $HOME/.ssh
            mkdir -p $target; or exit 1
            chmod 700 $target; or exit 1
        case hypr
            set target $HOME/.config/hypr
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
                if string match -q "$DOTFILES/$folder/*" (realpath -m $link)
                    set -l src $DOTFILES/$folder/(path basename $link)
                    if not test -e $src; and not test -L $src
                        rm -f $link; or exit 1
                    end
                end
            end
        end
        continue
    end

    if contains -- $folder $force_folders
        adopt_conflicts $folder $target
    end

    stow -D -t $target $folder >/dev/null 2>&1; or true

    stow -t $target $folder; or exit 1
end
