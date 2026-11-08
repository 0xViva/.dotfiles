-- Personal bindings on top of Omarchy's defaults. Everything else stays as
-- Omarchy ships it; use o.rebind() when replacing a default outright.

o.bind("SUPER + B", "Browser", { omarchy = "browser" })
o.bind("SUPER + N", "Editor", { omarchy = "editor" })
o.bind("SHIFT + PRINT", "Screenshot fullscreen", "omarchy-capture-screenshot fullscreen")
