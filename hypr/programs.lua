-- Which program handles what.
--
-- This is the file to edit first on a new machine. Every entry picks the first
-- candidate that is actually installed, so the config comes up sensibly on a
-- bare system; to pin a choice, replace the o.first_cmd({...}) call with the
-- command you want. An entry that stays nil silently drops the bindings and
-- autostarts that would have used it.

local M = {}

-- Terminal -------------------------------------------------------------------

M.terminal = os.getenv("TERMINAL") or o.first_cmd({
	"ghostty",
	"alacritty",
	"kitty",
	"foot",
	"wezterm",
	"gnome-terminal",
	"konsole",
	"xterm",
})

-- How each terminal takes "run this command instead of a shell". An unlisted
-- terminal gets -e, which is what most of them use.
local terminal_exec_flag = {
	ghostty = "-e",
	alacritty = "-e",
	kitty = "",
	foot = "",
	wezterm = "start --",
	["gnome-terminal"] = "--",
	konsole = "-e",
	xterm = "-e",
}

-- A command line that runs `command` in a new terminal window. Wrapped in a
-- login shell so PATH and aliases from the user's profile apply.
function M.terminal_exec(command)
	if not M.terminal then
		return nil
	end

	local name = M.terminal:match("([^/]+)$")
	local flag = terminal_exec_flag[name] or "-e"
	local parts = { M.terminal }

	if flag ~= "" then
		table.insert(parts, flag)
	end

	table.insert(parts, "bash -lc " .. o.shell_quote(command))

	return o.launch(table.concat(parts, " "))
end

-- Browser --------------------------------------------------------------------

M.browser = os.getenv("BROWSER") or o.first_cmd({
	"chromium",
	"google-chrome-stable",
	"brave",
	"firefox",
	"librewolf",
	"zen-browser",
	"epiphany",
})

-- Chromium and Firefox families spell "private window" differently.
local browser_private_flag = {
	chromium = "--incognito",
	["google-chrome-stable"] = "--incognito",
	brave = "--incognito",
	["microsoft-edge"] = "--inprivate",
	firefox = "--private-window",
	librewolf = "--private-window",
	["zen-browser"] = "--private-window",
	epiphany = "--incognito-mode",
}

if M.browser then
	local flag = browser_private_flag[M.browser:match("([^/]+)$")]
	M.browser_private = flag and (M.browser .. " " .. flag) or nil
end

-- Opening a URL or a file: the desktop's own handler first, the browser as a
-- fallback on a system with no xdg-utils.
function M.open(target)
	if o.cmd_present("xdg-open") then
		return "xdg-open " .. o.shell_quote(target)
	end

	if M.browser then
		return M.browser .. " " .. o.shell_quote(target)
	end

	return nil
end

-- Editor and file manager ----------------------------------------------------

local gui_editor = o.first_cmd({ "code", "zed", "cursor", "gnome-text-editor", "kate", "gedit" })
local tui_editor = o.first_cmd({ os.getenv("EDITOR") or "nvim", "nvim", "hx", "helix", "vim", "nano" })

M.editor = gui_editor and o.launch(gui_editor) or (tui_editor and M.terminal_exec(tui_editor))

M.filemanager = o.first_cmd({ "nautilus", "thunar", "dolphin", "nemo", "pcmanfm-qt", "pcmanfm" })

if M.filemanager then
	M.filemanager = o.launch(M.filemanager)
end

M.activity_monitor = o.first_cmd({ "btop", "htop", "top" })

-- Launcher -------------------------------------------------------------------

-- Each entry is { app launcher, list picker }. The list picker reads choices on
-- stdin and prints the chosen line, which is what the clipboard history and
-- keybinding cheatsheet need.
local launchers = {
	{ cmd = "fuzzel",     run = "fuzzel",                             dmenu = "fuzzel --dmenu" },
	{ cmd = "wofi",       run = "wofi --show drun",                   dmenu = "wofi --show dmenu" },
	{ cmd = "rofi",       run = "rofi -show drun",                    dmenu = "rofi -dmenu" },
	{ cmd = "tofi-drun",  run = "tofi-drun",                          dmenu = "tofi" },
	{ cmd = "bemenu-run", run = "bemenu-run",                         dmenu = "bemenu" },
	{ cmd = "walker",     run = "walker",                             dmenu = "walker --dmenu" },
	{ cmd = "noctalia",   run = "noctalia msg panel-toggle launcher", demnu = "" }
}

for _, launcher in ipairs(launchers) do
	if o.cmd_present(launcher.cmd) then
		M.launcher = launcher.run
		M.dmenu = launcher.dmenu
		break
	end
end

-- Session --------------------------------------------------------------------

M.lock = o.first_cmd({ "hyprlock", "swaylock", "waylock" })

M.bar = o.first_cmd({ "waybar" })
M.idle_daemon = o.first_cmd({ "hypridle" })
M.wallpaper_daemon = o.first_cmd({ "hyprpaper" })
M.notification_daemon = o.first_cmd({ "mako", "dunst", "swaync" })

-- Dismissing notifications is per-daemon; nil leaves those bindings out.
if o.cmd_present("makoctl") then
	M.notification_dismiss = "makoctl dismiss"
	M.notification_dismiss_all = "makoctl dismiss --all"
elseif o.cmd_present("dunstctl") then
	M.notification_dismiss = "dunstctl close"
	M.notification_dismiss_all = "dunstctl close-all"
elseif o.cmd_present("swaync-client") then
	M.notification_dismiss = "swaync-client --close-latest"
	M.notification_dismiss_all = "swaync-client --close-all"
end

M.polkit_agent = o.first_cmd({
	"/usr/lib/hyprpolkitagent/hyprpolkitagent",
	"/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1",
	"/usr/lib/polkit-kde-authentication-agent-1",
	"lxqt-policykit-agent",
})

-- Audio ----------------------------------------------------------------------

-- wpctl talks to PipeWire directly and is what a modern install has;
-- pactl covers PulseAudio and the pipewire-pulse shim.
if o.cmd_present("wpctl") then
	local sink = "@DEFAULT_AUDIO_SINK@"
	local source = "@DEFAULT_AUDIO_SOURCE@"

	-- -l 1.0 caps the volume at 100% so a held key can't push it past unity.
	M.volume_up = "wpctl set-volume -l 1.0 " .. sink .. " 5%+"
	M.volume_down = "wpctl set-volume " .. sink .. " 5%-"
	M.volume_up_precise = "wpctl set-volume -l 1.0 " .. sink .. " 1%+"
	M.volume_down_precise = "wpctl set-volume " .. sink .. " 1%-"
	M.volume_mute = "wpctl set-mute " .. sink .. " toggle"
	M.mic_mute = "wpctl set-mute " .. source .. " toggle"
elseif o.cmd_present("pactl") then
	local sink = "@DEFAULT_SINK@"
	local source = "@DEFAULT_SOURCE@"

	M.volume_up = "pactl set-sink-volume " .. sink .. " +5%"
	M.volume_down = "pactl set-sink-volume " .. sink .. " -5%"
	M.volume_up_precise = "pactl set-sink-volume " .. sink .. " +1%"
	M.volume_down_precise = "pactl set-sink-volume " .. sink .. " -1%"
	M.volume_mute = "pactl set-sink-mute " .. sink .. " toggle"
	M.mic_mute = "pactl set-source-mute " .. source .. " toggle"
end

M.audio_mixer = o.first_cmd({ "pavucontrol", "pwvucontrol" })

if not M.audio_mixer and o.cmd_present("wiremix") then
	M.audio_mixer = M.terminal_exec("wiremix")
elseif M.audio_mixer then
	M.audio_mixer = o.launch(M.audio_mixer)
end

-- Brightness -----------------------------------------------------------------

if o.cmd_present("brightnessctl") then
	M.brightness_up = "brightnessctl set 5%+"
	M.brightness_down = "brightnessctl set 5%-"
	M.brightness_up_precise = "brightnessctl set 1%+"
	M.brightness_down_precise = "brightnessctl set 1%-"
	M.brightness_max = "brightnessctl set 100%"
	M.brightness_min = "brightnessctl set 1%"
	-- Laptop keyboard backlights show up as a separate device.
	M.kbd_brightness_up = "brightnessctl --device='*kbd_backlight' set +10%"
	M.kbd_brightness_down = "brightnessctl --device='*kbd_backlight' set 10%-"
elseif o.cmd_present("light") then
	M.brightness_up = "light -A 5"
	M.brightness_down = "light -U 5"
	M.brightness_up_precise = "light -A 1"
	M.brightness_down_precise = "light -U 1"
	M.brightness_max = "light -S 100"
	M.brightness_min = "light -S 1"
end

-- Media players --------------------------------------------------------------

if o.cmd_present("playerctl") then
	M.media_play_pause = "playerctl play-pause"
	M.media_next = "playerctl next"
	M.media_previous = "playerctl previous"
end

-- Screen capture -------------------------------------------------------------

-- The vendored script keeps region/window/output capture behaving the same
-- way (clipboard + a dated file); the others are fallbacks for a machine that
-- has one of them installed instead of grim.
if o.cmd_present("grim") and o.cmd_present(o.bin_dir .. "/hypr-screenshot") then
	M.screenshot_region = o.bin_dir .. "/hypr-screenshot region"
	M.screenshot_window = o.bin_dir .. "/hypr-screenshot window"
	M.screenshot_output = o.bin_dir .. "/hypr-screenshot output"
elseif o.cmd_present("grimblast") then
	M.screenshot_region = "grimblast copysave area"
	M.screenshot_window = "grimblast copysave active"
	M.screenshot_output = "grimblast copysave output"
elseif o.cmd_present("hyprshot") then
	M.screenshot_region = "hyprshot -m region"
	M.screenshot_window = "hyprshot -m window"
	M.screenshot_output = "hyprshot -m output"
end

-- hyprpicker prints the colour under the cursor; -a puts it on the clipboard.
if o.cmd_present("hyprpicker") then
	M.color_picker = "pkill hyprpicker || hyprpicker -a"
end

-- Clipboard ------------------------------------------------------------------

-- cliphist stores the history; the launcher's list mode picks an entry out of
-- it and wl-copy puts it back on the clipboard.
if o.cmd_present("cliphist") and o.cmd_present("wl-copy") and M.dmenu then
	M.clipboard_daemon = "wl-paste --watch cliphist store"
	M.clipboard_history = "cliphist list | " .. M.dmenu .. " | cliphist decode | wl-copy"
end

-- Vendored helpers -----------------------------------------------------------

M.keybindings = o.cmd_present(o.bin_dir .. "/hypr-keybindings") and (o.bin_dir .. "/hypr-keybindings") or nil

M.invert_columns = o.cmd_present(o.bin_dir .. "/hypr-workspace-invert-columns")
		and (o.bin_dir .. "/hypr-workspace-invert-columns")
		or nil

return M
