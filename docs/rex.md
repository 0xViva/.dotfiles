# Rex

Rex config is split in two, and only one half belongs in this repo.

| What | Where | In dotfiles? |
|------|-------|--------------|
| Keybindings, key modes, custom actions | `~/.config/rex/init.lua` | Yes — `rex/init.lua`, stowed |
| App appearance, font, cursor, panes, close confirmation | Rex Settings, saved in `~/Library/Preferences/com.superlogical.rex.plist` | No — per-Mac app state |

The plist cannot be set from `init.lua`, and symlinking it into the repo is
not supported: macOS rewrites it through `cfprefsd`, so the link would be
replaced or the app would read a stale copy. Set those options in the app and
repeat them on each Mac.

## Ghostty → Rex

`ghostty/config` is the reference for the terminal look. The Rex app has a
built-in Ghostty import (see below), but these are the values to check.

| Ghostty | Rex equivalent | Notes |
|---------|----------------|-------|
| `theme = noctalia` | Settings → Themes | Noctalia generates Ghostty's built-in **Rose Pine** palette exactly. Pick Rose Pine (dark) if Rex ships it; otherwise use **Import Theme File** and choose the Ghostty theme file. |
| `font-family = JetBrainsMono Nerd Font Mono` | Settings → Terminal → Font Family | The font must also be installed on the Mac. |
| `font-size = 14` | Settings → Terminal → Font Size | |
| `background-opacity = 0.80` | Settings → Appearance → background opacity / glass | Rex may express this as opacity rather than transparency. |
| `window-padding-x/y = 14` | Settings → Appearance → panes | No exact Ghostty cell-padding equivalent; the comfortable pane style is the closest match. |
| `cursor-style = block` | Settings → Terminal → Cursor | |
| `cursor-style-blink = false` | Settings → Terminal → Cursor blink | |
| `confirm-close-surface = false` | Settings → General → close confirmation | |
| `resize-overlay = never` | — | No Rex equivalent. |
| `gtk-toolbar-style = flat` | — | Linux Ghostty only; the Rex client is macOS. |
| `shell-integration-features = no-cursor,ssh-env` | — | Rex provides its own shell integration; nothing to set. |
| `clipboard-read/write = allow` | — | The app uses the macOS clipboard directly. |
| `keybind = shift+enter=text:\x1b\r` | — | Ghostty-specific. Leave Rex's app defaults unless a TUI needs the ESC+CR sequence. |
| `keybind = performable:super+c/v/a` | — | Rex already uses the standard macOS Cmd+C/V/A shortcuts. |

## Walkthrough

1. Open the command palette with <kbd>Cmd</kbd>+<kbd>Shift</kbd>+<kbd>P</kbd>.
2. Run **Open Onboarding Session…** and look for the Ghostty
   import/migration step. It covers theme, appearance, and keybindings, and is
   the supported way to copy what Ghostty exposes.
3. Compare the result against the table above in **Settings…**, then adjust
   anything the import left alone.
4. If the theme is not exact, run **Import Theme File** and pick the Ghostty
   theme file. Imported themes are stored in the app plist, so repeat the
   import on every Mac.

Keybindings that need to differ from the app defaults go in `rex/init.lua`;
`rex config check` validates them and `rex config reload` applies them.
