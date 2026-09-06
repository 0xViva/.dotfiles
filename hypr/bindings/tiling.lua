-- Window / tiling / workspace / group bindings

-- Close window
hl.bind(mainMod .. " + Q", hl.dsp.window.close(), { description = "Close window" })

-- Control tiling
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"), { description = "Toggle split" })
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo(), { description = "Pseudo window" })
hl.bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle floating" })
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen(), { description = "Fullscreen" })
hl.bind(mainMod .. " + CTRL + F", hl.dsp.window.fullscreen_state({ internal = 0, client = 2 }), { description = "Tiled fullscreen" })
hl.bind(mainMod .. " + ALT + F", hl.dsp.window.fullscreen({ mode = "maximized" }), { description = "Full width" })

-- Move focus with SUPER + arrow keys
hl.bind(mainMod .. " + LEFT",  hl.dsp.focus({ direction = "left" }),  { description = "Move focus left" })
hl.bind(mainMod .. " + RIGHT", hl.dsp.focus({ direction = "right" }), { description = "Move focus right" })
hl.bind(mainMod .. " + UP",    hl.dsp.focus({ direction = "up" }),    { description = "Move focus up" })
hl.bind(mainMod .. " + DOWN",  hl.dsp.focus({ direction = "down" }),  { description = "Move focus down" })

-- Workspaces with SUPER + [1-0] (keycodes 10-19: layout independent)
for i = 0, 9 do
    local ws, code = i + 1, 10 + i
    hl.bind(mainMod .. " + code:" .. code,                    hl.dsp.focus({ workspace = ws }),                       { description = "Switch to workspace " .. ws })
    hl.bind(mainMod .. " + SHIFT + code:" .. code,            hl.dsp.window.move({ workspace = ws }),                 { description = "Move window to workspace " .. ws })
    hl.bind(mainMod .. " + SHIFT + ALT + code:" .. code,      hl.dsp.window.move({ workspace = ws, follow = false }),  { description = "Move window silently to workspace " .. ws })
end

-- Scratchpad
hl.bind(mainMod .. " + S",       hl.dsp.workspace.toggle_special("scratchpad"), { description = "Toggle scratchpad" })
hl.bind(mainMod .. " + ALT + S", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }), { description = "Move window to scratchpad" })

-- Tab between workspaces
hl.bind(mainMod .. " + TAB",         hl.dsp.focus({ workspace = "e+1" }),      { description = "Next workspace" })
hl.bind(mainMod .. " + SHIFT + TAB", hl.dsp.focus({ workspace = "e-1" }),      { description = "Previous workspace" })
hl.bind(mainMod .. " + CTRL + TAB",  hl.dsp.focus({ workspace = "previous" }), { description = "Former workspace" })

-- Move workspaces to other monitors
hl.bind(mainMod .. " + SHIFT + ALT + LEFT",  hl.dsp.workspace.move({ monitor = "left" }),  { description = "Move workspace to left monitor" })
hl.bind(mainMod .. " + SHIFT + ALT + RIGHT", hl.dsp.workspace.move({ monitor = "right" }), { description = "Move workspace to right monitor" })

-- Swap active window with the one in a direction
hl.bind(mainMod .. " + SHIFT + LEFT",  hl.dsp.window.swap({ direction = "left" }),  { description = "Swap window left" })
hl.bind(mainMod .. " + SHIFT + RIGHT", hl.dsp.window.swap({ direction = "right" }), { description = "Swap window right" })
hl.bind(mainMod .. " + SHIFT + UP",    hl.dsp.window.swap({ direction = "up" }),    { description = "Swap window up" })
hl.bind(mainMod .. " + SHIFT + DOWN",  hl.dsp.window.swap({ direction = "down" }),  { description = "Swap window down" })

-- Cycle through applications on the active workspace
hl.bind("ALT + TAB", function()
    hl.dispatch(hl.dsp.window.cycle_next())
    hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top" }))
end, { description = "Cycle next window and bring it on top" })

hl.bind("ALT + SHIFT + TAB", function()
    hl.dispatch(hl.dsp.window.cycle_next({ next = false }))
    hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top" }))
end, { description = "Cycle previous window and bring it on top" })

-- Resize the active window ( - / = keys, keycodes 20/21 )
hl.bind(mainMod .. " + code:20",         hl.dsp.window.resize({ x = -100, y = 0, relative = true }),  { description = "Expand window left" })
hl.bind(mainMod .. " + code:21",         hl.dsp.window.resize({ x = 100, y = 0, relative = true }),   { description = "Shrink window left" })
hl.bind(mainMod .. " + SHIFT + code:20", hl.dsp.window.resize({ x = 0, y = -100, relative = true }),  { description = "Shrink window up" })
hl.bind(mainMod .. " + SHIFT + code:21", hl.dsp.window.resize({ x = 0, y = 100, relative = true }),   { description = "Expand window down" })

-- Scroll through existing workspaces with SUPER + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { description = "Scroll workspace forward" })
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }), { description = "Scroll workspace backward" })

-- Move/resize windows with SUPER + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true, description = "Move window" })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window" })

-- Toggle and leave groups
hl.bind(mainMod .. " + G",        hl.dsp.group.toggle(),                  { description = "Toggle window grouping" })
hl.bind(mainMod .. " + ALT + G",  hl.dsp.window.move({ out_of_group = true }), { description = "Move window out of group" })

-- Join groups by direction
hl.bind(mainMod .. " + ALT + LEFT",  hl.dsp.window.move({ into_group = "left" }),  { description = "Window into group on left" })
hl.bind(mainMod .. " + ALT + RIGHT", hl.dsp.window.move({ into_group = "right" }), { description = "Window into group on right" })
hl.bind(mainMod .. " + ALT + UP",    hl.dsp.window.move({ into_group = "up" }),    { description = "Window into group above" })
hl.bind(mainMod .. " + ALT + DOWN",  hl.dsp.window.move({ into_group = "down" }),  { description = "Window into group below" })

-- Navigate a group or set of grouped windows
hl.bind(mainMod .. " + ALT + TAB",         hl.dsp.group.next(), { description = "Next window in group" })
hl.bind(mainMod .. " + ALT + SHIFT + TAB", hl.dsp.group.prev(), { description = "Previous window in group" })

hl.bind(mainMod .. " + CTRL + LEFT",  hl.dsp.group.prev(), { description = "Group focus left" })
hl.bind(mainMod .. " + CTRL + RIGHT", hl.dsp.group.next(), { description = "Group focus right" })

-- Scroll through grouped windows with SUPER + ALT + scroll
hl.bind(mainMod .. " + ALT + mouse_down", hl.dsp.group.next(), { description = "Next window in group" })
hl.bind(mainMod .. " + ALT + mouse_up",   hl.dsp.group.prev(), { description = "Previous window in group" })

-- Activate window in a group by number
for i = 1, 5 do
    hl.bind(mainMod .. " + ALT + code:" .. (9 + i), hl.dsp.group.active({ index = i }), { description = "Group window " .. i })
end