return {
  'numToStr/Comment.nvim',
  event = 'BufReadPre',
  opts = {
    toggler = {
      ---Line-comment toggle keymap
      line = '<leader>/',
    },
    opleader = {
      ---Line-comment keymap
      line = '<leader>/',
    },
  },
  config = function(_, opts)
    require('Comment').setup(opts)
    local ft = require 'Comment.ft'

    ft.set('po', '#%s')
  end,
}
