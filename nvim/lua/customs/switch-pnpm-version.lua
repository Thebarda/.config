local M = {}

local function split(str, sep)
  local result = {}
  for part in string.gmatch(str, '([^' .. sep .. ']+)') do
    table.insert(result, part)
  end
  return result
end

local function switchPNPM(version)
  local major_version = split(version, '.')[1]

  vim.fn.system('curl -fsSL https://get.pnpm.io/install.sh | env PNPM_VERSION=' .. version .. ' sh -')
  local exit_code = vim.v.shell_error

  if exit_code ~= 0 then
    vim.notify('Fail to switch to PNPM ' .. major_version)
  else
    vim.notify('Successfully switched to PNPM ' .. major_version)
  end
end

function M.switchTo7()
  switchPNPM '7.33.7'
end

function M.switchTo8()
  switchPNPM '8.15.7'
end

function M.switchTo10()
  switchPNPM '10.11.1'
end

return M
