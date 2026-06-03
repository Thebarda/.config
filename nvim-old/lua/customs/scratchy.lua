local window_management = require 'customs.utils.window-manager'

local M = {}

local function read_file_lines(path)
  local lines = {}
  local file = io.open(path, 'r')
  if not file then
    return nil, 'Could not open file: ' .. path
  end
  for line in file:lines() do
    table.insert(lines, line)
  end
  file:close()
  return lines
end

local filename = os.getenv 'HOME' .. '/.local/state/nvim/scratchy.md'

local buf

local function create_autocmd(win)
  vim.api.nvim_create_augroup('CustomsScratchy', { clear = true })

  vim.api.nvim_create_autocmd('WinClosed', {
    group = 'CustomsScratchy',
    pattern = tostring(win), -- window ID as string
    callback = function()
      buf = window_management.close_window(buf)
    end,
  })

  vim.api.nvim_create_autocmd('ModeChanged', {
    group = 'CustomsScratchy',
    buffer = buf,
    callback = function()
      local mode = vim.api.nvim_get_mode().mode
      if mode ~= 'n' then
        return
      end
      vim.cmd 'w!'
      vim.notify 'Scratch saved'
    end,
  })
end

function M.open()
  local lines, err = read_file_lines(filename)

  if lines == nil or err ~= nil then
    vim.notify(filename)
    local file = io.open(filename, 'w')

    lines = {}
  end

  -- Calculate window size and position
  local width = math.floor(vim.o.columns / 1.5)
  local height = math.floor(vim.o.lines / 1.5)
  local row = math.floor((vim.o.lines - height) / 2 - 1)
  local col = math.floor((vim.o.columns - width) / 2)

  local window_buffer_state = window_management.open_window {
    title_pos = 'center',
    title = 'Scratchy',
    is_scratch = false,
    is_listed = false,
    border = 'rounded',
    layout = {
      width = width,
      height = height,
      row = row,
      col = col,
    },
    filename = filename,
    lines = lines,
  }
  vim.api.nvim_win_set_option(window_buffer_state.window, 'number', true)

  buf = window_buffer_state.buffer

  create_autocmd(window_buffer_state.window)
end

function M.close()
  buf = window_management.close_window(buf)
end

function M.toggle()
  if not buf then
    M.open()
  else
    M.close()
  end
end

function M.setup()
  vim.notify 'hello from plugin'
end

return M
