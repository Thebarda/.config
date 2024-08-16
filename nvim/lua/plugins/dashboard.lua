return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  config = function()
    require('dashboard').setup {
      theme = 'hyper',
      shortcut_type = 'number',
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
          },
        },
        project = {
          action = function(path)
            vim.cmd('cd ' .. path)
            vim.cmd 'Neotree reveal'
            vim.cmd('Telescope find_files winblend=20 cwd=' .. path)
          end,
        },
      },
      packages = { enable = true },
    }
  end,
  dependencies = { { 'nvim-tree/nvim-web-devicons' } },
}
