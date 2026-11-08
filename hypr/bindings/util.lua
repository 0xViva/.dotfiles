
-- Universal copy/paste: SUPER+C/V send the focused app's native clipboard
-- chord, using the terminal chord in terminals. The explicit down/up split
-- avoids a stuck synthetic key state.
local terminal_classes = {
    Alacritty = true,
    ["com.mitchellh.ghostty"] = true,
    foot = true,
    kitty = true,
}

local function send_shortcut_once(mods, key)
    return function()
        hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "down" }))
        hl.timer(function()
            hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "up" }))
        end, { timeout = 50, type = "oneshot" })
    end
end

local function universal_clipboard_shortcut(default_mods, default_key, terminal_mods, terminal_key)
    return function()
        local window = hl.get_active_window()
        local mods, key = default_mods, default_key
        if window and terminal_classes[window.class] then
            mods, key = terminal_mods, terminal_key
        end
        send_shortcut_once(mods, key)()
    end
end

hl.bind(mainMod .. " + C", universal_clipboard_shortcut("CTRL", "C", "CTRL SHIFT", "C"), { description = "Copy" })
hl.bind(mainMod .. " + V", universal_clipboard_shortcut("CTRL", "V", "CTRL SHIFT", "V"), { description = "Paste" })

hl.bind(mainMod .. " + SHIFT + COMMA", hl.dsp.exec_cmd("noctalia msg notification-clear-active"), { description = "Clear active notifications" })
hl.bind(mainMod .. " + CTRL + COMMA",  hl.dsp.exec_cmd("noctalia msg notification-dnd-toggle"), { description = "Toggle Do Not Disturb" })
hl.bind(mainMod .. " + ALT + COMMA",   hl.dsp.exec_cmd("noctalia msg notification-invoke-latest"), { description = "Invoke last notification" })

hl.bind("PRINT",         hl.dsp.exec_cmd("noctalia msg screenshot-region"), { description = "Screenshot region" })
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("noctalia msg screenshot-fullscreen"), { description = "Screenshot fullscreen" })
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("pkill hyprpicker || hyprpicker -a"), { description = "Color picker" })

hl.bind("ALT + PRINT",            hl.dsp.exec_cmd("$HOME/.config/bin/cmd-screenrecord --with-desktop-audio"), { description = "Record screen with audio" })
hl.bind(mainMod .. " + ALT + PRINT", hl.dsp.exec_cmd("$HOME/.config/bin/cmd-screenrecord --stop-recording"), { description = "Stop recording" })

hl.bind(mainMod .. " + CTRL + N", hl.dsp.exec_cmd("noctalia msg nightlight-force-toggle"), { description = "Toggle nightlight" })

hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("noctalia msg session lock"), { locked = true, description = "Lock screen" })
