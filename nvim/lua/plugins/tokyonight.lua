return {
  'folke/tokyonight.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('tokyonight').setup {
      transparent = true,
      style = 'moon',
      plugins = {
        auto = true,
      },
    }
    vim.cmd.colorscheme 'tokyonight-moon'
  end,
}
