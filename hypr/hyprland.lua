
terminal    = "ghostty"
fileManager = "nautilus"
browser     = "zen-browser"
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

    hl.exec_cmd("noctalia")
    hl.exec_cmd("fcitx5")

end)

-- For Noctalia Color templates
-- Noctalia generates ~/.config/hypr/noctalia.lua and appends this include to
-- hyprland.lua. Load it defensively: on a fresh machine (before Noctalia has run
-- once) the module does not exist yet, and a bare require() would abort the whole
-- config. The literal require("noctalia") call is kept so the template's apply.sh
-- still recognises this include and won't append a duplicate.
local ok, noctalia = pcall(function() return require("noctalia") end)
if ok then noctalia.apply_theme() end
