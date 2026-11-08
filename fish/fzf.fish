# fzf prompt widgets — pick paths from the whole machine.
# Sourced from fish/config.fish inside the interactive guard.
# The fzf.fish plugin owns CTRL+ALT+F (current directory); these are the
# whole-machine pickers restored from the old zsh config.

# The Noctalia-generated theme (themes/noctalia.fish) is deliberately NOT sourced:
# it uses `set -Ux`, so sourcing it every shell appends the palette repeatedly and
# storing it as a universal would defeat re-theming.

# One fd invocation for every whole-machine picker, so the exclude list stays
# in sync. $base is a directory, $kind is fd's type (f or d).
function _fzf-candidates --argument-names base kind
    fd "" $base --type $kind --hidden \
        --exclude .rustup \
        --exclude .cargo \
        --exclude .cache \
        --exclude go \
        --exclude .zen \
        --exclude .npm \
        2>/dev/null
end

# CTRL+F: insert a file path from /.
function fzf-file-widget
    set -l file (_fzf-candidates / f | fzf --exact +m)
    test -n "$file"; or return
    commandline -i -- (string escape -- $file)
    commandline -f repaint
end

# CTRL+D: insert a directory path from $HOME.
function fzf-directory-widget
    set -l dir (_fzf-candidates $HOME d | fzf --exact +m)
    test -n "$dir"; or return
    commandline -i -- (string escape -- $dir)
    commandline -f repaint
end

# CTRL+E: pick a file from / and open it in nvim.
function fzf-edit-widget
    set -l file (_fzf-candidates / f | fzf --exact +m)
    test -n "$file"; or return
    nvim $file
    or return
    commandline -f repaint execute
end

bind ctrl-d fzf-directory-widget
bind ctrl-e fzf-edit-widget
bind ctrl-f fzf-file-widget
