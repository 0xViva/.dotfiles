#!/bin/zsh
YABAI_BIN="/opt/homebrew/bin/yabai"
if pgrep -x "yabai" >/dev/null && ! "$YABAI_BIN" -m query --scripting-addition 2>/dev/null | grep -q '"loaded": true'; then
  sudo "$YABAI_BIN" --load-sa
fi
