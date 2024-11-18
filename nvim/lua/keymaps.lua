local Input = require 'nui.input'
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

require('which-key').add {
  mode = { 'n', 'v' },
  { '<leader>t', '<cmd>Neotree position=float<CR>', desc = 'Open Neotree' },
  { '<leader>l', group = 'Code actions', icon = { icon = ' ', color = 'blue' } },
  { '<leader>ld', require('telescope.builtin').lsp_definitions, desc = 'Goto Definition' },
  { '<leader>lD', '<cmd>:Lspsaga hover_doc<CR>', desc = 'Show current documentation' },
  { '<leader>li', require('telescope.builtin').lsp_implementations, desc = 'Goto Implementation' },
  { '<leader>lr', vim.lsp.buf.rename, desc = 'Rename' },
  { '<leader>la', '<cmd>:Lspsaga code_action<CR>', desc = 'Show code action' },
  {
    '<leader>ls',
    function()
      require('nvim-silicon').shoot()
    end,
    desc = 'Create code screenshot',
  },
  { '<leader>P', '<cmd>Telescope project winblend=30<CR>', desc = 'Open project', icon = ' ' },
  { '<leader>s', group = 'Search', icon = { icon = ' ', color = 'green' } },
  {
    '<leader>sf',
    function()
      require('telescope.builtin').find_files { winblend = 20 }
    end,
    desc = 'Find file',
  },
  {
    '<leader>sP',
    '<cmd>lua require("grug-far").with_visual_selection({ prefills = { paths = vim.fn.expand("%") } })<cr>',
    desc = 'Search and replace in current file',
  },
  { '<leader>sh', '<cmd>lua require("grug-far").with_visual_selection()<CR>', desc = 'Global find and replace' },
  { '<leader>sb', '<cmd>Telescope buffers winblend=20<CR>', desc = 'Search buffers' },
  {
    '<leader>sd',
    function()
      require('telescope.builtin').diagnostics { bufnr = 0 }
    end,
    desc = 'Search diagnostics',
  },
}

vim.keymap.set('n', ';', function()
  local vimCmdInput = Input({
    position = '50%',
    size = {
      width = 20,
    },
    border = {
      style = 'rounded',
      text = {
        top = 'Command',
        top_align = 'left',
      },
    },
    win_options = {
      winhighlight = 'Normal:Normal,FloatBorder:Normal',
    },
  }, {
    prompt = '> ',
    on_submit = function(text)
      if text == nil then
        return
      end
      vim.cmd(text)
    end,
  })

  vimCmdInput:map('n', '<Esc>', function()
    vimCmdInput:unmount()
  end, { noremap = true })
  vimCmdInput:mount()
end)
