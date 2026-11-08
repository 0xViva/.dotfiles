# Fish config — the default login shell.
# Environment + PATH (every shell), interactive setup, and tty1 session start.

# ── Environment (every shell) ────────────────────────────────────────────────
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx EDITOR nvim
set -gx DOTFILES $HOME/.dotfiles

# Git discovers ~/.config/git/config natively. Drop any inherited
# GIT_CONFIG_GLOBAL so sessions started before that layout don't point git at
# the removed ~/.config/git/.gitconfig.
if set -q GIT_CONFIG_GLOBAL
    set -e GIT_CONFIG_GLOBAL
end

# fish_add_path prepends and de-dupes; a single call preserves the given order.
fish_add_path --path \
    $HOME/.local/bin \
    $HOME/.config/bin \
    $HOME/bin \
    $HOME/.foundry/bin \
    $HOME/.opencode/bin \
    $HOME/.local/share/solana/install/active_release/bin

if test (uname -s) = Darwin
    fish_add_path --path /Applications/Blender.app/Contents/MacOS
end

# Homebrew (macOS). This stays outside the interactive block so login shells
# that run commands, such as Rex's sessionizer, see brew tools.
if test -x /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv fish | source
end

# Shims precede brew and the system so pinned versions win in every shell.
fish_add_path --path $HOME/.local/share/mise/shims

# ── Login shell on tty1 starts the Wayland session ───────────────────────────
# Runs before the interactive block on purpose: this shell is replaced by
# Hyprland, so it doesn't need mise/starship/fzf set up.
if status is-login; and test -z "$WAYLAND_DISPLAY"; and test (tty) = /dev/tty1
    exec start-hyprland
end

# ── Interactive shells ───────────────────────────────────────────────────────
if status is-interactive
    # Suppress fish's "Welcome to fish" greeting on new shells.
    set -g fish_greeting

    set -gx GIT_EDITOR nvim
    set -gx GPG_TTY (tty)

    # Debian/Ubuntu ship the fd binary as fdfind.
    if grep -qi microsoft /proc/version 2>/dev/null
        alias fd fdfind
    end

    mise activate fish | source

    set -gx STARSHIP_CONFIG $HOME/.config/starship/starship.toml
    if type -q starship
        starship init fish | source
    end

    # Window title = basename of the current directory.
    function fish_title
        path basename $PWD
    end

    source $XDG_CONFIG_HOME/fish/fzf.fish
end
