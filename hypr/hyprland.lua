
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