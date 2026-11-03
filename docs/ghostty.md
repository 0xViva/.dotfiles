# Ghostty: vim-flavoured keys & where Rex fits

Answers up front, details below:

- **Vim-like keys?** Yes — a small set, see the block below. Do *not* blindly map
  `alt+hjkl` or `ctrl+shift+v`; the section after the config explains why.
- **Do you need tmux?** No. Rex is the session manager; Ghostty is the window.
- **Must they coexist?** Yes, they nest naturally (ghostty → Rex) and never fight.
  The *only* overlap is split management: use **one** split plane — Rex blocks,
  so leave ghostty splits out of your routine.

---

## Vim-flavoured keybindings (paste-ready for `ghostty/config`)

Ghostty ≥1.3 already ships several vim-spirit defaults:

- `ctrl+shift+e` = `new_split:down` (≈ vim `<C-w>s`)
- `ctrl+shift+o` = `new_split:right` (≈ vim `<C-w>v`)
- `ctrl+shift+enter` = `toggle_split_zoom` (≈ full-zoom the split)
- `ctrl+alias` tab jumps via `alt+1..9`

The one gap is **navigation**: defaults use `ctrl+alt+arrows` / `super+ctrl+[ ]`.
These five lines give real vim keys instead:

```ini
# Vim-flavoured split navigation (mirrors <C-w>h/j/k/l in nvim)
keybind = ctrl+shift+j=unbind                                     # defaults to write_screen_file:paste
keybind = ctrl+shift+h=goto_split:left
keybind = ctrl+shift+j=goto_split:down
keybind = ctrl+shift+k=goto_split:up
keybind = ctrl+shift+l=goto_split:right
```

Result: `ctrl+shift` + `h/j/k/l` to fly between splits — the same muscle memory as
nvim's `C-w h/j/k/l`, which your `set.lua` already maps.

### Keyspace safety (why these keys and not others)

| Chord | Verdict | Why |
|-------|---------|-----|
| `ctrl+shift+h/k/l` | ✅ use | unbound by ghostty 1.3.1, unbound by this stack's Rex/nvim/fish/hyprland |
| `ctrl+shift+j` | repurpose | default is `write_screen_file:paste` (nobody uses it) — unbind then take it |
| `alt+h/j/k/l` | ❌ | `alt+j/k` = vim scroll by C-f/C-b; ghosts into nvim. Would steal them |
| `ctrl+shift+v` | ❌ | Linux paste default, and your most-used copy/paste muscle memory |
| `alt+^/alt+*` | ❌ | `alt` is Hyprland/AeroSpace territory at the WM layer; nothing visible in the terminal |
| `super+…` | ❌ | owned by Hyprland (and lookup-key on macOS) |

`ctrl+shift+…` is the one freely-enterable keyspace in this stack: ghostty owns it,
nothing below (Rex has no `ctrl+shift`, nvim/fish only use plain `ctrl`, Hyprland has
no `ctrl+shift` binds). That is where all five lines live.

---

## Why Rex instead of tmux?

Rex provides the session model tmux did — named sessions, windows (tabs), and
blocks (panes) — but as a server/client system: the server keeps sessions
running, and the app or CLI attaches to them. The project switcher is
`rex-sessionizer` (`C-p` or `C-a f`), and it opens directories or existing
sessions.

```
Hyprland          composes/handles your windows
  └─ ghostty      is the terminal: rendering, scrollback, tabs
      └─ Rex      is the session manager: windows, persistence, sessionizer
          └─ fish / nvim   do their own thing inside a Rex block
```

The one place they *redundantly* overlap is **splits** (ghostty splits, Rex
blocks, nvim windows all do this). Running two layers of splits is how you end
up fighting "which `h` goes to which pane". Policy that keeps it simple:

- **nvim windows** — for entering/changing code layout (you already do this).
- **Rex blocks** — for multi-process layouts (editor + shell + logs side by side).
- **ghostty splits** — don't create them; use ghostty **tabs** as an extra
  container level if you want one. `alt+1..9`/`tab` keys navigate them already.

---

## Optional power-ups (already built in)

- **`ctrl+shift+enter`** — `toggle_split_zoom`: focus a split into full area, tap again to restore.
- **`ctrl+shift+p`** — command palette: search & run every ghostty action, pickers, config.
- **`ctrl+shift+page_up/down`** — `jump_to_prompt`: leap between shell prompts (needs shell
  integration). Note: your config sets `shell-integration-features = no-cursor` **and then**
  `shell-integration-features = ssh-env` on a *second* line — the last line wins, so you may
  currently have only the SSH behaviour. If prompt-jumping does nothing, merge them:
  `shell-integration-features = no-cursor,ssh-env`.
- **Quake terminal caveat**: ghostty's `toggle_quick_terminal` only fires while ghostty
  itself is running/focused on Linux (`global:` binds are macOS-only). On Hyprland, a real
  system-wide drop-down is better done with a Hyprland scratchpad (bind a key to
  `togglespecialworkspace`, point it at a ghostty on-created-empty).

---

## Config reference

- Option + syntax: <https://ghostty.org/docs/config/keybind>
- Full action list: <https://ghostty.org/docs/config/keybind/reference>
- Inspect your live defaults anytime: `ghostty +list-keybinds --default`