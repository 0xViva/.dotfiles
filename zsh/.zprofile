if [[ -z $WAYLAND_DISPLAY && $(tty) == /dev/tty1 ]]; then
    exec Hyprland
fi

export PATH="/Users/august/.local/share/solana/install/active_release/bin:$PATH"
