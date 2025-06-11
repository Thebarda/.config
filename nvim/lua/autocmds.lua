vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil or vim.tbl_contains({ 'null-ls' }, client.name) then -- blacklist lsp
      return
    end
  end,
})

local default_encouragements = {
  'Great job! ✨',
  "You're doing great! 💪",
  'Keep up the good work! 🌟',
  'Well done! 🎉',
  'Onward and upward! 🚀',
  "You're on fire! 🔥",
  "You're a star! ⭐️",
  "You're amazing! 🌈",
  'That was awesome! 🎈',
  'Smart move. 🧠',
  'Bravo! 👏',
  'Nailed it. 🔨',
}

local group = vim.api.nvim_create_augroup('CustomWriteMessage', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  group = group,
  callback = function()
    vim.notify(default_encouragements[math.random(#default_encouragements)])
  end,
})

local matchWithExtensions = function(path, extensions)
  for _, value in ipairs(extensions) do
    if string.match(path, '%.' .. value .. '$') ~= nil then
      return true
    end
  end
  return false
end

vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    if vim.fn.argv(0) == '.' then
      vim.cmd 'lua Snacks.picker.files()'
    end
  end,
})

-- Define the maximum file size (in bytes)
local max_file_size = 1000000 -- 1 MB

-- Function to check file size
local function should_enable_diagnostics()
  local file_size = vim.loop.fs_stat(vim.api.nvim_buf_get_name(0))
  return file_size and file_size.size <= max_file_size
end

-- Autocommand to disable diagnostics for large files
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*',
  callback = function()
    if not should_enable_diagnostics() then
      if vim.lsp.diagnostic.clear ~= nil then
        vim.lsp.diagnostic.clear(0)
      end
    end
  end,
})

---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()
vim.api.nvim_create_autocmd('LspProgress', {
  ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
    if not client or type(value) ~= 'table' then
      return
    end
    local p = progress[client.id]

    for i = 1, #p + 1 do
      if i == #p + 1 or p[i].token == ev.data.params.token then
        p[i] = {
          token = ev.data.params.token,
          msg = ('[%3d%%] %s%s'):format(
            value.kind == 'end' and 100 or value.percentage or 100,
            value.title or '',
            value.message and (' **%s**'):format(value.message) or ''
          ),
          done = value.kind == 'end',
        }
        break
      end
    end

    local msg = {} ---@type string[]
    progress[client.id] = vim.tbl_filter(function(v)
      return table.insert(msg, v.msg) or not v.done
    end, p)

    local spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
    vim.notify(table.concat(msg, '\n'), 'info', {
      id = 'lsp_progress',
      title = client.name,
      opts = function(notif)
        notif.icon = #progress[client.id] == 0 and ' ' or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})

vim.diagnostic.config {
  underline = true,
  float = { focusable = true, source = 'if_many', scope = 'cursor', border = 'rounded' },
  severity_sort = true,
  jump = {
    float = true,
  },
}

-- Show errors and warnings in a floating window
vim.api.nvim_create_autocmd('CursorHold', {
  callback = function()
    vim.diagnostic.open_float(nil)
  end,
})
