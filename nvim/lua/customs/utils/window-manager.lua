local M = {}

local api = vim.api

--- @class Window_Layout
--- @field width integer
--- @field height integer
--- @field row integer
--- @field col integer

--- @class Window
--- @field is_listed boolean
--- @field is_scratch boolean
--- @field filename string?
--- @field lines table?
--- @field layout Window_Layout
--- @field border 'rounded'|'single'|'double'|string[]
--- @field title string?
--- @field title_pos 'left'|'center'|'right'|nil

--- @class Window_Buffer_State
--- @field window integer
--- @field buffer integer

--- Opens a floating window
--- @param window_configuration Window
--- @return Window_Buffer_State
function M.open_window(window_configuration)
  local buffer = api.nvim_create_buf(window_configuration.is_listed, window_configuration.is_scratch)

  if window_configuration.filename then
    api.nvim_buf_set_name(buffer, window_configuration.filename)
  end

  api.nvim_buf_set_lines(buffer, 0, -1, false, window_configuration.lines or {})

  local window = api.nvim_open_win(buffer, true, {
    relative = 'editor',
    width = window_configuration.layout.width,
    height = window_configuration.layout.height,
    row = window_configuration.layout.row,
    col = window_configuration.layout.col,
    style = 'minimal',
    border = window_configuration.border,
    title = window_configuration.title,
    title_pos = window_configuration.title_pos,
  })

  return { buffer = buffer, window = window }
end

--- Closes a floating window
--- @param buffer integer?
--- @return nil
function M.close_window(buffer)
  if not buffer then
    return buffer
  end

  api.nvim_buf_delete(buffer, { force = true })
  return nil
end

return M
