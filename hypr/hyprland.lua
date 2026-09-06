-- Hyprland configuration (Lua provider)
-- https://wiki.hypr.land/Configuring/Start/

---------------------
---- MY PROGRAMS ----
---------------------

terminal    = "ghostty"
fileManager = "nautilus"
browser     = "zen-browser"
editor      = terminal .. " -e nvim"

mainMod = "SUPER" -- The "Windows" key

---------------------
---- CONFIG MODS ----
---------------------

require("monitors")
require("appearance")
require("input")
require("rules")

require("bindings/apps")
require("bindings/tiling")
require("bindings/media")
require("bindings/util")

-------------------
---- AUTOSTART ----
-------------------

-- https://wiki.hypr.land/Configuring/Basics/Autostart/
hl.on("hyprland.start", function()
    -- Daemons
    hl.exec_cmd("hypridle")
    hl.exec_cmd("mako")
    hl.exec_cmd("waybar")
    hl.exec_cmd("fcitx5")
    hl.exec_cmd("elephant")
    hl.exec_cmd("swayosd-server")

    -- Wallpaper
    hl.exec_cmd("~/.config/hypr/set-wallpapers.sh")

    -- Polkit authentication agent (install one and uncomment to use)
    -- hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
end)