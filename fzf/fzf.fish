# fzf prompt widget — pick a file and open it in nvim.
# Sourced from fish/config.fish inside the interactive guard.
# File/directory search comes from the fzf.fish plugin (CTRL+ALT+F).

# The Noctalia-generated theme (themes/noctalia.fish) is deliberately NOT sourced:
# it uses `set -Ux`, so sourcing it every shell appends the palette repeatedly and
# storing it as a universal would defeat re-theming. See docs/fish.md.

function fzf-edit-widget
    set -l file (fd "" / --type f --hidden \
        --exclude .rustup \
        --exclude .cargo \
        --exclude .cache \
        --exclude go \
        --exclude .zen \
        --exclude .npm \
        2>/dev/null | fzf --exact +m)
    test -n "$file"; or return
    nvim $file
    or return
    commandline -f repaint execute
end

bind ctrl-e fzf-edit-widget
