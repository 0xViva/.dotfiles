# Keybindings Map

This document maps every keybinding in the dotfiles, split by operating system, and
explains how the layers stack when two programs want the same key.

Sources: `hypr/bindings/*.lua`, `tmux/tmux.conf`, `ghostty/config`,
`aerospace/aerospace.toml`, `zsh/.zshrc`, `fzf/fzf.zsh`, `nvim/lua/`, `winterm/settings.json`.

---

## Systems covered

| OS | Tiling WM / compositor | Terminal app | Multiplexer | Shell | Editor |
|----|------------------------|--------------|-------------|-------|--------|
| **Arch (Linux)** | Hyprland | ghostty | tmux | zsh | Neovim |
| **macOS** | AeroSpace | ghostty | tmux | zsh | Neovim |
| **Windows (WSL)** | Windows Terminal (no WM — native Windows) | Windows Terminal + WSL | (tmux available but unused) | zsh | Neovim |

`macos` && `wsl` configs are installed by `./setup.sh <arch|macos|wsl>`; `winterm/` is
reference-only for the Windows side of a WSL setup.

### The layer model — who wins a keypress

Keys are grabbed in priority order. A lower layer never sees a key the higher layer owns:

```
1. OS / WM (Hyprland on Arch, AeroSpace on macOS, Windows on Windows)
2. App window
3. Terminal emulator (ghostty / Windows Terminal)
4. tmux (prefix C-a)
5. Shell (zsh ZLE)
6. Editor (Neovim)
```

Practical implication: **`SUPER`/`CMD` and `ALT`/`Option` are reserved by the window layer
unless a program configures them back.** Everything unmodified, `Ctrl`, and `Shift+Ctrl`
flows down to the app, tmux, shell, and editor.

---

## Arch / Linux — Hyprland

```
SUPER = "Super" (Windows) key — reserved for Hyprland
ALT    = "Alt" key — reserved for Hyprland
```

### Hyprland — launch / apps
| Keys | Action |
|------|--------|
| `SUPER + SPACE` | Launch apps (walker) |
| `SUPER + RETURN` | Terminal (ghostty) |
| `SUPER + SHIFT + F` | File manager (nautilus `--new-window`) |
| `SUPER + B` | Browser (zen-browser) |
| `SUPER + N` | Editor (ghostty -e nvim) |

### Hyprland — windows & tiling
| Keys | Action |
|------|--------|
| `SUPER + Q` | Close window |
| `SUPER + J` | Toggle split direction (dwindle) |
| `SUPER + P` | Pseudo-tile |
| `SUPER + T` | Toggle floating / tiled |
| `SUPER + F` | Fullscreen |
| `SUPER + CTRL + F` | "Tiled fullscreen" (window stays in layout, client goes fullscreen) |
| `SUPER + ALT + F` | Full width (maximize) |
| `SUPER + ← ↑ → ↓` | Move focus |
| `SUPER + SHIFT + ← ↑ → ↓` | Swap window |
| `SUPER + ALT + ← ↑ → ↓` | Join window into group |
| `SUPER + CTRL + ← →` | Move focus inside group |
| `SUPER + ALT + TAB` / `SUPER + ALT + SHIFT + TAB` | Next / previous group window |
| `SUPER + ALT + 1..5` | Activate group window by index |
| `SUPER + ALT + scroll` | Next / previous group window |
| `SUPER + G` | Toggle group |
| `SUPER + ALT + G` | Leave group |
| `SUPER + mouse LMB` / `RMB` (hold+drag) | Move / resize window |
| `SUPER + -` / `SUPER + =` | Resize window (left/right) |
| `SUPER + SHIFT + -` / `SUPER + SHIFT + =` | Resize window (up/down) |
| `SUPER + scroll` | Switch workspace forward / backward |
| `ALT + TAB` | Cycle window **and** raise it to top |
| `ALT + SHIFT + TAB` | Cycle window backwards, raise to top |

Workspace shortcuts use physical keycodes (`code:10`–`code:19` = `1`…`0`), which makes
them layout-independent — this is why they keep working on the Norwegian (`no`) layout.

### Hyprland — workspaces
| Keys | Action |
|------|--------|
| `SUPER + 1..0` | Switch to workspace |
| `SUPER + SHIFT + 1..0` | Move window to workspace |
| `SUPER + SHIFT + ALT + 1..0` | Move window to workspace (silently, don't follow) |
| `SUPER + TAB` / `SUPER + SHIFT + TAB` / `SUPER + CTRL + TAB` | Next / previous / former workspace |
| `SUPER + SHIFT + ALT + ← →` | Move workspace to left / right monitor |
| `SUPER + S` | Toggle scratchpad |
| `SUPER + ALT + S` | Move window to scratchpad |
| Workspace 1 lives on **DP-2**; scratchpad opens a terminal on first use |

### Hyprland — system & media
| Keys | Action |
|------|--------|
| `SUPER + L` | Lock (hyprlock) |
| `SUPER + CTRL + N` | Toggle nightlight (hyprsunset via `cmd-toggle-nightlight`) |
| `PRINT` | Screenshot + edit |
| `SHIFT + PRINT` | Screenshot to clipboard |
| `SUPER + PRINT` | Color picker (hyprpicker) |
| `ALT + PRINT` | Start screen recording (with audio) |
| `SUPER + ALT + PRINT` | Stop recording |
| `SUPER + ,` / `SUPER + SHIFT + ,` / `SUPER + CTRL + ,` / `SUPER + ALT + ,` | Dismiss last / dismiss all / toggle DND / invoke last notification |
| `SUPER + SHIFT + ALT + ,` | Restore last notification |
| `XF86AudioRaise/Lower/Mute`, `XF86AudioMicMute`, `XF86MonBrightnessUp/Down` | Volume / bright-with OSD (locked + auto-repeat; `ALT` variant = ±1%) |
| `XF86AudioNext/Play/Pause/Prev` | playerctl transport via swayosd |
| `ALT + RETURN` binding note | none — media only |

Waybar (top bar) is clickable: workspaces activate on click, `CPU`→btop, `network`→impala,
`pulseaudio`→wiremix, `bluetooth`→bluetui.

---

## Arch / Linux — inside the terminal (ghostty → tmux → zsh → nvim)

### ghostty (terminal emulator)
Only one custom binding; everything else is stock:

| Keys | Action |
|------|--------|
| `SHIFT + ENTER` | Send `ESC + CR` (custom; used to accept in fzf/tmux instead of inserting newline) |
| `CTRL + SHIFT + C` / `CTRL + SHIFT + V` | Copy / paste (stock) |
| `CTRL + SHIFT + T` / `CTRL + SHIFT + D` | New tab / split (stock) |
| `CTRL + =` / `CTRL + -` / `CTRL + 0` | Zoom in / out / reset (stock) |

### tmux
Prefix is **`C-a`** (changed from the default `C-b`). `set -g prefix C-a`.
On `C-a` in a pane, VM-mode navigation uses `hjkl` (dwm-style):

| Keys | Action |
|------|--------|
| `C-a` `C-a` | Send a literal `Ctrl-A` to the app (e.g. bash line-start) |
| `C-a` `r` | Reload `~/.tmux.conf` |
| `C-a` `j/k/h/l` | Select pane down/up/left/right |
| `C-a` `^` | Go to last window |
| `C-a` `f` | New window + `tmux-sessionizer` (fuzzy project picker) |
| `C-a` `M-h/M-t/M-n/M-s` | New window + sessionizer scoped to search path slot 0–3 |
| `C-a` `[` | Enter copy-mode; then `v` select, `y` copy (+xclip to clipboard) |
| `C-a` `m` | Mouse mode (already on via `set -g mouse on`) |

Terminal pacing: `escape-time 0` (fast prefix); `base-index 1`; windows start at 1.

### zsh (ZLE) — shell keybindings
| Keys | Action |
|------|--------|
| `CTRL + F` | fzf file picker (insert path) |
| `CTRL + D` | fzf directory picker (insert path) — **rebound from EOF** |
| `CTRL + E` | fzf + edit result in nvim |
| `CTRL + P` | tmux sessionizer (new tmux window) |
| `CTRL + T` | **deliberately unbound** (`bindkey -r '^T'`, `unbind` in fzf) — see conflicts |

### Neovim
Leader is **`SPACE`**. Notable bindings:
| Keys | Action |
|------|--------|
| `ESC` | Clear search highlight |
| `CTRL + H/J/K/L` | Move between split windows |
| `CTRL + F` | Open `tmux-sessionizer` in a new tmux window (**shadows** nvim's page-forward) |
| `SPACE` `tf` / `SPACE` `tF` | Toggle autoformat (buffer / global) |
| `-` | Open parent directory (oil) |
| `q` | Focus diagnostics/quickfix (auto-closes if empty) |
| `SPACE` `sf` `ss` `sg` `sw` `sh` `sk` `sd` `sr` `sn` `s/` etc. | Telescope: files, picker, live-grep, word, help, keymaps, diagnostics, resume, nvim config, grep-open-files |
| `SPACE` `SPACE` | Fuzzy-find buffers |
| `SPACE` `/` | Fuzzy search in current buffer |
| `C-HJKL` in oil | split / horizontal / tab-select file, refresh, etc. |

---

## macOS — AeroSpace

```
OPT (Option/⌥) = reserved for AeroSpace     CMD (⌘) = reserved by macOS itself
FN + top row   = F-keys (macOS media keys by default — see conflicts)
```

| Keys | Action |
|------|--------|
| `OPT + ENTER` | (commented out in config — uncomment to open Terminal) |
| `OPT + T` | Open **wezterm** ⚠ (see conflicts — dotfiles otherwise standardize on ghostty) |
| `OPT + F` | Fullscreen |
| `OPT + /` | Toggle tiles / accordion layout |
| `OPT + ,` | Toggle accordion orientation |
| `OPT + ← ↑ → ↓` | Focus window in direction |
| `OPT + SHIFT + ← ↑ → ↓` | Move window in direction |
| `OPT + SHIFT + -` / `OPT + SHIFT + =` | Resize (shrink / grow) |
| `OPT + SHIFT + C` | Reload AeroSpace config |
| `OPT + TAB` | Back-and-forth workspace |
| `OPT + SHIFT + TAB` | Move workspace to next monitor |
| `F1..F9` | Switch workspace 1–9 |
| `SHIFT + F1..F9` | Move window to workspace |
| `OPT + SHIFT + ;` | Enter "service" mode |
| In service mode: `ESC` exit · `r` reset layout · `f` floating/tiling · `backspace` close all but current · `OPT + SHIFT + arrows` join-with |

Startup: sketchybar + jankyborders autostart; **zen-browser → workspace 1**, **ghostty →
workspace 2** automatically (`on-window-detected`).

Inside the terminal on macOS, the stack is the same as Arch (ghostty → tmux → zsh → nvim),
with the notes below about `Option` being stolen.

---

## Windows / WSL — Windows Terminal

There is no WM layer; Windows Terminal owns keys first. Reference config in `winterm/`.

| Keys | Action |
|------|--------|
| `CTRL + T` | Duplicate tab |
| `CTRL + C` | Copy (terminal-wide) |
| `CTRL + V` | Paste (terminal-wide) |
| `CTRL + SHIFT + F` | Find |
| `ALT + D` | Split pane |
| `ALT + Z` | Close pane |
| `ALT + 1..6` | Switch to tab |
| `CTRL + ALT + 1..6` | (disabled — `null` entries) |
| `CTRL + SHIFT + W` | Close (tab) |

The WSL "Ubuntu" profile runs zsh → uses the same zsh/nvim keybindings as above, minus
everything `ALT`/`Ctrl` combos the terminal swallows (see conflicts).

---

## Conflict analysis

### 1. tmux prefix `C-a` vs. shell "start of line" — **real, by design, workaround exists**
`C-a` is the tmux prefix **and** readline/zsh's default "jump to start of line".
Because `escape-time = 0`, a *lone* `C-a` passes through quickly, but any `C-a <key>` is
tmux. To type a literal `C-a` inside a tmux pane: **press `C-a C-a`**.

### 2. AeroSpace `Option + arrows` vs. terminal word-motion — **real, unavoidable on macOS**
In any terminal (ghostty, Terminal.app) `Option+Left/Right` means *jump word* and
`Option+Up/Down` means *history search* in readline/zsh. AeroSpace owns all four, so on
macOS you **lose word-wise cursor movement** in the shell. Alternatives: `Esc`-prefixed
binds (`ESC b` / `ESC f` / `ESC p/n`) or re-binding `CTRL+arrows` in `.zshrc`.

### 3. Windows Terminal `ALT` grabs — **real, only on Windows**
`ALT+D` (delete-word / split pane), `ALT+Z` (close pane), and `ALT+1..6` (switch tab) are
consumed by Windows Terminal **before** zsh sees them. In the WSL shell those zsh/readline
defaults (`M-d` kill-word, etc.) are dead. Same story as #2, different OS.

### 4. `CTRL+V` — paste vs. quoted-insert — **behavior differs per terminal**
Windows Terminal: `CTRL+V` = paste (stolen). ghostty: `CTRL+V` reaches zsh = *quoted-insert*
(literal next char). Same keystroke, opposite meaning depending on which terminal you're in.

### 5. `CTRL+T` — deliberately unbound in zsh — **resolved, but with an inconsistency**
zsh unbinds `^T` (`bindkey -r '^T'`) because Windows Terminal uses it for tabs. Result:
in Windows Terminal pressing `CTRL+T` does nothing thank goodness, but in ghostty it also
does nothing (zsh level), even though ghostty would happily deliver it.

### 6. Neovim `CTRL+F` — **real shadowing, nvim-internal**
`set.lua` re-binds `CTRL+F` (default: page forward in normal mode) to launch
`tmux-sessionizer`. Page-forward is still available via `CTRL+D`/`CTRL+U`.

### 7. Hyprland `ALT + TAB` steals from apps — **by design**
On Linux, `ALT+TAB`/`ALT+SHIFT+TAB` are Hyprland's (cycle + raise). No app in the stack
relies on `ALT+TAB`, so nothing is lost — it is *philosophically* borrowed from apps that
would like it (rare on Linux terminals).

### 8. `caps:escape` + Neovim's `<CapsLock>` mapping — **dead config**
Hyprland remaps CapsLock→Esc at the XKB level, so a `CapsLock` key never reaches nvim.
The `CapsLock → Esc` mappings in `nvim/lua/set.lua:103–105` are therefore dead code
(keep them only as a fallback for SSH/macOS).

### 9. AeroSpace `OPT+T` opens wezterm — **likely stale**
The dotfiles standardize on **ghostty**; on macOS the launch binding points at wezterm.
If you don't use wezterm on macOS, change to `open -a Ghostty` (or `exec-and-forget ghostty`).

### 10. AeroSpace `F1..F9` vs. macOS media keys — **hardware friction**
macOS ships the top row as media keys; `F1..F9` only reach AeroSpace if your keyboard
sends real F-keys (e.g. `Fn` mapping, or **System Settings → Keyboard → "Use F1, F2, …
as standard function keys"** on a MacBook). External keyboards (Keychron via `Fn1` toggle)
usually send real F-keys by default.

### 11. tmux `escape-time 0` — **tradeoff, generally fine**
Instant prefix response, but a fast `ESC <key>` in vim can occasionally be misread. This
is the standard modern setting.

### 12. Hyprland media keys win over app-level media — **by design**
`XF86Audio*`/`XF86MonBrightness*` are grabbed with `repeating` + `locked`, so apps that
register their own media handling won't fire; the OSD + increments you see come from Hyprland.

### Non-issues worth internalizing (why your stack feels clean)
- **tmux prefix is `C-a`, not `C-b`** → nvim's `CTRL+W`/`CTRL+H J K L` window commands
  never hit the tmux prefix. This is the classic reason people abandon `C-b`.
- **ghostty uses `CTRL+SHIFT+…`** → no overlap with Hyprland's `SUPER`, nvim's `CTRL`,
  or tmux's `C-a` prefix.
- **Hyprland uses physical keycodes for workspaces** → immune to the Norwegian layout.
- **zsh `^F/^D/^E` only exist at the shell level** → nvim/tmux don't use them; no clash.

---

## Memory hooks per OS

| OS | Big picture |
|----|-------------|
| Arch | **`SUPER` does everything Hyprland** (windows, workspaces, system). Everything else lives `C-*` under nvim/tmux/zsh. |
| macOS | **`⌥` (Option) is your WM**, `⌘` is macOS, `F1-F9` workspaces. Shell word-motion moves to `ESC b/f`. |
| Windows | **Windows Terminal owns `CTRL+V`, `ALT+D`, `ALT+Z`, `ALT+1-6`, `CTRL+T`**; in the WSL shell prefer `SPACE`/`C-a`/unmodified keys. |