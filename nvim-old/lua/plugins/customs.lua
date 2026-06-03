return {
  dir = '~/.config/nvim/lua/customs',
  name = 'scratchy',
  lazy = false,
  dev = true,
  config = function()
    require('customs').setup()
  end,
}
