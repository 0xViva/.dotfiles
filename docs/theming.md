# Theming

Everything on the desktop derives from **one Noctalia palette**. Change it in
`noctalia/config.toml` (`[theme]`) or the Noctalia Settings GUI and the whole
system re-themes. See `docs/keybindings.md` for the app-level keybinds.

## Palette source

`[theme].source` picks where the colors come from:

| source | Meaning |
|---|---|
| `builtin` | A shipped palette: `Noctalia`, `Catppuccin`, `Gruvbox`, `Nord`, `Rosé Pine`, `Tokyo-Night`, `Oxocarbon` |
| `wallpaper` | Generated from the current wallpaper (Material You) via `wallpaper_scheme` |
| `community` | A palette from the community catalog (`community_palette`) |
| `custom` | A palette file in `~/.config/noctalia/palettes/` |

Current: `builtin` / `Rosé Pine`.

## How apps follow it

Noctalia's own template engine renders each enabled template from the palette and
writes the result into the app's config:

```
noctalia palette ─▶ template engine ─▶ generated theme file ─▶ app include/theme line
```

Enabled in `noctalia/config.toml` under `[theme.templates]`:

| Template | Generated file | Wired into |
|---|---|---|
| `ghostty` | `~/.config/ghostty/themes/noctalia` | `ghostty/config` (`theme = noctalia`) |
| `btop` | `~/.config/btop/themes/noctalia.theme` | `btop/btop.conf` (`color_theme`) |
| `hyprland` | `~/.config/hypr/noctalia.lua` | `hypr/hyprland.lua` (`require("noctalia")`) |
| `tmux` | `~/.config/tmux/themes/noctalia.conf` | `tmux/tmux.conf` (`source-file`) |
| `fcitx5` | `~/.local/share/fcitx5/themes/noctalia/theme.conf` | `fcitx5/conf/classicui.conf` |
| `neovim` | `~/.config/nvim/lua/matugen.lua` | `nvim/lua/plugins/color.lua` (`require`) |
| `opencode` | `~/.config/opencode/themes/matugen.json` | `opencode/opencode.json` (`theme`) |
| `fzf` | `~/.config/fzf/themes/noctalia.{sh,fish}` | not sourced — see `docs/fish.md` |
| `gtk3`, `gtk4`, `qt` | `~/.config/gtk-*/noctalia.css`, `qt*ct/colors/noctalia.conf` | GTK/Qt apps |

Re-render on demand: `noctalia msg templates-apply`. Templates re-render
automatically whenever the palette changes.

## The "matugen" name

Some generated files are named `matugen` — neovim's `lua/matugen.lua`, opencode's
`themes/matugen.json` — and the neovim module is required as `require('matugen')`.
That name is inherited from the template ecosystem they were adapted from: matugen
is a separate theming tool, and the neovim template keeps matugen's module name
and its `SIGUSR1` reload convention.

**matugen is not installed and not used here** — Noctalia's own engine renders
the files. Renaming them would mean vendoring the upstream templates and losing
their updates, so the inherited name is kept and documented instead.

## config.toml vs the GUI

`~/.config/noctalia/*.toml` (this repo) is the base layer. The Settings GUI writes
`~/.local/state/noctalia/settings.toml`, which loads last and wins. Tune a key in
one place or the other, not both — and if a file edit seems ignored, check
`settings.toml` for an override.
