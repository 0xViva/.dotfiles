# vim-fugitive cheatsheet

Installed via the plugin spec in `nvim/lua/plugins/fugitive.lua` (default config).

## The status window

`:G` / `:Git` — opens the git status buffer. This is the hub of the workflow:

- `s` — stage the file under the cursor (also works on hunks)
- `u` — unstage
- `-` — toggle stage/unstage
- `cc` — commit (opens a split with the commit message)
- `ca` — amend
- `cf` — fixup
- `dv` — diff the file under the cursor against the index
- `=` — inline diff for the file / hunk under the cursor
- `>` / `<` — expand / collapse the inline diff
- `p` — stage the hunk under the cursor (like `git add -p`)
- `P` — stage and commit (or `X` for commit with amend)
- `?` — help for all the status buffer mappings

## Firing off arbitrary git commands

`:Git add %` — stages the current file (no need to type the name)
`:Git log --oneline` — any `git` subcommand works, arguments are passed through:

```
:G[it]                # status
:G[it] add %          # stage current file
:G[it] commit -m msg  # commit directly
:G[it] diff %         # diff current file
:G[it] stash          # stash
:G[it] pull --rebase  # rebase-style pull
:G[it] blame %        # blame current file
```

`:%Gcommit -a` — run a command with the whole buffer as arguments. The
command can also be invoked on a visual selection.

## Diffs

- `:Gdiffsplit` — open the working tree (or the file under the cursor) vs. the
  index in a diff split. Works great on the status window: place the cursor on
  a file, hit `dv`.
- With a revision (e.g. a commit hash from `:Glog`): `:Gdiffsplit HEAD~1` —
  see that revision's version of the file. Mappings in the diff window:
  - `2do` / `3do` — obtain / revert changes to the file
  - `2dp` / `3dp` — put / revert the hunk under the cursor

## Log / history

- `:Glog` — shows the current file's history as a quickfix list (`:copen`).
  Jump to a revision, then `:Gdiffsplit` to inspect it.
- `:0Glog` — log with no range, i.e. the whole repo instead of the current file.
- `:Glog --oneline` — pass arbitrary flags.
- `:Gllog` — same as `:Glog` but into the location list (`:lwindow`).

## Blame

- `:Gblame` — annotated blame window. In it:
  - `g?` — help for blame mappings
  - `A` — show the commit message under the cursor
  - `p` — show the diff of that commit
  - `o` / `O` — open the commit in the status window / new tab
  - `q` — close the blame window

## Browse / sharing

`:Gbrowse` — open the current file on GitHub (or the remote's web UI). With a
visual selection it links the selected lines; with a revision it links that
version. Requires `git remote` to be set and a browser to be configured.

## The commit buffer

When you run `cc` in the status window, a split opens with the message. It is
also a git object buffer, so you can edit an existing commit with
`:Gedit <hash>` and `:Gwrite` to rewrite it.

## Key objects

- `:Gedit HEAD` — read the given object (`:Gedit HEAD^:file.txt`).
- `:Gread` — discard working tree changes for the current file (writes the
  buffer from the given revision, default HEAD). Use `:Gwrite` to do the
  reverse.
- `:Gdelete` — `git rm` the current file.

## Additional macros

- `:Gvdiffsplit` — `:Gdiffsplit` using a vertical split.
- `:Gedit` / `:Gsplit` / `:Gtabedit` — edit a git object in various splits.
- `:Git!` — run a command and show output without quitting the status window.