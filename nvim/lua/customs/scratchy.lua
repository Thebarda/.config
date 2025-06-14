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

local filename = os.getenv 'HOME' .. '/.local/state/nvim/scratchy.txt'

local buf

local function create_autocmd(win)
  vim.api.nvim_create_autocmd('WinClosed', {
    pattern = tostring(win), -- window ID as string
    callback = function()
      vim.api.nvim_buf_delete(buf, { force = true })
      buf = nil
    end,
  })

  vim.api.nvim_create_autocmd('ModeChanged', {
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
  -- Create a new scratch buffer
  buf = vim.api.nvim_create_buf(false, false)

  -- Set buffer lines (content)
  vim.api.nvim_buf_set_name(buf, filename)
  local lines, err = read_file_lines(filename)

  if lines == nil or err ~= nil then
    vim.notify(filename)
    local file = io.open(filename, 'w')

    lines = {}
  end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- Calculate window size and position
  local width = math.floor(vim.o.columns / 2)
  local height = math.floor(vim.o.lines / 2)
  local row = math.floor((vim.o.lines - height) / 2 - 1)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Open the floating window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
    title = 'Scratch',
    title_pos = 'center',
  })

  create_autocmd(win)
end

function M.close()
  vim.api.nvim_buf_delete(buf, { force = true })
  buf = nil
end

function M.toggle()
  if not buf then
    M.open()
  else
    M.close()
  end
end

return M
