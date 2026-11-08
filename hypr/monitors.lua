-- Outputs that are not connected are ignored, so one file serves both the
-- laptop panel and the desktop's two monitors.
hl.monitor({
    output   = "eDP-1",
    mode     = "preferred",
    position = "0x0",
    scale    = 2,
})

hl.monitor({
    output    = "DP-1",
    mode      = "preferred",
    position  = "0x0",
    scale     = 1,
    transform = 1,
})

hl.monitor({
    output   = "DP-2",
    mode     = "2560x1440@180",
    position = "1440x0",
    scale    = 1,
})
