vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil or vim.tbl_contains({ 'null-ls' }, client.name) then -- blacklist lsp
      return
    end
    require('lsp_signature').on_attach({}, bufnr)
  end,
})

vim.api.nvim_create_autocmd('BufWritePost', {
  callback = function(args)
    vim.notify(args.file .. ' saved', 'success')
  end,
})
