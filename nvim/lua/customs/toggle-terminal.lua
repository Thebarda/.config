local M = {}

local buf
local win
local current_float_border_hl
local api = vim.api

local function change_win_based_on_mode(is_terminal)
  local current_win_config = api.nvim_win_get_config(win)
  if is_terminal then
    current_float_border_hl = api.nvim_get_hl(0, { name = 'FloatBorder' })
    api.nvim_set_hl(0, 'FloatBorder', { fg = '#9ae876', bg = 'NONE' })
    api.nvim_win_set_config(win, {
      relative = current_win_config.relative,
      col = current_win_config.col,
      row = current_win_config.row,
      title = 'Insert enabled.',
      title_pos = 'left',
    })
    return
  end
  api.nvim_set_hl(0, 'FloatBorder', current_float_border_hl)
  api.nvim_win_set_config(win, {
    relative = current_win_config.relative,
    col = current_win_config.col,
    row = current_win_config.row,
    title = 'Insert disabled. Press "i" or "a" to enable it.',
    title_pos = 'left',
  })
end

local function unload_states()
  api.nvim_buf_delete(buf, { force = true })
  api.nvim_set_hl(0, 'FloatBorder', current_float_border_hl)
  buf = nil
  win = nil
end

local function create_autocmd()
  api.nvim_create_autocmd('WinClosed', {
    pattern = tostring(win), -- window ID as string
    callback = unload_states,
  })

  api.nvim_create_autocmd('ModeChanged', {
    buffer = buf,
    callback = function()
      local mode = vim.api.nvim_get_mode().mode
      change_win_based_on_mode(mode == 't')
    end,
  })
end

local function create_keymap(col)
  local opts = { noremap = true, silent = true, buffer = buf }
  vim.keymap.set('n', '<A-Up>', function()
    local current_height = api.nvim_win_get_height(win) + 1
    api.nvim_win_set_config(win, {
      relative = 'editor',
      height = current_height,
      row = vim.o.lines - current_height - 1,
      col = col,
    })
  end, opts)
  vim.keymap.set('n', '<A-Down>', function()
    local current_height = api.nvim_win_get_height(win) - 1
    api.nvim_win_set_config(win, {
      relative = 'editor',
      height = current_height,
      row = vim.o.lines - current_height - 1,
      col = col,
    })
  end, opts)
end

function M.open()
  buf = api.nvim_create_buf(false, true)

  api.nvim_buf_set_lines(buf, 0, -1, false, {})

  local width = vim.o.columns
  local height = math.floor(vim.o.lines / 2)
  local row = height - 1
  local col = 0

  win = api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height - 2,
    col = col,
    row = row,
    style = 'minimal',
    border = 'rounded',
  })

  vim.cmd 'terminal'
  vim.cmd 'startinsert'

  create_keymap(col)
  create_autocmd()

  current_float_border_hl = api.nvim_get_hl(0, { name = 'FloatBorder' })
end

function M.close()
  unload_states()
end

function M.toggle()
  if not buf then
    M.open()
  else
    M.close()
  end
end

return M
