# Ghostty + Rex + nvim: workflow and keybindings

How the layers hand the keyboard to each other, and how to use the
configured keybindings (`ghostty/config`, `rex/init.lua`,
`rex/rex-sessionizer.conf`, `fish/config.fish`, `fish/fzf.fish`,
`nvim/lua/set.lua`).

## The layering model

One keyboard, four owners. The app that currently has focus owns the keys;
the others pass them through:

```
Ghostty (outer window)  →  Rex (prefix C-a)  →  fish (prompt)  or  nvim
```

- Ghostty only intercepts what you bind in `ghostty/config`. There are no
  split/zoom binds here — it is a pure pass-through layer.
- Rex only intercepts keys that start a configured sequence (currently `C-a`).
  Plain keys go to the app inside.
- fish/fzf bindings only apply while the shell prompt is focused.
- nvim bindings only apply while an nvim window is focused.

So the same chord can mean different things in different apps — that is the
system working, not a bug.

## Ghostty layer

Almost nothing is rebound; the config only sets:

- `shift+enter` → sends `\x1b\r` (`ghostty/config:39`) — lets TUI apps distinguish
  Shift+Enter from Enter. Only matters for programs that read the raw byte.
- `shell-integration-features = no-cursor` + `ssh-env` — disables cursor
  glyph-reflow tricks and carries the terminfo over SSH. Leave these alone.

Practical upshot: **Ghostty never eats your chords**, so every binding below
reaches Rex or the app directly. The window manages itself via your WM — Rex
provides the tabs, splits, and sessions inside it.

## Rex layer

Rex is the session manager: sessions hold windows (tabs), which hold blocks
(panes). The server keeps sessions running whether or not a client is looking
at them.

The custom bindings live in `rex/init.lua`:

| Binding | Action |
|---------|--------|
| `C-a` `f` | New Rex window running `rex-sessionizer` |

Rex's own defaults handle tabs, splits, focus, the command palette, and the
built-in session switcher (`cmd+k`). The `rex` CLI exposes the same operations
for scripts: `rex run`, `rex split`, `rex focus`, `rex window`, `rex block`.

### Sessionizer entry points

The project switcher is reached three ways:

| Where              | Binding        | Effect                                            |
|--------------------|----------------|---------------------------------------------------|
| anywhere in Rex    | `C-a f`        | new Rex window running `rex-sessionizer`          |
| fish prompt        | `C-p`          | runs `rex-sessionizer` in-place (`config.fish`)   |
| nvim normal mode   | `C-f`          | new Rex window with `rex-sessionizer` (`set.lua`) |

## fish (prompt-only bindings)

Active only at the shell prompt (`fish/fzf.fish` + the fzf.fish plugin):

- `C-p` — rex-sessionizer
- `C-e` — fzf file picker from `/`, then *opens the file in nvim*
- `C-Alt-f` — fzf directory search (cwd; prefix `/` for the whole machine)
- `C-r` — fzf history
- `C-Alt-l` / `C-Alt-s` — fzf git log / git status
- `C-v` / `C-Alt-p` — fzf variables / processes

## nvim layer

Already covered in depth in `docs/nvim.md`; the parts that interact with the
terminal:

- `C-h/j/k/l` — move between nvim windows. Rex handles the outer blocks with
  its own bindings; inside nvim, Rex doesn't see these keys.
- `C-f` (normal) — opens the Rex sessionizer in a new Rex window. Your fastest
  "go work on another project" move from inside an editor.
- `q` — buffer diagnostics loclist (not macro recording, see `docs/nvim.md`).

## Putting it together: one work session

1. Open Rex (or Ghostty) and press `C-a f` or `C-p` to pick a project.
2. Use Rex's default split binding (or `rex split`) for a scratch shell; the
   new block starts in the current directory.
3. Move between Rex blocks and nvim windows with their own bindings — one
   muscle memory, two layers.
4. Inside nvim, `C-f` opens another project in a new Rex window; use Rex's
   session switcher to bounce back.
5. At the shell prompt, `C-e` picks any file and opens it in nvim.

Nothing here requires the mouse; Ghostty stays a dumb, transparent wrapper.

## Gotchas

- **`C-a` vs beginning-of-line.** `C-a` starts a Rex sequence, so fish's
  emacs-mode `C-a` (cursor to line start) is shadowed. No literal-`C-a` escape
  is bound; use `Home` instead.
- **`C-f` means three different things**, never at the same time: fish moves the
  cursor right, nvim-normal opens the sessionizer, nvim-insert scrolls the cmp
  docs window (`cmp.lua:52`).
- **There is one clipboard: the system clipboard.** nvim auto-selects the
  Wayland provider (`set.lua`), so an nvim yank and a copy in any other app
  land in the same place. Paste with Ghostty's `SUPER+V`.
- **Over ssh there is no local clipboard**, so nvim falls back to OSC 52.
- **Mouse is handled by Rex in terminals and disabled in nvim** (`set.lua:11`).
  Use `]c`, `v`, etc. instead.
