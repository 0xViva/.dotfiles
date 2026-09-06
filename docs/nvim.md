# Working efficiently in nvim (this setup)

A map of the actual keybindings and workflows configured in
`nvim/lua/` — what exists, where it lives, and how to use the pieces together.

## Ground rules of this config

- Leader is `<Space>` (`set.lua:1`). Everything starts there; **wait half a
  second after pressing `<Space>`** and which-key shows you the pending group
  (`[C]ode`, `[D]ocument`, `[R]ename`, `[S]earch`, `[W]orkspace`, `[T]oggle`,
  Git `[H]unk`).
- `CapsLock` is `Esc` in insert, visual and cmdline mode (`set.lua:103`). Use
  it instead of reaching for `<Esc>`.
- Mouse is disabled. `hl`/`jk` moving only; arrows echo a scolding when pressed.
- Relative line numbers are on — use `10j`, `+5`, `k` count-based motion.
- Whenever you forget a key: `<leader>sk` searches all keymaps by name.
- `timeoutlen` is 300ms, so leader chords feel snappy.

## Opening / switching files

- `<C-f>` — pop the tmux sessionizer (`set.lua:66`): fuzzy-switch to any tmux
  session or open a project by name. Your files live behind this; get in the
  habit of using it instead of `:e`.
- `<leader>sf` — telescope find files.
- `<leader><leader>` — switch between already-open buffers (fuzzy).
- `<leader>s.` — recent files.
- `<leader>sn` — jump straight into this config's files.
- `-` — oil file manager at the current directory; `g.` inside oil toggles
  hidden files, `-` goes up, `<C-s>`/`<C-h>` open a file in a split.
- `<C-h/j/k/l>` — move between windows regardless of layout.

## Editing

- Text objects from mini.ai (`a`/`i` + `w` `(` `{` `[` `"` ...). Powerful
  combos: `di(` `ci"` `yaB` (inner block incl. braces). Covers 500-line
  boundaries so you can target big regions.
- Surround from mini.surround: `sa` + object + delimiter (e.g. `saiw"`),
  `sd'` to delete, `sr)[` to replace. No plugin UI, no thinking.
- Snippets (LuaSnip): in insert mode `<C-l>` expands/jumps forward,
  `<C-h>` jumps back through the fields.
- Autoformat runs on save (conform). Pause it per-buffer with `<leader>tf`,
  globally with `<leader>tF`; format on demand with `<leader>f`.
- Search within the file: `<leader>/` fuzzy-filters the current buffer.

## Searching the codebase

- `<leader>sg` — live grep (ripgrep). This is your main navigation tool.
- `<leader>sw` — grep for the word under the cursor.
- `<leader>s/` — grep only in currently-open files.
- `<leader>sr` — resume the last telescope search; `<leader>ss` browses all
  pickers.
- `<leader>sd` — all LSP diagnostics in the project, jump into them.

## LSP (per buffers, see `lsp.lua:44`)

- `K` — hover docs
- `gd` / `gD` — definition / declaration
- `gr` — references, `gI` — implementations, `<leader>D` — type definition
- `<leader>rn` — rename symbol
- `<leader>ca` — code actions
- `<leader>ds` — symbols in the file
- `q` — custom: opens the location list of this buffer's diagnostics and
  focuses it (auto-closes if clean). Holds a quick-error review.

Servers manage themselves via mason (just install, they auto-attach): clangd,
gopls, html, lua_ls, ts_ls, tailwindcss, jdtls, rust_analyzer.

## Git

Two tools, used together:

- **gitsigns** for hunks (`<leader>h` prefix, all in `gitsigns.lua`):
  `]c`/`[c` next/prev hunk; `<leader>hs` stage hunk, `<leader>hr` reset hunk,
  `<leader>hu` unstage; `<leader>hp` preview hunk; `<leader>hb` blame line;
  `<leader>hD` diff against HEAD.
- **fugitive** for the heavy workflows — see `docs/fugitive.md`. The
  gitsigns maps handle 80% of daily flow; `:G` for the rest.

## Debugging (nvim-dap)

- `<F5>` continue, `<F1>` step into, `<F2>` step over, `<F3>` step out
- `<leader>b` / `<leader>B` — toggle / conditional breakpoint
- `<F7>` — toggle the DAP UI (variables, scopes, repl)
- Go (delve) and Rust (codelldb) adapters installed via mason; Rust launch
  lets you pick the target binary.

## AI (ThePrimeagen/99)

- `<leader>9v` — send the current visual selection to the opencode provider
  (set to `opencode/deepseek-v4-flash-high`, `99.lua:13`).
- `<leader>9s` — search, `<leader>9x` — cancel all in-flight requests.

## Workflow worth stealing

1. `<C-f>` open project → telescope live grep → jump.
2. Edit with mini.ai text objects + surround; `<C-l>` through snippets.
3. `q` to review this buffer's diagnostics, fix with `<leader>ca`.
4. `]c` to reach your changed hunks, `<leader>hs` stage the ones you keep.
5. F5 debug when it still misbehaves.

## Gotchas

- `q` overrides macro recording (default `q` was free because of `set.lua:86`).
  If you record macros, remap it — currently there is no macro mapping.
- `-` no longer scrolls up a line; it's bound to oil.
- `<C-f>` in normal mode is the tmux sessionizer, *not* scroll-page-down. Use
  `<C-d>`/`<C-u>` to page.
- Autoformat is on by default (`lsp_format` falls back to the LSP formatter) —
  if a save unexpectedly rewrites your file, `<leader>tf` is the switch.
- `set.lua` strips `\r` from every buffer on read/write, so CRLF files get
  normalized silently.