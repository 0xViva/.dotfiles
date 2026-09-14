# Fish

Fish is the default login shell: `setup.sh` adds it to `/etc/shells` if needed
and runs `chsh -s`. The setup tooling is fish too (`stow.fish`, `gpg/setup.fish`).

## Files

| File | Purpose |
|---|---|
| `fish/config.fish` | env + PATH, mise, starship, fzf, tty1 session start |
| `fish/fzf.fish` | custom `CTRL+E` nvim picker |
| `fish/fish_plugins` | fisher plugin manifest, reconciled by `setup.sh` |

All are stowed: `fish/` → `~/.config/fish`.
`fish_variables` (fish's universal-variable store) is generated at runtime and
git-ignored.

`config.fish` covers env + PATH (`fish_add_path`), Homebrew, `fd`→`fdfind` on
WSL, mise, starship, the window title, the `CTRL+E` picker, `CTRL+P` sessionizer,
and the tty1-login Hyprland autostart (login + tty1 + no `WAYLAND_DISPLAY`).

## fzf.fish plugin (hybrid)

[`PatrickF1/fzf.fish`](https://github.com/PatrickF1/fzf.fish) is installed via
fisher for the file/directory pickers with previews and multi-select, plus git
log/status, history, variables and processes. The only custom widget is `CTRL+E`:

| Keys | Source | Action |
|---|---|---|
| `CTRL+E` | `fish/fzf.fish` | open the selection from `/` in nvim |
| `CTRL+ALT+F` | plugin | search directory (cwd, preview, multi) |
| `CTRL+R` | plugin | history |
| `CTRL+ALT+L` / `CTRL+ALT+S` | plugin | git log / git status |
| `CTRL+V` / `CTRL+ALT+P` | plugin | variables / processes |

`CTRL+ALT+F` searches the current directory. To search elsewhere, prefix the
token: `/` for the whole machine, `/etc/`, `~/src/`, … — the plugin uses that
directory as fd's base and returns absolute paths.

`setup.sh` installs `fisher` and `bat` (needed for the plugin's file previews)
and runs `fisher update`, which reads the tracked `fish/fish_plugins`. Plugin
files land in `~/.config/fish/{functions,completions,conf.d}` as untracked,
fisher-managed state. Because the plugin owns `CTRL+R`, do **not** also call
`fzf_key_bindings` — fzf's stock fish bindings would rebind it.

Notes:

- `CTRL+F` and `CTRL+D` keep fish's defaults (`forward-char` and `exit`).
- Homebrew uses `brew shellenv fish | source`; brew's auto-detection is
  unreliable under fish, so the shell is named explicitly.

## Known gap: fzf theme

Noctalia renders a fish theme at `~/.config/fzf/themes/noctalia.fish`, but it is
not sourced. It uses `set -Ux FZF_DEFAULT_OPTS`, which appends the palette every
time it runs, so sourcing it in every shell would duplicate the options without
bound — and storing them as a universal variable would stop the palette from
updating when Noctalia re-renders. Fixing this properly means changing the fzf
community template upstream (use `set -gx` and make the append idempotent) or
vendoring a corrected template.
