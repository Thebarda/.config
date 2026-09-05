-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

-- Monitor layout is per-machine, so it's keyed by hostname. A machine with no
-- entry here falls through to Hyprland's own autodetection, which means this
-- config can be cloned onto a new box and still come up with working displays.
-- To add a machine: run `hostnamectl hostname`, then add a matching function.

local function hostname()
  local file = io.open("/etc/hostname", "r")
  if file then
    local name = file:read("*l")
    file:close()
    if name and name ~= "" then
      return (name:gsub("%s+$", ""))
    end
  end

  return os.getenv("HOSTNAME") or ""
end

local layouts = {}

-- Desktop: two 1440p panels side by side, 165 Hz primary on the left.
layouts.moojann = function()
  hl.env("GDK_SCALE", "2")

  -- Variable refresh rate (FreeSync/G-Sync). 0 = off, 1 = on, 2 = fullscreen only.
  hl.config({ misc = { vrr = 1 } })

  hl.monitor({ output = "DP-1", mode = "2560x1440@165", position = "0x0", scale = "auto" })
  hl.monitor({ output = "HDMI-A-1", mode = "2560x1440@144", position = "2560x0", scale = "auto" })
end

local layout = layouts[hostname()]

if layout then
  layout()
else
  -- Unknown machine: let Hyprland pick modes and placement for whatever is
  -- plugged in. GDK_SCALE is left alone here because it's display-dependent.
  hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
end

-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°).
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })
