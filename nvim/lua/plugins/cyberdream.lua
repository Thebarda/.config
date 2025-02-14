return {
  'scottmckendry/cyberdream.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('cyberdream').setup {
      transparent = true,
      italic_comments = true,
      cache = true,
      variant = 'auto',
      saturation = 0.6,
      colors = {
        fg = '#ede3c7',
      },
    }
  end,
}
