
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

hl.workspace_rule({ workspace = "1", monitor = "DP-1", default = true, persistent = true })

hl.workspace_rule({ workspace = "2", monitor = "DP-2", default = true, persistent = true })

hl.on("workspace.created", function(ws)
    if ws.addressable_name == "special:scratchpad" and ws.is_empty then
        hl.exec_cmd(terminal, { workspace = "special:scratchpad" })
    end
end)

hl.layer_rule({
    name  = "noctalia",
    match = { namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$" },
    no_anim      = true,
    ignore_alpha = 0.5,
    blur         = true,
    blur_popups  = true,
})

hl.window_rule({
    name  = "noctalia-settings",
    match = { class = "dev.noctalia.Noctalia" },
    float = true,
    size  = { 1080, 920 },
})