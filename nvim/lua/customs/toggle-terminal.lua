local window_management = require 'customs.utils.window-manager'

local M = {}

local is_displayed = nil
local buf
local api = vim.api

local function create_keymap()
  vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>')
end

function M.open()
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local window_buffer_state = window_management.open_window {
    is_listed = false,
    is_scratch = true,
    layout = {
      width = width,
      height = height - 2,
      col = col,
      row = row,
    },
    border = 'rounded',
  }

  buf = window_buffer_state.buffer

  vim.cmd 'terminal'
  vim.cmd 'startinsert'
  vim.api.nvim_buf_set_option(buf, 'buflisted', false)
  is_displayed = true

  create_keymap()

  current_float_border_hl = api.nvim_get_hl(0, { name = 'FloatBorder' })
end

function M.toggle_buf()
  if not is_displayed then
    vim.cmd('hide buffer ' .. buf)
    is_displayed = false
  else
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    api.nvim_open_win(buf, true, {
      relative = 'editor',
      width = width,
      height = height,
      row = row,
      col = col,
      style = 'minimal',
      border = 'rounded',
    })
    vim.cmd 'startinsert'

    is_displayed = true
  end
end

function M.toggle()
  if not buf then
    M.open()
  else
    M.toggle_buf()
  end
end

return M
