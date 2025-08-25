local M = {}

function M.yankee()
  local cursor_position = vim.api.nvim_win_get_cursor(0)

  local mode = vim.api.nvim_get_mode().mode
  local opts = {}

  if mode == 'v' or mode == 'V' or mode == '\22' then
    opts.type = mode
  end

  local selection = vim.fn.getregion(vim.fn.getpos 'v', vim.fn.getpos '.', opts)
  vim.fn.setreg('+', table.concat(selection, '\n'))

  vim.api.nvim_win_set_cursor(0, cursor_position)
  vim.cmd ':visual'
end

return M
