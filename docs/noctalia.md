# Noctalia

Noctalia is installed as the `noctalia` Arch package and configured through
`noctalia/config.toml` (this repo, stowed to `~/.config/noctalia/`). Theming —
palettes and app templates — is covered in `docs/theming.md`.

## Config layers

Noctalia merges, in order, with later layers winning:

1. built-in defaults (shipped in the binary)
2. `~/.config/noctalia/*.toml` ← this repo
3. `~/.local/state/noctalia/settings.toml` ← written by the Settings GUI

Because `config.toml` lists values explicitly, **every key in it pins that
value**. If a future release changes a built-in default, the old value in this
file keeps winning until the key is removed. That is why the file must be
reconciled after a Noctalia update.

## Updating

`yay -Syu` replaces the binary; it never touches `config.toml`. Reconcile the
tracked file against the new version's defaults afterwards:

```bash
# 1. full system upgrade (partial upgrades are unsupported on Arch)
yay -Syu

# 2. dump the NEW version's built-in defaults.
#    empty XDG dirs = no user config and no state, so this is pure defaults.
tmp=$(mktemp -d)
XDG_CONFIG_HOME="$tmp/c" XDG_STATE_HOME="$tmp/s" \
    noctalia config export full > /tmp/noctalia-defaults.toml

# 3. compare against what we track
diff /tmp/noctalia-defaults.toml ~/.dotfiles/noctalia/config.toml
```

Then edit `noctalia/config.toml`:

- remove keys we only pinned at their old default, so the new default applies
- adopt new keys we care about
- fix values that upstream changed

```bash
noctalia config validate
noctalia msg templates-apply
# commit the result
```

Notes:

- Use `export full` (defaults + our config + GUI `settings.toml`), not `merged`
  (our config only). `noctalia config export --help` lists the modes.
- `export full` emits `schema_version` and runtime state (e.g. lockscreen widget
  positions). These are not defaults — do not copy them into the tracked file.
- Reals are printed with float artefact noise (`0.30000001192092896` for `0.3`),
  so the diff is noisier than the real change set. Read it, don't apply it.
