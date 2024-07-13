return { -- Useful plugin to show you pending keybinds.
  'folke/which-key.nvim',
  event = 'VimEnter', -- Sets the loading event to 'VimEnter'
  config = function() -- This is the function that runs, AFTER loading
    require('which-key').setup {
      preset = 'modern',
      win = {
        border = 'none',
        title = false,
      },
      layout = {
        width = { min = 60 },
        spacing = 1,
        align = 'center',
      },
      triggers_blacklist = {
        n = { 'd', 'y' },
      },
    }
  end,
}
