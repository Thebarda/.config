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
