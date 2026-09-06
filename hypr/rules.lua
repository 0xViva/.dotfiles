
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

hl.window_rule({
    name  = "zen-pip",
    match = { class = "zen-browser", title = "Picture-in-Picture" },
    float = true,
    pin   = true,
})

hl.window_rule({
    name   = "float-file-dialogs",
    match  = { title = "^(Open|Save|Select|Export) File" },
    float  = true,
    center = true,
})

hl.workspace_rule({ workspace = "1", monitor = "DP-1", default = true })

hl.workspace_rule({ workspace = "2", monitor = "DP-2", default = true })

hl.workspace_rule({ workspace = "special:scratchpad", on_created_empty = terminal })

hl.layer_rule({ match = { namespace = "waybar" }, blur = true })
hl.layer_rule({ match = { namespace = "waybar-workspaces" }, blur = true })
hl.layer_rule({ match = { namespace = "notifications" }, blur = true })