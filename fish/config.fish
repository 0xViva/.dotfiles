# Fish config — the default login shell. See docs/fish.md.
# Environment + PATH (every shell), interactive setup, and tty1 session start.

# ── Environment (every shell) ────────────────────────────────────────────────
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx EDITOR nvim
set -gx DOTFILES $HOME/.dotfiles

# fish_add_path prepends and de-dupes; a single call preserves the given order.
fish_add_path --path \
    $HOME/.local/bin \
    $HOME/bin \
    $HOME/.foundry/bin \
    $HOME/.opencode/bin \
    $HOME/.local/share/solana/install/active_release/bin

if test (uname -s) = Darwin
    fish_add_path --path /Applications/Blender.app/Contents/MacOS
end

# ── Login shell on tty1 starts the Wayland session ───────────────────────────
# Runs before the interactive block on purpose: this shell is replaced by
# Hyprland, so it doesn't need mise/starship/fzf set up.
if status is-login; and test -z "$WAYLAND_DISPLAY"; and test (tty) = /dev/tty1
    exec start-hyprland
end

# ── Interactive shells ───────────────────────────────────────────────────────
if status is-interactive
    set -gx GIT_CONFIG_GLOBAL $HOME/.config/git/.gitconfig
    set -gx GIT_EDITOR nvim
    set -gx GPG_TTY (tty)

    # Homebrew (macOS). Naming the shell avoids brew's unreliable detection.
    if test -x /opt/homebrew/bin/brew
        /opt/homebrew/bin/brew shellenv fish | source
    end

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

    set -g TMUX_SESSIONIZER $DOTFILES/bin/tmux-sessionizer
    bind ctrl-p 'commandline -i "$TMUX_SESSIONIZER"; commandline -f execute'
end
