-- Rex configuration. The Rex server loads this file; apply changes with
-- `rex config reload` and check them with `rex config check`.
-- See https://www.superlogical.com/rex/docs/customize/config
--
-- Rex is the session manager now: sessions, windows (tabs), and blocks
-- (panes) all live here. Ctrl-A is the terminal prefix.

rex.action{
  name        = "sessionizer",
  title       = "Open Rex Sessionizer",
  description = "Pick a project directory or existing Rex session with fzf.",
  keywords    = "session project directory fzf switch",
  run         = function(ctx, args)
    local w, err = rex.session.new_window{
      layout = rex.layout.block{
        flavor  = "com.superlogical.terminal.shell",
        options = {
          command = { os.getenv("HOME") .. "/.dotfiles/bin/rex-sessionizer" },
        },
      },
    }
    if err ~= nil then error(err, 0) end
    return { window_id = w.window_id }
  end,
}

rex.bind("ctrl+a>f", "sessionizer")
rex.bind("ctrl+p", "sessionizer")
