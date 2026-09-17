#!/usr/bin/env bash
# Rendered by Noctalia from the active palette. The source lives in
# dotfiles/noctalia/templates/openrgb.sh — edit that, not the generated copy.
#
# Applies one accent (the palette's primary role, darkened so it reads as a
# colour instead of washing out to white) to every RGB device OpenRGB manages.
# OpenRGB re-detects all hardware on every invocation and a combined command
# aborts if any named device is absent, so probe once and then set only the
# devices that are present, in a single call.
set -euo pipefail

command -v openrgb >/dev/null 2>&1 || exit 0

accent="{{ colors.primary.default.hex_stripped | darken 15 }}"
dim="{{ colors.primary.default.hex_stripped | darken 70 }}"

present="$(openrgb --list-devices 2>/dev/null)"

args=()
add() { # colour name mode [extra args...]
    grep -qF "$2" <<<"$present" || return 0
    args+=(--device "$2" --mode "$3" --color "$1")
    if [ "$#" -gt 3 ]; then shift 3; args+=("$@"); fi
}

# OpenRGB's --brightness is silently ignored on the ASUS Static and Corsair
# Direct modes, so the in-case devices (motherboard, its ARGB headers and the
# RAM) are dimmed with a darker shade of the same accent instead. OpenRGB has
# no cross-device "solid colour" mode, so each device carries the mode that
# makes it solid; unrecognised devices are left alone.
#
# The Aura controller's addressable RGB headers (where the case fans hang) are
# resizable zones that start empty. Give each one a size covering the fans'
# LED count so the fans take the accent too.
add "$dim"    ASUS     Static --zone 1 --size 30 --zone 2 --size 30 --zone 3 --size 30
add "$dim"    Corsair  Direct  # Vengeance RGB DDR5 DIMMs
add "$accent" Keychron "Solid Color"  # K2 keyboard
add "$accent" G305     Static         # Lightspeed mouse

if [ ${#args[@]} -gt 0 ]; then
    openrgb "${args[@]}"
fi

# The GPU is not an OpenRGB device (OpenRGB has no entry for this exact card),
# but NVIDIA's NVAPI illumination API drives it directly. Set it to the same dim
# shade as the rest of the case when the helper is present.
if [ -x "$HOME/.config/bin/nvapi-illum" ]; then
    "$HOME/.config/bin/nvapi-illum" --color "$dim" --brightness 100
fi
