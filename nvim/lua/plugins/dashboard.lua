return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  config = function()
    require('dashboard').setup {
      theme = 'hyper',
      config = {
        week_header = {
          enable = true,
        },
        shortcut = {
          { desc = '󰊳  Update', group = '@property', action = 'Lazy update', key = 'u' },
          {
            desc = '  Projects',
            group = 'DiagnosticHint',
            action = 'Telescope project',
            key = 'p',
          }
        },
      },
      packages = { enable = true },
    }
  end,
  dependencies = { { 'nvim-tree/nvim-web-devicons' } },
}
