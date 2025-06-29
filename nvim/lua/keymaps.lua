local Input = require 'nui.input'

require('which-key').add {
  mode = { 'n', 'v' },
  { '<leader>e', '<cmd>lua Snacks.explorer()<CR>' },
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
      Snacks.picker.files()
    end,
    desc = 'Find file',
  },
  {
    '<leader>sh',
    '<cmd>lua require("grug-far").with_visual_selection({ prefills = { paths = vim.fn.expand("%") } })<cr>',
    desc = 'Search and replace in current file',
  },
  { '<leader>sH', '<cmd>lua require("grug-far").with_visual_selection()<CR>', desc = 'Global find and replace' },
  {
    '<leader>sb',
    function()
      Snacks.picker.buffers()
    end,
    desc = 'Search buffers',
  },
  {
    '<leader>sd',
    function()
      Snacks.picker.diagnostics()
    end,
    desc = 'Search diagnostics',
  },
  {
    '<esc><esc>',
    '<cmd>nohlsearch<CR>',
    desc = 'Discard search',
  },
  {
    '<leader>z',
    desc = 'Toggle center mode',
    function()
      Customs.center_mode.toggle()
    end,
  },
  {
    '<leader>.',
    desc = 'Toggle scratchy',
    function()
      Customs.scratchy.toggle()
    end,
  },
  {
    '<leader>t',
    desc = 'Toggle terminal',
    function()
      Customs.toggle_terminal.toggle()
    end,
  },
  {
    '<leader>g',
    desc = 'Git',
  },
  {
    '<leader>gg',
    function()
      Snacks.lazygit()
    end,
    desc = 'Lazygit',
  },
  {
    '<leader>gb',
    function()
      Snacks.git.blame_line()
    end,
    desc = 'Git Blame Line',
  },
  {
    '<leader>gB',
    function()
      Snacks.gitbrowse()
    end,
    desc = 'Git Browse',
  },
  {
    '<leader>gd',
    function()
      Snacks.picker.git_diff()
    end,
    desc = 'Git diff',
  },
  {
    '<leader>gf',
    function()
      Snacks.lazygit.log_file()
    end,
    desc = 'Lazygit Current File History',
  },
  {
    '<leader>gl',
    function()
      Snacks.lazygit.log()
    end,
    desc = 'Lazygit Log (cwd)',
  },
  {
    '<leader>p',
    desc = 'PNPM',
  },
  {
    '<leader>p7',
    desc = 'Switch to PNPM 7',
    function()
      Customs.switch_pnpm_version.switchTo7()
    end,
  },
  {
    '<leader>p8',
    desc = 'Switch to PNPM 8',
    function()
      Customs.switch_pnpm_version.switchTo8()
    end,
  },
  {
    '<leader>p1',
    desc = 'Switch to PNPM 10',
    function()
      Customs.switch_pnpm_version.switchTo10()
    end,
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
