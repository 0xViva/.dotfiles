# Ghostty + tmux + nvim: workflow and keybindings

How the three layers hand the keyboard to each other, and how to use the
configured keybindings (`ghostty/config`, `tmux/tmux.conf`,
`tmux/tmux-sessionizer.conf`, `zsh/.zshrc`, `fzf/fzf.zsh`, `nvim/lua/set.lua`).

## The layering model

One keyboard, three owners. The app that currently has focus owns the keys;
the others pass them through:

```
Ghostty (outer window)  →  tmux (prefix C-a)  →  zsh (prompt)  or  nvim
```

- Ghostty only intercepts what you bind in `ghostty/config`. There are no
  split/zoom binds here — it is a pure pass-through layer.
- tmux only intercepts keys *prefixed* by `C-a` (it unbinds the default `C-b`).
  Plain keys go to the app inside.
- zsh/fzf bindings only apply while the shell prompt is focused.
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
reaches tmux or the app directly. The window manages itself via your WM — you
work in splits/tabs inside tmux instead.

## tmux layer

Prefix is `C-a` (`tmux.conf:13`). With `escape-time 0` (`:1`) the prefix fires
without delay, so chords feel instant.

### Movement (repeatable — press `C-a` once, then `h/j/k/l` repeatedly)

| Binding      | Action                        |
|--------------|-------------------------------|
| `C-a h` / `j` / `k` / `l` | select pane left / down / up / right |
| `C-a ^`      | switch to last window         |
| `C-a f`      | sessionizer (projects/tmux)   |
| `C-a <n>`    | go to window `<n>` (base-index is 1) |
| `C-a c`      | new window                   |
| `C-a %` / `"`| vertical / horizontal split   |
| `C-a x`      | kill pane                     |
| `C-a r`      | reload `~/.tmux.conf`         |

Repeatable means `C-a j j j j` walks you down four panes without re-pressing
the prefix. Mouse is on outside nvim, so clicking a pane focuses it too.

### Copy mode (vi bindings, `mode-keys vi`)

Press `C-a [`, then navigate with `hjkl`, `v` to begin selection, `y` to copy
to the clipboard via `xclip` (`:17`). Practically you'll rarely need this —
holding `shift` in Ghostty bypasses tmux mouse mode for native terminal
selection.

### Sessionizer entry points

The same project switcher is reached three ways:

| Where              | Binding        | Effect                                    |
|--------------------|----------------|-------------------------------------------|
| inside tmux        | `C-a f`        | new window running `tmux-sessionizer`     |
| zsh prompt         | `C-p`          | runs the switcher in-place (`zshrc:25`)   |
| nvim normal mode   | `C-f`          | new tmux window with the switcher (`set.lua:66`) |
| tmux (bound, off)  | `C-a M-h/t/n/s`| sessionizer windows 0–3                   |

## zsh (prompt-only bindings)

Applied by `fzf/zsh.zsh`, active only at the prompt:

- `C-p` — tmux-sessionizer (from `zshrc:25`)
- `C-f` — fzf file picker, inserts the chosen path into your command
- `C-d` — fzf directory picker (`fd`), inserts the dir
- `C-e` — fzf file picker, then *opens the file in nvim*

## nvim layer

Already covered in depth in `docs/nvim.md`; the parts that interact with the
terminal:

- `C-h/j/k/l` — move between nvim windows. Same keys move tmux panes — one
  muscle memory, two layers. Inside nvim, tmux can't see them.
- `C-f` (normal) — spawns the tmux sessionizer as a new window. Your fastest
  "go work on another project" move from inside an editor.
- `q` — buffer diagnostics loclist (not macro recording, see `docs/nvim.md`).

## Putting it together: one work session

1. Ghostty opened at your WM → tmux starts automatically, `C-p` at the prompt
   (or `C-a f`) picks the project, drops you in its session.
2. `C-a %` / `C-a "` split a scratch pane on the right/below.
3. `C-a l` / `C-a j` hop between your editor pane and the scratch shell; run
   builds/tests there without leaving nvim.
4. Inside nvim: `C-f` opens another project as a whole new window; `C-a ^`
   (or `C-a 1`) bounces back to where you were.
5. `C-a j` into the shell, `C-e` pick any file and have nvim open it.

Nothing here requires the mouse; Ghostty stays a dumb, transparent wrapper.

## Gotchas

- **`C-a` vs beginning-of-line.** Inside tmux, `C-a` is the prefix, so zsh's
  emacs-mode `C-a` (cursor to line start) is shadowed. Press the prefix twice
  — `C-a C-a` sends a literal `C-a` through (`bind-key C-a send-prefix`,
  `:14`) — or just hit `Home` / `^A` via `C-a C-a`.
- **`C-a M-h/M-t/M-n/M-s` are broken as configured.** They call
  `tmux-sessionizer -s <n>`, which requires `TS_SESSION_COMMANDS` to be set in
  `tmux/tmux-sessionizer.conf` — it isn't, so they exit with an error. Either
  define `TS_SESSION_COMMANDS` or drop the bindings (`:25-28`).
- **`C-f` means three different things**, never at the same time: zsh picks a
  filepath, nvim-normal spawns the sessionizer, nvim-insert scrolls the cmp
  docs window (`cmp.lua:52`).
- **Mouse is on in tmux, off in nvim.** tmux mouse selection works in shell
  panes; in nvim panes it passes through dead because `set.lua:11` disables
  the mouse there. Use `]c`, `v`, etc. instead.
- **Windows start at 1**, not 0 (`base-index 1`, `:5`) — `C-a 1` is the first
  window and also the default last-window target.