return {
  'scottmckendry/cyberdream.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('cyberdream').setup {
      transparent = true,
      saturation = 0.4,
      cache = false,
      highlights = {
        Normal = { fg = '#dddddd', bg = 'NONE' },
        NormalFloat = { fg = '#dddddd', bg = 'NONE' },
        NormalNC = { fg = '#dddddd', bg = 'NONE' },
      },
    }
  end,
}
