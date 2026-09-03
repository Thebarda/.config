-- Stand-ins for the Omarchy `o.*` helpers, loaded only when this config runs
-- on a Hyprland install that has no Omarchy underneath it (see hyprland.lua).
--
-- Everything here maps onto the native `hl.*` API, which ships with Hyprland
-- itself (0.56+, stubs in /usr/share/hypr/stubs/hl.meta.lua). Keep it that way:
-- if a helper can't be expressed in plain `hl.*`, it doesn't belong in here.
--
-- This is deliberately a subset. It covers what ~/.config/hypr actually calls,
-- not all of Omarchy's helpers.lua.

o = o or {}

local function file_exists(path)
  local file = io.open(path, "r")
  if file then
    file:close()
    return true
  end

  return false
end

-- Is `command` runnable? Used to guard bindings on tools that only exist on
-- some machines, so a missing binary drops one binding instead of erroring.
function o.cmd_present(command)
  if command:find("/", 1, true) then
    return file_exists(command)
  end

  local path = os.getenv("PATH") or "/usr/local/bin:/usr/bin"
  for directory in (path .. ":"):gmatch("([^:]*):") do
    if file_exists((directory ~= "" and directory or ".") .. "/" .. command) then
      return true
    end
  end

  return false
end

function o.cmd_missing(command)
  return not o.cmd_present(command)
end

-- Omarchy routes launches through uwsm so apps land in their own systemd
-- scope. Off Omarchy, use uwsm if it happens to be installed and otherwise
-- just run the command.
function o.launch(command)
  if o.cmd_present("uwsm-app") then
    return "uwsm-app -- " .. command
  end

  return command
end

function o.bind(keys, description, dispatcher, options)
  local opts = options or {}

  if description then
    opts.description = description
  end

  -- Omarchy's table forms ({ launch = ... }, { tui = ... }, { webapp = ... })
  -- resolve to omarchy-launch-* wrappers that don't exist here. Take the plain
  -- command out of the table and run it directly.
  if type(dispatcher) == "table" then
    local command = dispatcher.launch or dispatcher.tui
    if command then
      dispatcher = o.launch(command)
    elseif dispatcher.webapp then
      dispatcher = o.launch((os.getenv("BROWSER") or "xdg-open") .. " " .. dispatcher.webapp)
    end
  end

  if type(dispatcher) == "string" then
    dispatcher = hl.dsp.exec_cmd(dispatcher)
  end

  hl.bind(keys, dispatcher, opts)
end

function o.window(match, rules)
  rules.match = rules.match or {}

  if type(match) == "string" then
    rules.match.class = match
  else
    for key, value in pairs(match) do
      rules.match[key] = value
    end
  end

  hl.window_rule(rules)
end

function o.exec_on_start(command)
  hl.on("hyprland.start", function()
    hl.exec_cmd(command)
  end)
end

function o.launch_on_start(command)
  o.exec_on_start(o.launch(command))
end
