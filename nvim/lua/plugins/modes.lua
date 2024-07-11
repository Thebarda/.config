return {
  'mvllow/modes.nvim',
  config = function()
    require('modes').setup {
      colors = {
        visual = '#a67ff3',
      },
      line_opacity = 0.28,
      ignore_filetypes = { 'neo-tree', 'TelescopePrompt', 'Dashboard' },
    }
  end,
}
