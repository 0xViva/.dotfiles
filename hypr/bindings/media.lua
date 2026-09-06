-- Media keys with a swayosd OSD on the currently focused monitor

local osd = "swayosd-client --monitor \"$(hyprctl monitors -j | jq -r '.[] | select(.focused == true).name')\""

-- Volume and LCD brightness (with OSD), also while locked
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd(osd .. " --output-volume raise"),       { locked = true, repeating = true, description = "Volume up" })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd(osd .. " --output-volume lower"),       { locked = true, repeating = true, description = "Volume down" })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd(osd .. " --output-volume mute-toggle"), { locked = true, repeating = true, description = "Mute" })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd(osd .. " --input-volume mute-toggle"),  { locked = true, repeating = true, description = "Mute microphone" })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd(osd .. " --brightness raise"),          { locked = true, repeating = true, description = "Brightness up" })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(osd .. " --brightness lower"),          { locked = true, repeating = true, description = "Brightness down" })

-- Precise 1% adjustments with ALT
hl.bind("ALT + XF86AudioRaiseVolume",  hl.dsp.exec_cmd(osd .. " --output-volume +1"),    { locked = true, repeating = true, description = "Volume up precise" })
hl.bind("ALT + XF86AudioLowerVolume",  hl.dsp.exec_cmd(osd .. " --output-volume -1"),    { locked = true, repeating = true, description = "Volume down precise" })
hl.bind("ALT + XF86MonBrightnessUp",   hl.dsp.exec_cmd(osd .. " --brightness +1"),       { locked = true, repeating = true, description = "Brightness up precise" })
hl.bind("ALT + XF86MonBrightnessDown", hl.dsp.exec_cmd(osd .. " --brightness -1"),       { locked = true, repeating = true, description = "Brightness down precise" })

-- Player controls (requires playerctl)
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd(osd .. " --playerctl next"),       { locked = true, description = "Next track" })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(osd .. " --playerctl play-pause"), { locked = true, description = "Play/Pause" })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd(osd .. " --playerctl play-pause"), { locked = true, description = "Play/Pause" })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd(osd .. " --playerctl previous"),   { locked = true, description = "Previous track" })