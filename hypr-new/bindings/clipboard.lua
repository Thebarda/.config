-- One pair of clipboard keys that works everywhere: SUPER + C / V / X copy,
-- paste, and cut in normal apps, and map to the terminal's Ctrl+Insert /
-- Shift+Insert in a terminal, where Ctrl+C is an interrupt.

local programs = require("programs")

-- Send with explicit mods to the focused surface by omitting the window
-- target, so the shortcut reaches layer-shell surfaces (launchers, panels) as
-- well as normal windows. A virtual keyboard won't do: the physically held
-- SUPER merges into the injected chord at the seat. The down/up split works
-- around Hyprland sometimes leaving synthetic key state stuck.
-- https://github.com/hyprwm/Hyprland/discussions/14099
local function send_shortcut_once(mods, key)
  return function()
    hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "down" }))

    hl.timer(function()
      hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "up" }))
    end, { timeout = 50, type = "oneshot" })
  end
end

-- Leans on the terminal tag from windows.lua so there's one definition of what
-- counts as a terminal. Dynamic tags carry a trailing "*".
local function active_window_is_terminal()
  local window = hl.get_active_window()
  if not window then
    return false
  end

  for _, tag in ipairs(window.tags or {}) do
    if tag:gsub("%*$", "") == "terminal" then
      return true
    end
  end

  return false
end

local function universal_clipboard_shortcut(default_mods, default_key, terminal_mods, terminal_key)
  return function()
    if active_window_is_terminal() then
      send_shortcut_once(terminal_mods, terminal_key)()
    else
      send_shortcut_once(default_mods, default_key)()
    end
  end
end

o.bind("SUPER + C", "Universal copy", universal_clipboard_shortcut("CTRL", "C", "CTRL", "Insert"))
o.bind("SUPER + V", "Universal paste", universal_clipboard_shortcut("CTRL", "V", "SHIFT", "Insert"))
o.bind("SUPER + X", "Universal cut", send_shortcut_once("CTRL", "X"))

-- Needs cliphist, wl-clipboard, and a launcher with a list mode.
o.bind("SUPER + CTRL + V", "Clipboard history", programs.clipboard_history)
