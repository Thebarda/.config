local M = {}

local augroup = vim.api.nvim_create_augroup('CenterMode', { clear = true })
local enabled = false

local function center_cursor()
  -- Only center if enabled and in a normal buffer
  if enabled and vim.bo.buftype == '' then
    vim.cmd 'normal! zz'
  end
end

function M.enable()
  if enabled then
    return
  end
  enabled = true
  vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'WinScrolled' }, {
    group = augroup,
    callback = center_cursor,
    desc = 'Keep cursor centered (CenterMode)',
  })
  center_cursor()
  vim.notify 'Center mode enabled'
end

function M.disable()
  if not enabled then
    return
  end
  enabled = false
  vim.api.nvim_clear_autocmds { group = augroup }
  vim.notify 'Center mode disabled'
end

function M.toggle()
  if enabled then
    M.disable()
  else
    M.enable()
  end
end

-- Expose a command
vim.api.nvim_create_user_command('ToggleCenterMode', function()
  M.toggle()
end, {})

return M
