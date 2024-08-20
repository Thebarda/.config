return { -- Autoformat
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_fallback = true }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = true,
    formatters_by_ft = {
      lua = { 'stylua' },
      javascipt = { 'biome' },
      typescript = { 'biome' },
      javascriptreact = { 'biome' },
      typescriptreact = { 'biome' },
    },
    format_on_save = {
      -- I recommend these options. See :help conform.format for details.
      lsp_format = 'fallback',
      timeout_ms = 2000,
    },
  },
  config = function(_, opts)
    require('conform').setup(opts)
  end,
}
