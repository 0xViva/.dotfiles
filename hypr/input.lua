
hl.config({
    input = {
        kb_layout  = "no",
        kb_variant = "",
        kb_model   = "",
        kb_options = "caps:escape",
        kb_rules   = "",

        follow_mouse = 1,
        sensitivity  = 0,

        touchpad = {
            natural_scroll = true,
        },
    },
})

hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})

hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
})