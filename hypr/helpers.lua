-- Small helper layer over the native `hl.*` API.
--
-- Everything here maps onto plain `hl.*` calls, which ship with Hyprland
-- itself (0.56+, stubs in /usr/share/hypr/stubs/hl.meta.lua). Keep it that
-- way: if a helper can't be expressed in plain `hl.*`, it doesn't belong here.
--
-- The helpers exist for two reasons: `o.bind` puts the description next to the
-- keys (so `hyprctl binds` and hypr-keybindings can list them), and
-- `o.cmd_present` lets a binding disappear on a machine that lacks the tool
-- rather than failing at dispatch time.

o = o or {}

-- Every described binding, in the order it was made, so the cheatsheet can
-- list keys exactly as the config spells them. Reset on each config load,
-- which is also every `hyprctl reload`.
o.bindings = {}

o.config_dir = _G.hypr_config_dir or ((os.getenv("HOME") or "") .. "/.config/hypr")
o.bin_dir = o.config_dir .. "/bin"

function o.shell_quote(value)
  return "'" .. tostring(value):gsub("'", "'\\''") .. "'"
end

function o.file_exists(path)
  local file = io.open(path, "r")
  if file then
    file:close()
    return true
  end

  return false
end

-- Is `command` runnable? Bindings are guarded with this so a missing binary
-- drops one binding instead of erroring, which is what makes this config
-- portable to a machine where only some of the tools are installed.
function o.cmd_present(command)
  if command == nil then
    return false
  end

  -- Take the program out of a full command line ("grim -g ..." -> "grim").
  command = command:match("^%s*(%S+)") or command

  if command:find("/", 1, true) then
    return o.file_exists(command)
  end

  local path = os.getenv("PATH") or "/usr/local/bin:/usr/bin"
  for directory in (path .. ":"):gmatch("([^:]*):") do
    if o.file_exists((directory ~= "" and directory or ".") .. "/" .. command) then
      return true
    end
  end

  return false
end

function o.cmd_missing(command)
  return not o.cmd_present(command)
end

-- First installed command out of a preference list, or nil when none of them
-- are here. Entries may carry arguments; only the program name is probed.
function o.first_cmd(candidates)
  for _, candidate in ipairs(candidates) do
    if o.cmd_present(candidate) then
      return candidate
    end
  end

  return nil
end

-- Hyprland reaps its own children, so os.execute() can't retrieve an exit
-- status from inside the compositor. Read a marker off stdout instead.
function o.shell_succeeds(command)
  -- Subshell, so the redirection covers every command rather than binding to
  -- the last one and letting an earlier one write its own OK into the pipe.
  local pipe = io.popen("( " .. command .. " ) >/dev/null 2>&1 && echo OK")
  if not pipe then
    return false
  end

  local output = pipe:read("*a") or ""
  pipe:close()

  return output:find("OK", 1, true) ~= nil
end

-- Put apps in their own systemd scope where uwsm is installed, so a crashing
-- app can't take the session down with it. Plain exec everywhere else.
function o.launch(command)
  if o.cmd_present("uwsm-app") then
    return "uwsm-app -- " .. command
  end

  return command
end

function o.notify(message, options)
  local opts = options or {}

  if o.cmd_missing("notify-send") then
    return "true"
  end

  local command = "notify-send"

  if opts.urgency then
    command = command .. " -u " .. opts.urgency
  end

  return command .. " " .. o.shell_quote(message)
end

-- o.bind("SUPER + RETURN", "Terminal", "alacritty")
-- o.bind("SUPER + W", "Close window", hl.dsp.window.close())
-- o.bind("SUPER + SHIFT + N", "Editor", { launch = "code" })
-- o.bind("SUPER + CTRL + T", "Activity", { tui = "btop" })
--
-- A nil dispatcher is a no-op, so a binding whose tool is missing can be
-- written without an `if` around it.
function o.bind(keys, description, dispatcher, options)
  local opts = options or {}

  if dispatcher == nil then
    return nil
  end

  if description then
    opts.description = description
  end

  -- A table is either one of the launch shorthands above or a dispatcher
  -- built by hl.dsp.*, which passes straight through.
  if type(dispatcher) == "table" then
    local programs = require("programs")

    if dispatcher.launch then
      dispatcher = o.launch(dispatcher.launch)
    elseif dispatcher.tui then
      dispatcher = programs.terminal_exec(dispatcher.tui)
    elseif dispatcher.webapp then
      dispatcher = programs.open(dispatcher.webapp)
    end

    -- A shorthand that resolved to nothing (no terminal installed, say)
    -- drops the binding rather than binding the raw table.
    if dispatcher == nil then
      return nil
    end
  end

  if type(dispatcher) == "string" then
    dispatcher = hl.dsp.exec_cmd(dispatcher)
  end

  if description then
    table.insert(o.bindings, { keys = keys, description = description })
  end

  return hl.bind(keys, dispatcher, opts)
end

-- Dump the bindings for bin/hypr-keybindings to read. `hyprctl binds` can't
-- stand in for this: it reports an empty key and keycode 0 for anything bound
-- by scancode (code:20, the workspace number row), so a third of the list
-- would come out unreadable.
function o.write_keybindings()
  local state_home = os.getenv("XDG_STATE_HOME")

  if state_home == nil or state_home == "" then
    state_home = (os.getenv("HOME") or "") .. "/.local/state"
  end

  local directory = state_home .. "/hypr"
  os.execute("mkdir -p " .. o.shell_quote(directory))

  local file = io.open(directory .. "/keybindings.tsv", "w")
  if not file then
    return
  end

  -- A rebound key appears twice; the last binding is the one in effect.
  local seen, lines = {}, {}

  for index = #o.bindings, 1, -1 do
    local binding = o.bindings[index]

    if not seen[binding.keys] then
      seen[binding.keys] = true
      table.insert(lines, binding.keys .. "\t" .. binding.description)
    end
  end

  table.sort(lines)

  file:write(table.concat(lines, "\n"), "\n")
  file:close()
end

-- o.window("^(steam)$", { float = true })
-- o.window({ class = "^(steam)$", title = "^Friends List$" }, { size = { 460, 800 } })
function o.window(match, rules)
  rules.match = rules.match or {}

  if type(match) == "string" then
    rules.match.class = match
  else
    for key, value in pairs(match) do
      rules.match[key] = value
    end
  end

  return hl.window_rule(rules)
end

function o.exec_on_start(command)
  if command == nil then
    return
  end

  hl.on("hyprland.start", function()
    hl.exec_cmd(command)
  end)
end

function o.launch_on_start(command)
  if command == nil then
    return
  end

  o.exec_on_start(o.launch(command))
end
