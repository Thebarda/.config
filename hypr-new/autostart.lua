-- What starts with the session.
--
-- Each of these is skipped when the program isn't installed, so this file is
-- safe as-is on a machine with nothing but Hyprland on it.

local programs = require("programs")

hl.on("hyprland.start", function()
  -- Hand the session environment to systemd and D-Bus before anything else
  -- starts. Without this, user services and portals launch with an empty
  -- WAYLAND_DISPLAY and apps take seconds to open (or fail outright).
  hl.exec_cmd("systemctl --user import-environment $(env | cut -d'=' -f 1)")
  hl.exec_cmd("dbus-update-activation-environment --systemd --all")
end)

-- Authentication dialogs for anything that needs a password (mounting disks,
-- package updates). Without an agent running, those prompts never appear.
o.launch_on_start(programs.polkit_agent)

o.launch_on_start(programs.notification_daemon)
o.launch_on_start(programs.bar)
o.launch_on_start(programs.wallpaper_daemon)
o.launch_on_start(programs.idle_daemon)

-- Keeps clipboard history for SUPER + CTRL + V.
o.launch_on_start(programs.clipboard_daemon)

-- Automount removable drives, if udiskie is installed.
if o.cmd_present("udiskie") then
  o.launch_on_start("udiskie --automount --no-notify --no-tray")
end

-- Night light. Reads hyprsunset.conf from this directory; the SUPER + CTRL + N
-- binding switches it on and off at runtime.
o.launch_on_start(o.cmd_present("hyprsunset") and "hyprsunset" or nil)

-- Add your own:
-- o.launch_on_start("nextcloud --background")
