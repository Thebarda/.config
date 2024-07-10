return {
  'romgrk/barbar.nvim',
  dependencies = {
    'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
    'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
  },
  init = function()
    vim.g.barbar_auto_setup = false
  end,
  opts = {
    icons = {
      diagnostics = {
        [vim.diagnostic.severity.ERROR] = { enabled = true },
        [vim.diagnostic.severity.WARN] = { enabled = true },
        [vim.diagnostic.severity.INFO] = { enabled = true },
        [vim.diagnostic.severity.HINT] = { enabled = true },
      },
      separator = { left = '▎', right = '' },
    },
    button = '',
    sidebar_filetypes = {
      ['neo-tree'] = { event = 'BufWipeout' },
    },
  },
  version = '^1.0.0', -- optional: only update when a new 1.x version is released
  config = function(_, opts)
    require('barbar').setup(opts)
    local inactive_buffer = vim.api.nvim_get_hl(0, { name = 'BufferInactive' })
    local current_buffer = vim.api.nvim_get_hl(0, { name = 'BufferCurrent' })
    local warning = vim.api.nvim_get_hl(0, { name = 'DiagnosticWarn' })
    local error = vim.api.nvim_get_hl(0, { name = 'DiagnosticError' })
    local info = vim.api.nvim_get_hl(0, { name = 'DiagnosticInfo' })
    local hint = vim.api.nvim_get_hl(0, { name = 'DiagnosticHint' })

    vim.api.nvim_set_hl(0, 'BufferInactiveWARN', { bg = inactive_buffer.bg, fg = warning.fg })
    vim.api.nvim_set_hl(0, 'BufferCurrentWARN', { bg = current_buffer.bg, fg = warning.fg })
    vim.api.nvim_set_hl(0, 'BufferInactiveERROR', { bg = inactive_buffer.bg, fg = error.fg })
    vim.api.nvim_set_hl(0, 'BufferCurrentERROR', { bg = current_buffer.bg, fg = error.fg })
    vim.api.nvim_set_hl(0, 'BufferInactiveINFO', { bg = inactive_buffer.bg, fg = info.fg })
    vim.api.nvim_set_hl(0, 'BufferCurrentINFO', { bg = current_buffer.bg, fg = info.fg })
    vim.api.nvim_set_hl(0, 'BufferInactiveHINT', { bg = inactive_buffer.bg, fg = hint.fg })
    vim.api.nvim_set_hl(0, 'BufferCurrentHINT', { bg = current_buffer.bg, fg = hint.fg })
  end,
}
