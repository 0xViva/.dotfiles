
hl.bind(mainMod .. " + COMMA",             hl.dsp.exec_cmd("makoctl dismiss"), { description = "Dismiss last notification" })
hl.bind(mainMod .. " + SHIFT + COMMA",     hl.dsp.exec_cmd("makoctl dismiss --all"), { description = "Dismiss all notifications" })
hl.bind(mainMod .. " + CTRL + COMMA",      hl.dsp.exec_cmd("makoctl mode -t do-not-disturb && makoctl mode | grep -q 'do-not-disturb' && notify-send \"Silenced notifications\" || notify-send \"Enabled notifications\""), { description = "Toggle silent notifications" })
hl.bind(mainMod .. " + ALT + COMMA",       hl.dsp.exec_cmd("makoctl invoke"), { description = "Invoke last notification" })
hl.bind(mainMod .. " + SHIFT + ALT + COMMA", hl.dsp.exec_cmd("makoctl restore"), { description = "Restore last notification" })

hl.bind("PRINT",         hl.dsp.exec_cmd("$HOME/.config/bin/cmd-screenshot"), { description = "Screenshot with editing" })
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("$HOME/.config/bin/cmd-screenshot smart clipboard"), { description = "Screenshot to clipboard" })
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("pkill hyprpicker || hyprpicker -a"), { description = "Color picker" })

hl.bind("ALT + PRINT",            hl.dsp.exec_cmd("$HOME/.config/bin/cmd-screenrecord --with-desktop-audio"), { description = "Record screen with audio" })
hl.bind(mainMod .. " + ALT + PRINT", hl.dsp.exec_cmd("$HOME/.config/bin/cmd-screenrecord --stop-recording"), { description = "Stop recording" })

hl.bind(mainMod .. " + CTRL + N", hl.dsp.exec_cmd("$HOME/.config/bin/cmd-toggle-nightlight"), { description = "Toggle nightlight" })

hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"), { locked = true, description = "Lock screen" })