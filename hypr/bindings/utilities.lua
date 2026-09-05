-- Launcher, capture, session, and the small desktop toggles.

local programs = require("programs")

-- Launcher -------------------------------------------------------------------

o.bind("SUPER + SPACE", "Application launcher", programs.launcher)
o.bind("SUPER + ALT + SPACE", "Application launcher", programs.launcher)
o.bind("SUPER + K", "Keybindings", programs.keybindings)

-- Capture --------------------------------------------------------------------

o.bind("PRINT", "Screenshot region", programs.screenshot_region)
o.bind("SHIFT + PRINT", "Screenshot screen", programs.screenshot_output)
o.bind("ALT + PRINT", "Screenshot window", programs.screenshot_window)
o.bind("SUPER + PRINT", "Colour picker", programs.color_picker)

-- Notifications --------------------------------------------------------------

-- xkbcommon names the comma keysym "comma"; upper-case "COMMA" does not match.
o.bind("SUPER + comma", "Dismiss last notification", programs.notification_dismiss)
o.bind("SUPER + SHIFT + comma", "Dismiss all notifications", programs.notification_dismiss_all)

-- Session --------------------------------------------------------------------

o.bind("SUPER + CTRL + L", "Lock system", programs.lock)
o.bind("SUPER + SHIFT + ESCAPE", "Exit Hyprland", hl.dsp.exit())

-- Display toggles ------------------------------------------------------------

-- Hide the status bar. Waybar toggles its own visibility on SIGUSR1.
if programs.bar == "waybar" then
	o.bind("SUPER + SHIFT + SPACE", "Toggle top bar", "pkill -SIGUSR1 waybar")
end

-- Make the focused window fully opaque, for when transparency is in the way.
o.bind("SUPER + BACKSPACE", "Toggle window transparency", function()
	local window = hl.get_active_window()
	if window then
		hl.dispatch(hl.dsp.window.set_prop({ window = window, prop = "opaque", value = "toggle" }))
	end
end)

-- Gaps off for one screenshot or a dense side-by-side comparison, then back.
local default_gaps = 4
local gaps_hidden = false

o.bind("SUPER + SHIFT + BACKSPACE", "Toggle window gaps", function()
	gaps_hidden = not gaps_hidden
	local gaps = gaps_hidden and 0 or default_gaps

	hl.config({
		general = {
			gaps_in = gaps,
			gaps_out = gaps,
			gaps_workspaces = gaps,
			float_gaps = gaps,
		},
	})
end)

-- Magnify the whole screen around the cursor.
o.bind("SUPER + CTRL + Z", "Zoom in", function()
	hl.config({ cursor = { zoom_factor = (hl.get_config("cursor.zoom_factor") or 1) + 1 } })
end)

o.bind("SUPER + CTRL + SHIFT + Z", "Zoom out", function()
	hl.config({ cursor = { zoom_factor = math.max((hl.get_config("cursor.zoom_factor") or 1) - 1, 1) } })
end)

o.bind("SUPER + CTRL + ALT + Z", "Reset zoom", function()
	hl.config({ cursor = { zoom_factor = 1 } })
end)

-- Warm the screen at night. hyprsunset has to be running (see autostart.lua);
-- hyprsunset.conf in this directory keeps it neutral until this is switched on.
if o.cmd_present("hyprsunset") then
	local nightlight = false

	o.bind("SUPER + CTRL + N", "Toggle nightlight", function()
		nightlight = not nightlight

		if nightlight then
			hl.exec_cmd("hyprctl hyprsunset temperature 4000")
		else
			hl.exec_cmd("hyprctl hyprsunset identity")
		end

		hl.exec_cmd(o.notify("Nightlight " .. (nightlight and "on" or "off"), { urgency = "low" }))
	end)
end
