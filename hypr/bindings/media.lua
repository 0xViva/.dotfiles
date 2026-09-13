
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("noctalia msg volume-up"),   { locked = true, repeating = true, description = "Volume up" })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("noctalia msg volume-down"), { locked = true, repeating = true, description = "Volume down" })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("noctalia msg volume-mute"), { locked = true, repeating = true, description = "Mute" })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("noctalia msg mic-mute"),    { locked = true, repeating = true, description = "Mute microphone" })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("noctalia msg brightness-up"),   { locked = true, repeating = true, description = "Brightness up" })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("noctalia msg brightness-down"), { locked = true, repeating = true, description = "Brightness down" })

hl.bind("ALT + XF86AudioRaiseVolume", hl.dsp.exec_cmd("noctalia msg volume-up 1"),   { locked = true, repeating = true, description = "Volume up precise" })
hl.bind("ALT + XF86AudioLowerVolume", hl.dsp.exec_cmd("noctalia msg volume-down 1"), { locked = true, repeating = true, description = "Volume down precise" })
hl.bind("ALT + XF86MonBrightnessUp",   hl.dsp.exec_cmd("noctalia msg brightness-up current 1"),   { locked = true, repeating = true, description = "Brightness up precise" })
hl.bind("ALT + XF86MonBrightnessDown", hl.dsp.exec_cmd("noctalia msg brightness-down current 1"), { locked = true, repeating = true, description = "Brightness down precise" })

hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("noctalia msg media next"),     { locked = true, description = "Next track" })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("noctalia msg media toggle"),   { locked = true, description = "Play/Pause" })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("noctalia msg media toggle"),   { locked = true, description = "Play/Pause" })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("noctalia msg media previous"), { locked = true, description = "Previous track" })
