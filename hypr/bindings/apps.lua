-- Application bindings

hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("walker --width 644 --maxheight 300 --minheight 300"), { description = "Launch apps" })
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal), { description = "Terminal" })
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.exec_cmd(fileManager .. " --new-window"), { description = "File manager" })
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser), { description = "Browser" })
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(editor), { description = "Editor" })