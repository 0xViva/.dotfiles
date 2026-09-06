
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

    hl.exec_cmd("hypridle")
    hl.exec_cmd("mako")
    hl.exec_cmd("waybar")
    hl.exec_cmd("fcitx5")
    hl.exec_cmd("elephant")
    hl.exec_cmd("swayosd-server")

    hl.exec_cmd("~/.config/hypr/set-wallpapers.sh")

end)