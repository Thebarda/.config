return { -- Collection of various small independent plugins/modules
  'nvim-mini/mini.nvim',
  event = 'BufReadPre',
  config = function()
    -- Better Around/Inside textobjects
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [']quote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup { n_lines = 500 }

    require('mini.surround').setup()

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
  end,
}
