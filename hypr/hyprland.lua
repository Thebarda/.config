-- Hyprland configuration for a bare Hyprland install.
--
-- Nothing here needs Omarchy, a distro, or any wrapper script. Everything is
-- either the native `hl.*` Lua API that ships with Hyprland 0.56+ (stubs in
-- /usr/share/hypr/stubs/hl.meta.lua) or a plain command looked up on PATH when
-- the config loads. A tool that isn't installed drops the bindings that need
-- it instead of breaking the config, so this comes up on a fresh machine.
--
-- Install by putting this directory at ~/.config/hypr -- copy it, or symlink
-- the whole directory. Which programs get launched is decided in programs.lua;
-- that is the first file to read.

-- Find this file's own directory so the modules below can be required by
-- plain name no matter where the directory lives or which name it's cloned
-- under. Falls back to the standard location if Hyprland ever hands us a
-- source path we can't split.
local config_dir = debug.getinfo(1, "S").source:sub(2):match("^(.*)/[^/]*$")

if not config_dir or config_dir == "" then
  config_dir = (os.getenv("HOME") or "") .. "/.config/hypr"
end

_G.hypr_config_dir = config_dir

package.path = config_dir .. "/?.lua;" .. config_dir .. "/?/init.lua;" .. package.path

-- Load order matters: helpers defines the `o.*` shorthands the rest of the
-- files use, and programs resolves the commands the bindings dispatch to.
local modules = {
  "helpers",
  "programs",
  "envs",
  "monitors",
  "input",
  "looknfeel",
  "windows",
  "bindings.tiling",
  "bindings.apps",
  "bindings.media",
  "bindings.clipboard",
  "bindings.utilities",
  "autostart",
}

-- Hyprland keeps one Lua state across `hyprctl reload`, so drop our modules
-- from the cache first or a reload would silently keep the old ones.
for _, module in ipairs(modules) do
  package.loaded[module] = nil
end

for _, module in ipairs(modules) do
  require(module)
end

-- Personal tweaks that shouldn't collide with updates to the files above.
-- Create local.lua to use it: it's optional, and loaded last so it wins.
package.loaded["local"] = nil

if package.searchpath("local", package.path) then
  require("local")
end

-- Write the keybinding cheatsheet that SUPER + K reads, now that every
-- module (local.lua included) has had its say.
o.write_keybindings()
