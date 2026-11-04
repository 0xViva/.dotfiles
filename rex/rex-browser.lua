-- Rex actions for opening URLs in a text-mode browser inside a Rex pane.
--
-- The actions are self-contained: they run /bin/sh and find a browser from
-- PATH, so they do not depend on helper scripts being installed. The optional
-- `bin/rex-browser` wrapper is still useful from the CLI.
--
-- Install (dotfiles/stow layout):
--   1. This file is stowed to ~/.config/rex/rex-browser.lua.
--   2. ~/.config/rex/init.lua has `require("rex-browser")`.
--   3. Run `rex config reload`.
--
-- Without dotfiles, copy this file to ~/.config/rex/rex-browser.lua and add
-- the same require line.
--
-- Usage:
--   rex do open_url url=https://example.com
--   rex do open_url url=https://example.com where=float
--   rex do open_url url=https://example.com where=window
--
-- Direct binding: Ctrl+U. `open_url` remains available from the CLI and the
-- command palette.

local shell = "com.superlogical.terminal.shell"

-- The Rex server can start with a minimal PATH (especially on macOS), so
-- every shell command puts the usual local and Homebrew directories first.
local path_setup = [[
export PATH="$HOME/.local/bin:$HOME/.config/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"
if [ -z "${LANG:-}" ]; then
  if command -v locale >/dev/null 2>&1 && locale -a 2>/dev/null | grep -Eiq '^C\.(UTF-8|utf8)$'; then
    export LANG=C.UTF-8
  else
    export LANG=en_US.UTF-8
  fi
fi
export LC_CTYPE="${LC_CTYPE:-$LANG}"
]]

-- One browser picker shared by the direct action and the prompt. It prefers
-- $REX_BROWSER when set, then Chawan (best text/CSS/images), then common text
-- browsers.
local browser_picker = [[
run_browser() {
  url=$1
  if [ -z "${REX_BROWSER:-}" ] && [ -f "$HOME/.config/rex/browser" ]; then
    REX_BROWSER=$(cat "$HOME/.config/rex/browser")
  fi
  if [ -n "${REX_BROWSER:-}" ] && command -v "$REX_BROWSER" >/dev/null 2>&1; then
    exec "$REX_BROWSER" "$url"
  fi
  case "${REX_BROWSER_JS:-true}" in
    false|no|0) js=false ;;
    *) js=true ;;
  esac
  case "${REX_BROWSER_MOUSE:-true}" in
    false|no|0) mouse=false ;;
    *) mouse=true ;;
  esac
  if command -v chawan >/dev/null 2>&1; then
    exec chawan -O UTF-8 \
      -o buffer.images=true \
      -o "buffer.scripting=$js" \
      -o "input.use-mouse=$mouse" \
      -o display.image-mode=auto "$url"
  fi
  if command -v cha >/dev/null 2>&1; then
    exec cha -O UTF-8 \
      -o buffer.images=true \
      -o "buffer.scripting=$js" \
      -o "input.use-mouse=$mouse" \
      -o display.image-mode=auto "$url"
  fi
  if command -v w3m >/dev/null 2>&1; then exec w3m "$url"; fi
  if command -v lynx >/dev/null 2>&1; then exec lynx "$url"; fi
  if command -v links >/dev/null 2>&1; then exec links "$url"; fi
  if command -v elinks >/dev/null 2>&1; then exec elinks "$url"; fi
  printf 'No text browser found. Install chawan (brew install chawan) or w3m.\n' >&2
  exit 127
}
]]

local function label_for(url)
  local host = url:match("^%a[%w+.-]*://([^/]+)") or url:match("^([^/]+)")
  if host == nil or host == "" then
    return "web"
  end
  return "web: " .. host
end

local function browser_command(url)
  local script = path_setup .. "\n" .. browser_picker .. '\nrun_browser "$1"\n'
  -- /bin/sh -c SCRIPT NAME URL: inside the script, $1 is the URL.
  return { "/bin/sh", "-c", script, "rex-browser", url }
end

local function prompt_command()
  local script = path_setup .. "\n" .. browser_picker .. [[
printf 'URL: '
IFS= read -r url
[ -n "$url" ] || exit 0
case "$url" in
  *://*) ;;
  *) url="https://$url" ;;
esac
run_browser "$url"
]]
  return { "/bin/sh", "-c", script }
end

local function browser_block(url, label, exit_on_completion)
  return rex.layout.block{
    flavor = shell,
    label = label,
    options = {
      shell = "none",
      command = browser_command(url),
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
  description = "Ask for a URL and open it in a Rex browser pane beside the current one.",
  category = "Web",
  keywords = "web browser url link open prompt",
  run = function(ctx)
    local block = rex.layout.block{
      flavor = shell,
      label = "web",
      options = {
        shell = "none",
        command = prompt_command(),
        exit = { on_completion = true },
      },
    }

    -- Open the prompt/browser in a normal split pane, not a floating layer.
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

    local result, err = rex.session.new_split(split)
    if err ~= nil then
      error(err, 0)
    end
    return result
  end,
}

rex.bind("ctrl+u", "web_prompt")
