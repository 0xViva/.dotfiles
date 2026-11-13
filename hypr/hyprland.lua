
terminal    = os.getenv("HYPR_TERMINAL") or "ghostty"
fileManager = "nautilus"
browser     = os.getenv("HYPR_BROWSER") or "zen-browser"
editor      = terminal .. " -e nvim"

mainMod = "SUPER"

require("monitors")
require("appearance")
require("input")
require("rules")

require("bindings/apps")
require("bindings/tiling")
require("bindings/media")
require("bindings/util")

hl.on("hyprland.start", function()

    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("noctalia")

end)

-- For Noctalia Color templates
-- Noctalia writes ~/.config/hypr/noctalia.lua and appends this include to that
-- hyprland.lua. It is absent until Noctalia has run once, so load it
-- defensively. The literal require("noctalia") call is kept so the template's
-- apply.sh recognises it.
local ok, noctalia = pcall(function() return require("noctalia") end)
if ok then noctalia.apply_theme() end
