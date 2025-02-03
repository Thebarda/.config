return {
  'mvllow/modes.nvim',
  event = 'BufReadPre',
  config = function()
    require('modes').setup {
      colors = {
        visual = '#a67ff3',
      },
      line_opacity = 0.28,
      ignore_filetypes = { 'TelescopePrompt', 'Dashboard' },
    }
  end,
}
