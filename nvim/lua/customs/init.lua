_G.Customs = _G.Customs or {}

local M = {}

function Customs.register(name, plugin)
  _G.Customs[name] = plugin
end

function M.setup()
  Customs.register('scratchy', require 'customs.scratchy')
  Customs.register('center_mode', require 'customs.center-mode')
  Customs.register('toggle_terminal', require 'customs.toggle-terminal')
  Customs.register('switch_pnpm_version', require 'customs.switch-pnpm-version')
  Customs.register('yankee', require 'customs.yankee')
end

return M
