-- Application launchers. Every binding here goes through programs.lua, so a
-- machine without (say) a file manager installed simply doesn't get that key.

local programs = require("programs")

o.bind("SUPER + RETURN", "Terminal", programs.terminal and o.launch(programs.terminal))
o.bind("SUPER + SHIFT + RETURN", "Browser", programs.browser and o.launch(programs.browser))
o.bind("SUPER + SHIFT + B", "Browser", programs.browser and o.launch(programs.browser))
o.bind("SUPER + SHIFT + ALT + B", "Browser (private)", programs.browser_private and o.launch(programs.browser_private))
o.bind("SUPER + SHIFT + F", "File manager", programs.filemanager)
o.bind("SUPER + SHIFT + N", "Editor", programs.editor)
o.bind("SUPER + CTRL + T", "Activity", programs.activity_monitor and programs.terminal_exec(programs.activity_monitor))
o.bind("SUPER + CTRL + A", "Audio mixer", programs.audio_mixer)

-- Add your own the same way:
-- o.bind("SUPER + SHIFT + S", "SSH", { tui = "ssh your-server" })
-- o.bind("SUPER + SHIFT + O", "Obsidian", { launch = "obsidian" })
-- o.bind("SUPER + SHIFT + Y", "YouTube", { webapp = "https://youtube.com" })
