-- Look and feel
-- https://wiki.hypr.land/Configuring/Basics/Variables/

hl.config({
    general = {
        -- No gaps between windows or monitors
        gaps_in  = 0,
        gaps_out = 0,

        border_size = 2,
        layout      = "dwindle",

        col = {
            active_border   = "rgb(a6adc8)",
            inactive_border = "rgb(4c566a)",
        },
    },

    decoration = {
        rounding = 8,

        blur = {
            enabled  = true,
            size     = 6,
            passes   = 2,
            vibrancy = 0.2,
        },
    },
})

-- Cursor behaviour
hl.config({
    cursor = {
        inactive_timeout = 15,
        hide_on_key_press = true,
    },
})

-- Etc.
hl.config({
    misc = {
        force_default_wallpaper  = 0, -- we set our own wallpaper with swaybg
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
    },
})

hl.config({
    ecosystem = {
        no_update_news = true,
    },
})

-- Animations
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 238.1191, dampening = 24.21279333 })

hl.animation({ leaf = "global",               enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",               enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",              enabled = true,  speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn",            enabled = true,  speed = 4.1,  spring = "easy",         style = "popin 87%" })
hl.animation({ leaf = "windowsOut",           enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",               enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",              enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",                 enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "fadeLayersIn",         enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut",        enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "layers",               enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",             enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",            enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "workspaces",           enabled = true,  speed = 1.94, bezier = "almostLinear", style = "slidefade 15%" })
hl.animation({ leaf = "workspacesIn",         enabled = true,  speed = 1.21, bezier = "almostLinear", style = "slidefade 15%" })
hl.animation({ leaf = "workspacesOut",        enabled = true,  speed = 1.94, bezier = "almostLinear", style = "slidefade 15%" })
hl.animation({ leaf = "specialWorkspace",     enabled = true,  speed = 1.94, bezier = "almostLinear", style = "slidefade 15%" })
hl.animation({ leaf = "specialWorkspaceIn",   enabled = true,  speed = 1.21, bezier = "almostLinear", style = "slidefade 15%" })
hl.animation({ leaf = "specialWorkspaceOut",  enabled = true,  speed = 1.94, bezier = "almostLinear", style = "slidefade 15%" })
hl.animation({ leaf = "zoomFactor",           enabled = true,  speed = 7,    bezier = "quick" })