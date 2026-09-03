-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- `o.cmd_present` searches the compositor's own PATH, and Omarchy's bin dir
-- isn't in it (Omarchy prepends that via hl.env, which only reaches processes
-- it spawns). So probe absolute paths here, but dispatch by the plain name.
local omarchy_bin = (os.getenv("OMARCHY_PATH") or "/usr/share/omarchy") .. "/bin"

-- Workspace overview, drawn by the Omarchy shell. Skipped where it's absent.
if o.cmd_present(omarchy_bin .. "/omarchy-shell") then
	o.bind("SHIFT + TAB", "Workspace overview", "omarchy-shell shell toggle mirador '{}'")
end

-- Swap the left and right columns of the current workspace. Prefer the copy
-- vendored alongside this config so the binding travels with the repo, then
-- fall back to one installed on PATH.
local invert_columns = (os.getenv("HOME") or "") .. "/.config/hypr/bin/hypr-workspace-invert-columns"

if o.cmd_missing(invert_columns) then
	invert_columns = "hypr-workspace-invert-columns"
end

if o.cmd_present(invert_columns) then
	o.bind("SUPER + SHIFT + J", "Invert workspace columns", invert_columns)
end
