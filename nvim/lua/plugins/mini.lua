return { -- Collection of various small independent plugins/modules
  'echasnovski/mini.nvim',
  event = 'BufReadPre',
  config = function()
    -- Better Around/Inside textobjects
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [']quote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup { n_lines = 500 }

    require('mini.surround').setup()

    local animate = require 'mini.animate'
    animate.setup {
      close = {
        enable = false,
      },
      open = {
        enable = false,
      },
      resize = {
        enable = false,
      },
      scroll = {
        enable = false,
      },
      cursor = {
        enable = true,
        timing = animate.gen_timing.linear { duration = 130, unit = 'total' },
        path = animate.gen_path.line {
          predicate = function()
            return true
          end,
        },
      },
    }

    require('mini.cursorword').setup()

    require('mini.move').setup {
      mappings = {
        -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
        left = '<S-j>',
        right = '<S-l>',
        down = '<S-k>',
        up = '<S-i>',

        -- Move current line in Normal mode
        line_left = '<S-j>',
        line_right = '<S-l>',
        line_down = '<S-k>',
        line_up = '<S-i>',
      },
    }

    require('mini.indentscope').setup {
      symbol = '│',
      draw = {
        delay = 0,
      },
    }

    local notify = require 'mini.notify'
    notify.setup()
    vim.notify = notify.make_notify()
  end,
}
