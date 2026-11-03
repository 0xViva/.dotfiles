-- Rex configuration. The Rex server loads this file; apply changes with
-- `rex config reload` and check them with `rex config check`.
-- See https://www.superlogical.com/rex/docs/customize/config
--
-- Rex is the session manager now: sessions, windows (tabs), and blocks
-- (panes) all live here. Ctrl-A is the terminal prefix.

-- The script is stowed under the config home (usually ~/.config/bin) or
-- lives in the repo at <repo>/bin. Prefer whichever exists, so macOS and
-- Linux share one config without a hardcoded home directory.
local config_home = os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")
local repo_root = os.getenv("DOTFILES") or (os.getenv("HOME") .. "/.dotfiles")
local sessionizer = config_home .. "/bin/rex-sessionizer"
for _, path in ipairs({ sessionizer, repo_root .. "/bin/rex-sessionizer" }) do
    local file = io.open(path, "r")
    if file then
        file:close()
        sessionizer = path
        break
    end
end

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
          command = { sessionizer },
        },
      },
    }
    if err ~= nil then error(err, 0) end
    return { layer_id = layer.layer_id }
  end,
}

-- Ctrl+P is sometimes handed to the focused terminal by the macOS app
-- (fish turns it into history recall). Ctrl+Shift+P is the reliable chord;
-- keep Ctrl+P as an alias for setups where the app lets it through.
rex.bind("ctrl+a>f", "sessionizer")
rex.bind("ctrl+p", "sessionizer")
rex.bind("ctrl+shift+p", "sessionizer")
