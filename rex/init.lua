-- Rex configuration. The Rex server loads this file; apply changes with
-- `rex config reload` and check them with `rex config check`.
-- See https://www.superlogical.com/rex/docs/customize/config
--
-- Rex is the session manager now: sessions, windows (tabs), and blocks
-- (panes) all live here. Ctrl-A is the terminal prefix.

-- Rex runs the command through the target server's shell, which loads that
-- machine's startup files. Use the bare name so a local or remote session
-- finds its own stowed copy instead of a path from the client machine.
rex.action{
  name        = "sessionizer",
  title       = "Open Rex Sessionizer",
  description = "Pick a project directory or existing Rex session with fzf.",
  keywords    = "session project directory fzf switch",
  run         = function(ctx, args)
    -- Float the picker over the active window so it behaves like a popup:
    -- no new tab to switch to, and the layer closes when the picker exits.
    local layer, err = rex.session.new_layer{
      bounds = { 0.1, 0.1, 0.8, 0.8 },
      focus  = true,
      layout = rex.layout.block{
        flavor  = "com.superlogical.terminal.shell",
        options = {
          command = { "rex-sessionizer" },
        },
      },
    }
    if err ~= nil then error(err, 0) end
    return { layer_id = layer.layer_id }
  end,
}

-- Ctrl+P opens the sessionizer.
rex.bind("ctrl+p", "sessionizer")

-- TUI browser panes: Ctrl+U opens the URL prompt. `rex do open_url url=...`
-- is also available. See ~/.config/rex/rex-browser.lua.
require("rex-browser")
