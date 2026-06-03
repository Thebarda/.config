return {
  'greggh/claude-code.nvim',
  event = 'BufEnter',
  dependencies = {
    'nvim-lua/plenary.nvim', -- Required for git operations
  },
  config = function()
    require('claude-code').setup {
      window = {
        split_ratio = 0.30,
        position = 'vertical',
      },
      keymaps = {
        toggle = {
          normal = '<C-.>',
          terminal = '<C-.>',
        },
      },
    }
  end,
}
