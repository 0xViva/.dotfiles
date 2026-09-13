
hl.bind(mainMod .. " + SHIFT + COMMA", hl.dsp.exec_cmd("noctalia msg notification-clear-active"), { description = "Clear active notifications" })
hl.bind(mainMod .. " + CTRL + COMMA",  hl.dsp.exec_cmd("noctalia msg notification-dnd-toggle"), { description = "Toggle Do Not Disturb" })
hl.bind(mainMod .. " + ALT + COMMA",   hl.dsp.exec_cmd("noctalia msg notification-invoke-latest"), { description = "Invoke last notification" })

hl.bind("PRINT",         hl.dsp.exec_cmd("$HOME/.config/bin/cmd-screenshot"), { description = "Screenshot with editing" })
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("$HOME/.config/bin/cmd-screenshot smart clipboard"), { description = "Screenshot to clipboard" })
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("pkill hyprpicker || hyprpicker -a"), { description = "Color picker" })

hl.bind("ALT + PRINT",            hl.dsp.exec_cmd("$HOME/.config/bin/cmd-screenrecord --with-desktop-audio"), { description = "Record screen with audio" })
hl.bind(mainMod .. " + ALT + PRINT", hl.dsp.exec_cmd("$HOME/.config/bin/cmd-screenrecord --stop-recording"), { description = "Stop recording" })

hl.bind(mainMod .. " + CTRL + N", hl.dsp.exec_cmd("noctalia msg nightlight-force-toggle"), { description = "Toggle nightlight" })

hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("noctalia msg session lock"), { locked = true, description = "Lock screen" })
