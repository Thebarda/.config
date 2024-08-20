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
    vim.notify(default_encouragements[math.random(#default_encouragements)], 'success', { title = 'File saved' })
  end,
})

vim.api.nvim_create_autocmd('BufWritePost', {
  callback = function(args)
    vim.cmd('silent !biome check --write ' .. args.file)
  end,
})
