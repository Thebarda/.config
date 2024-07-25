return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    require('toggleterm').setup {
      on_open = function(term)
        vim.api.nvim_buf_set_keymap(term.bufnr, 'n', '<C-d>', '<cmd>close<CR>', { noremap = true, silent = true })
      end,
    }
  end,
  event = 'VeryLazy',
}
