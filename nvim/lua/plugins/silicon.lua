return {
  'michaelrommel/nvim-silicon',
  cmd = 'Silicon',
  opts = {
    disable_defaults = true,
    theme = 'gruvbox-dark',
    font = 'Iosevka Regular=16',
    background = '#db9532',
    language = function()
      return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), ':e')
    end,
    output = function()
      return '~/Documents/Screenshots/' .. os.date '!%Y-%m-%dT%H-%M-%SZ' .. '_code.png'
    end,
  },
  config = function(_, opts)
    require('nvim-silicon').setup(opts)
  end,
}
