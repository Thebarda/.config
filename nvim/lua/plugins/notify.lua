return {
  'j-hui/fidget.nvim',
  event = 'BufReadPre',
  opts = {
    notification = {
      configs = {
        default = {
          icon = nil,
          name = nil,
        },
      },
      override_vim_notify = true,
      view = {
        stack_upwards = false,
      },
      window = {
        normal_hl = 'NormalFloat',
        winblend = 30,
        border = 'solid',
        max_width = 50,
        align = 'top',
      },
    },
  },
}
