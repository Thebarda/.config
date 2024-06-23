vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function()
    vim.cmd('Neotree reveal')
  end
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil or vim.tbl_contains({ 'null-ls' }, client.name) then -- blacklist lsp
      return
    end
    require("lsp_signature").on_attach({
      -- ... setup options here ...
    }, bufnr)
  end,
})
