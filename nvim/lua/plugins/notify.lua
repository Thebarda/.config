return {
  'rcarriga/nvim-notify',
  config = function()
    local notify = require 'notify'
    notify.setup {
      background_colour = 'NotifyBackground',
      render = 'wrapped-compact',
      icons = {
        DEBUG = '',
        ERROR = '',
        INFO = '',
        TRACE = '✎',
        WARN = '',
      },
      level = 2,
      minimum_width = 50,
      max_width = 60,
      max_height = 150,
      on_open = function() end,
      on_close = function() end,
      stages = 'fade_in_slide_out',
      time_formats = {
        notification = '%T',
        notification_history = '%FT%T',
      },
      timeout = 2500,
      top_down = true,
      fps = 60,
    }
    vim.notify = notify
  end,
}
