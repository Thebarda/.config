return {
  'rachartier/tiny-inline-diagnostic.nvim',
  event = 'BufReadPre',
  config = function()
    vim.opt.updatetime = 100
    vim.diagnostic.config { virtual_text = false }
    -- vim.api.nvim_set_hl(0, 'DiagnosticError', { fg = '#f76464' })
    -- vim.api.nvim_set_hl(0, 'DiagnosticWarn', { fg = '#f7bf64' })
    -- vim.api.nvim_set_hl(0, 'DiagnosticInfo', { fg = '#64bcf7' })
    -- vim.api.nvim_set_hl(0, 'DiagnosticHint', { fg = '#64f79d' })
    require('tiny-inline-diagnostic').setup {
      blend = {
        factor = 0.1,
      },
      signs = {
        arrow = '   ',
      },
    }
  end,
}
