local config = {
  RGB = true,
  RRGGBB = true,
  names = true,
  RRGGBBAA = true,
  rgb_fn = true,
  hsl_fn = true,
  mode = 'background'
}

return {
  'norcalli/nvim-colorizer.lua',
  config = function()
    require('colorizer').setup({
      '*',
      css = config,
      html = config,
      ts = config,
    })
  end
}
