-- Input devices
-- https://wiki.hypr.land/Configuring/Basics/Variables/#input

hl.config({
    input = {
        kb_layout  = "no",
        kb_variant = "",
        kb_model   = "",
        kb_options = "caps:escape",
        kb_rules   = "",

        follow_mouse = 1,
        sensitivity  = 0, -- -1.0 to 1.0, 0 means no modification

        touchpad = {
            natural_scroll = true,
        },
    },
})

-- Trackpad swipe gestures: 3-finger horizontal swipe switches workspaces
hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})

-- XWayland apps on the scaled displays: force scale 1
hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
})