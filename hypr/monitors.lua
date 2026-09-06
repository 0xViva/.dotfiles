-- Monitor layout
-- https://wiki.hypr.land/Configuring/Basics/Monitors/
--   DP-1 : left, portrait (rotated 90deg)
--   DP-2 : right, landscape (primary)

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