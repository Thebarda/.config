-- Environment handed to everything Hyprland spawns.
-- https://wiki.hypr.land/Configuring/Environment-variables/

-- Cursor size. Set both: the second is for apps using hyprcursor themes.
hl.env("XCURSOR_SIZE", "32")
hl.env("XCUSORS_THEME", "Bibata-Mordern-Classic")
hl.env("HYPRCURSOR_SIZE", "32")

-- Prefer Wayland everywhere, with XWayland only as a fallback.
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "gtk3")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("OZONE_PLATFORM", "wayland")
hl.env("XDG_SESSION_TYPE", "wayland")

-- Portals key off these, so screen sharing in Meet/Zoom/Discord needs them.
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- Dead keys and compose sequences (see input.lua) read this file.
hl.env("XCOMPOSEFILE", (os.getenv("HOME") or "") .. "/.XCompose")

-- Put this config's bin/ first on PATH. hyprctl setenv doesn't reach the
-- keybinding dispatcher's environment, so it has to happen here.
local kept = { o.bin_dir }

for entry in (os.getenv("PATH") or "/usr/local/bin:/usr/bin"):gmatch("[^:]+") do
  if entry ~= o.bin_dir then
    table.insert(kept, entry)
  end
end

hl.env("PATH", table.concat(kept, ":"))

local function read_first_line(path)
  local file = io.open(path, "r")
  if not file then
    return nil
  end

  local line = file:read("*l")
  file:close()

  return line
end

-- NVIDIA. Detected by reading the cached sysfs IDs rather than shelling out to
-- lspci: lspci reads PCI config space, which resumes a runtime-suspended GPU,
-- and on a hybrid laptop that wake alone outlasts Hyprland's reload budget.
local function nvidia_gpu()
  local devices = io.popen("find /sys/bus/pci/devices -mindepth 1 -maxdepth 1 2>/dev/null")
  if not devices then
    return nil
  end

  local found = nil

  for device in devices:lines() do
    local vendor = read_first_line(device .. "/vendor")
    local class = read_first_line(device .. "/class")

    -- 0x10de is NVIDIA; class 0x03xxxx is a display controller.
    if vendor == "0x10de" and class and class:sub(1, 4) == "0x03" then
      local id = tonumber(read_first_line(device .. "/device") or "", 16)

      -- Turing is the first generation with GSP firmware, and the first to use
      -- device IDs at 0x1e00 or above; Maxwell, Pascal and Volta sit below it.
      found = { gsp = id ~= nil and id >= 0x1e00 }
      if found.gsp then
        break
      end
    end
  end

  devices:close()

  return found
end

local nvidia = nvidia_gpu()

if nvidia then
  hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

  if nvidia.gsp then
    hl.env("LIBVA_DRIVER_NAME", "nvidia")
    hl.env("NVD_BACKEND", "direct")
  else
    hl.env("NVD_BACKEND", "egl")
  end
end

hl.config({
  -- Keep XWayland apps from rendering blurry on a scaled monitor.
  xwayland = {
    force_zero_scaling = true,
  },

  ecosystem = {
    no_update_news = true,
  },
})
