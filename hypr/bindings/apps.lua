
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"), { description = "Launch apps" })
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal), { description = "Terminal" })
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.exec_cmd(fileManager .. " --new-window"), { description = "File manager" })
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser), { description = "Browser" })
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(editor), { description = "Editor" })