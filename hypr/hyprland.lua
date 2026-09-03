-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

-- This config runs both on Omarchy and on a plain Hyprland install.
--
-- On Omarchy, its bootstrap sets up the Lua module path and its defaults
-- provide the core keymap, window rules and Wayland environment.
-- Without Omarchy, we set the module path up ourselves and load hypr/compat.lua
-- for a minimal version of the `o.*` helpers. The personal overrides below are
-- identical in both cases.

local home = os.getenv("HOME")
local omarchy_path = os.getenv("OMARCHY_PATH") or "/usr/share/omarchy"

local function file_exists(path)
  local file = io.open(path, "r")
  if file then
    file:close()
    return true
  end

  return false
end

local omarchy_bootstrap = omarchy_path .. "/default/hypr/bootstrap.lua"
local on_omarchy = file_exists(omarchy_bootstrap)

if on_omarchy then
  -- Omarchy's bootstrap keeps path setup out of this user config.
  dofile(omarchy_bootstrap)
else
  -- Same job as Omarchy's bootstrap, minus the Omarchy paths: drop stale
  -- modules so `hyprctl reload` re-reads edited files, then make
  -- require("hypr.*") resolve against ~/.config.
  for module in pairs(package.loaded) do
    if module == "hypr" or module:sub(1, 5) == "hypr." then
      package.loaded[module] = nil
    end
  end

  package.path = home .. "/.config/?.lua;" .. package.path
end

-- Disable all Omarchy default bindings. Add your own in hypr/bindings.lua.
-- omarchy_default_bindings = false
--
-- Or disable only bindings for Omarchy's preinstalled apps/web apps while
-- keeping core window-manager bindings:
-- omarchy_preinstalled_bindings = false

if on_omarchy then
  -- Load Omarchy defaults.
  require("default.hypr.omarchy")
else
  -- Minimal `o.*` helpers so the files below load unchanged. Note this brings
  -- no keymap with it: off Omarchy you get only the bindings in
  -- hypr/bindings.lua, so add core window-manager bindings there.
  require("hypr.compat")
end

-- Put your personal overrides in these files. They're loaded after Omarchy's
-- defaults so package updates can improve the defaults without rewriting your
-- ~/.config/hypr files.
require("hypr.monitors")
require("hypr.input")
require("hypr.bindings")
require("hypr.looknfeel")
require("hypr.autostart")

if on_omarchy then
  -- Toggle config flags dynamically.
  require("default.hypr.toggles")
end

-- Add any other personal Hyprland configuration below.
-- o.window("qemu", { workspace = "5" })
