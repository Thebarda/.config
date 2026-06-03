return {
  'jake-stewart/multicursor.nvim',
  event = 'BufEnter',
  config = function()
    local mc = require 'multicursor-nvim'

    mc.setup()

    vim.cmd.hi('link', 'MultiCursorCursor', 'Cursor')
    vim.cmd.hi('link', 'MultiCursorVisual', 'Visual')

    vim.keymap.set('n', '<esc>', function()
      if mc.hasCursors() then
        mc.clearCursors()
      end
    end)

    -- add cursors above/below the main cursor
    vim.keymap.set('n', '<s-up>', function()
      mc.addCursor 'k'
    end)
    vim.keymap.set('n', '<s-down>', function()
      mc.addCursor 'j'
    end)

    -- add a cursor and jump to the next word under cursor
    vim.keymap.set('n', '<c-n>', function()
      mc.addCursor '*'
    end)
    -- jump to the next word under cursor but do not add a cursor
    vim.keymap.set('n', '<c-s>', function()
      mc.skipCursor '*'
    end)

    -- add and remove cursors with control + left click
    vim.keymap.set('n', '<c-leftmouse>', mc.handleMouse)
  end,
}
