vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil or vim.tbl_contains({ 'null-ls' }, client.name) then -- blacklist lsp
      return
    end
  end,
})

vim.api.nvim_create_autocmd('BufWritePost', {
  callback = function(args)
    vim.notify(args.file .. ' saved', 'success')
  end,
})
