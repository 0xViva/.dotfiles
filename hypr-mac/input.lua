-- Personal input overrides, loaded by Omarchy after its defaults.
-- Omarchy already owns the three-finger workspace gestures, so they are not
-- repeated here; a second gesture on the same fingers and direction is rejected.

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

hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
})
