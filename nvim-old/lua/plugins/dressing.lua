return {
  'stevearc/dressing.nvim',
  event = 'BufReadPre',
  opts = {
    input = {
      title_pos = 'center',
      relative = 'win',
      nui = {
        border = {
          style = 'rounded',
        },
      },
    },
  },
}
