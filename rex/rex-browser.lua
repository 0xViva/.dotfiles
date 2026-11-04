-- Rex actions for opening URLs in a text-mode browser inside a Rex pane.
--
-- Install (dotfiles/stow layout):
--   1. `bin/rex-browser` and `bin/rex-browser-prompt` are stowed to
--      ~/.config/bin and are on PATH.
--   2. This file is stowed to ~/.config/rex/rex-browser.lua.
--   3. ~/.config/rex/init.lua has `require("rex-browser")`.
--   4. Run `rex config reload`.
--
-- Without dotfiles, put the scripts in ~/.local/bin, copy this file to
-- ~/.config/rex/rex-browser.lua, and add the same require line.
--
-- Usage:
--   rex do open_url url=https://example.com
--   rex do open_url url=https://example.com where=float
--   rex do open_url url=https://example.com where=window
--
-- Direct bindings: Ctrl+Shift+U and Cmd+Shift+U. Ctrl-A then w is also bound.

local shell = "com.superlogical.terminal.shell"

-- The Rex server can start with a minimal PATH, so prefer an explicit
-- environment override, then the user's local bin, then the bare name.
local function default_bin(env_name, name)
  local configured = os.getenv(env_name)
  if configured ~= nil and configured ~= "" then
    return configured
  end
  local home = os.getenv("HOME")
  if home ~= nil and home ~= "" then
    -- ~/.config/bin is the dotfiles/stow location; ~/.local/bin is the
    -- plain user-local location. Try both before falling back to PATH.
    for _, dir in ipairs({ home .. "/.config/bin", home .. "/.local/bin" }) do
      local candidate = dir .. "/" .. name
      local file = io.open(candidate, "r")
      if file ~= nil then
        file:close()
        return candidate
      end
    end
  end
  return name
end

local browser_bin = default_bin("REX_BROWSER_BIN", "rex-browser")
local prompt_bin = default_bin("REX_BROWSER_PROMPT", "rex-browser-prompt")

local function label_for(url)
  local host = url:match("^%a[%w+.-]*://([^/]+)") or url:match("^([^/]+)")
  if host == nil or host == "" then
    return "web"
  end
  return "web: " .. host
end

local function browser_block(url, label, exit_on_completion)
  return rex.layout.block{
    flavor = shell,
    label = label,
    options = {
      shell = "none",
      command = { browser_bin, url },
      exit = { on_completion = exit_on_completion },
    },
  }
end

rex.action{
  name = "open_url",
  title = "Open URL in Rex Browser",
  description = "Open a URL in a text-mode browser (Chawan, w3m, lynx) inside a Rex pane.",
  category = "Web",
  keywords = "web browser url link http https chawan w3m lynx",
  args = { url = "string", where = "string?" },
  run = function(ctx, args)
    local url = args.url
    if url == nil or url == "" then
      error("url is required", 0)
    end

    local where = args.where or "split"
    local label = label_for(url)
    local block = browser_block(url, label, false)
    local result, err

    if where == "window" then
      result, err = rex.session.new_window{
        layout = block,
        window_label = label,
        focus = true,
      }
    elseif where == "float" then
      result, err = rex.session.new_layer{
        bounds = { 0.1, 0.1, 0.8, 0.8 },
        layout = block,
        focus = true,
      }
    else
      local split = {
        direction = "horizontal",
        side = "after",
        ratio = 0.5,
        layout = block,
        focus = true,
      }
      if ctx.block_id ~= nil then
        split.anchor_id = ctx.block_id
      end
      result, err = rex.session.new_split(split)
    end

    if err ~= nil then
      error(err, 0)
    end
    return result
  end,
}

rex.action{
  name = "web_prompt",
  title = "Open URL…",
  description = "Ask for a URL and open it in a floating Rex browser pane.",
  category = "Web",
  keywords = "web browser url link open prompt",
  run = function()
    local block = rex.layout.block{
      flavor = shell,
      label = "web",
      options = {
        shell = "none",
        command = { prompt_bin },
        exit = { on_completion = true },
      },
    }

    local result, err = rex.session.new_layer{
      bounds = { 0.1, 0.1, 0.8, 0.8 },
      layout = block,
      focus = true,
    }
    if err ~= nil then
      error(err, 0)
    end
    return result
  end,
}

rex.bind("ctrl+a>w", "web_prompt")

-- The macOS app sometimes hands bare Ctrl chords to the focused terminal
-- (the same reason init.lua uses Ctrl+Shift+P for the sessionizer), so also
-- provide modified chords that reliably reach Rex.
rex.bind("ctrl+shift+u", "web_prompt")
rex.bind("cmd+shift+u", "web_prompt")
