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

-- Cmd+P opens the sessionizer.
rex.bind("cmd+p", "sessionizer")

local uname = rex.exec({ "uname", "-s" })
local is_mac = uname and uname.ok and uname.stdout:match("Darwin") ~= nil

-- The desktop's Rex server is reachable through the desktop's own Tailscale
-- node. Only a Mac declares it: on the desktop itself the local socket is the
-- right endpoint, and the tailnet listener refuses self-connections.
if is_mac then
  rex.host{
    label    = "desktop",
    endpoint = "http://desktop.tail76e5ad.ts.net:7297",
  }
end

-- Image paste: Cmd+Shift+V turns a clipboard image into a file path, copying
-- it to the pane's host when that is another server. The plugin reads the
-- Mac's clipboard, so it only loads on macOS. Vendored at
-- rex/rex-image-paste (MIT), from https://github.com/pablasso/rex-image-paste.
if is_mac then
  local ok, image_paste = pcall(require, "rex-image-paste")
  if ok then
    image_paste.setup()
    rex.bind("cmd+shift+v", "image_paste")
  else
    rex.log("warn", "rex-image-paste: " .. tostring(image_paste))
  end
end
