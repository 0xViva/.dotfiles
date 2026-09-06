-- Window, workspace and layer rules
-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Fix some dragging issues with XWayland windows
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

-- Zen picture-in-picture: float and pin it above everything else
hl.window_rule({
    name  = "zen-pip",
    match = { class = "zen-browser", title = "Picture-in-Picture" },
    float = true,
    pin   = true,
})

-- GTK file chooser dialogs (Open/Save): float and center them
hl.window_rule({
    name   = "float-file-dialogs",
    match  = { title = "^(Open|Save|Select|Export) File" },
    float  = true,
    center = true,
})

-- Workspace rules

-- Default workspace lives on the landscape display
hl.workspace_rule({ workspace = "1", monitor = "DP-2", default = true })

-- Open a terminal in the scratchpad on first use
hl.workspace_rule({ workspace = "special:scratchpad", on_created_empty = terminal })

-- Layer rules: blur behind the status bar and notifications.
-- Note: the blur is only visible where the layer is (semi)transparent.
-- Make the waybar background "rgba(...)" to see it behind the bar.
hl.layer_rule({ match = { namespace = "waybar" }, blur = true })
hl.layer_rule({ match = { namespace = "waybar-workspaces" }, blur = true })
hl.layer_rule({ match = { namespace = "notifications" }, blur = true })