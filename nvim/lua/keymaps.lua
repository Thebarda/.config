local Input = require 'nui.input'
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

require('which-key').add {
  mode = { 'n', 'v' },
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
    '<leader>sp',
    function()
      require('telescope-live-grep-args.shortcuts').grep_word_under_cursor_current_buffer { winblend = 20 }
    end,
    desc = 'Search in current file',
  },
  {
    '<leader>sP',
    '<cmd>lua require("grug-far").with_visual_selection({ prefills = { paths = vim.fn.expand("%") } })<cr>',
    desc = 'Search and replace in current file',
  },
  { '<leader>sg', '<cmd>Telescope live_grep_args winblend=20<CR>', desc = 'Live grep' },
  { '<leader>sh', '<cmd>lua require("grug-far").with_visual_selection()<CR>', desc = 'Global find and replace' },
  { '<leader>sb', '<cmd>Telescope buffers winblend=20<CR>', desc = 'Search buffers' },
  {
    '<leader>sd',
    function()
      require('telescope.builtin').diagnostics { bufnr = 0 }
    end,
    desc = 'Search diagnostics',
  },
  {
    '<leader>d',
    '<cmd>Dashboard<CR>',
    desc = 'Open Dashboard',
  },
}

vim.keymap.set('n', ';', function()
  local vimCmdInput = Input({
    position = '50%',
    size = {
      width = 20,
    },
    border = {
      style = 'single',
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

vim.keymap.set('n', '<leader>T', function()
  local file = io.open(os.getenv 'HOME' .. '/.cache/directories.txt', 'r')
  local directories = {}
  local options = {}

  if file ~= nil then
    local content = file:read '*a'
    if content ~= '' then
      directories = vim.json.decode(content)
    end
    file:close()
  end

  table.insert(options, 'Current directory')
  for key in pairs(directories) do
    table.insert(options, key)
  end
  table.insert(options, 'Add')

  vim.ui.select(options, {
    prompt = 'Select a directory',
  }, function(item)
    if item == 'Add' then
      vim.ui.input({ prompt = 'Type the absolute path to directory' }, function(directoryPath)
        vim.ui.input({ prompt = 'Enter the name' }, function(name)
          local fileToWrite = io.open(os.getenv 'HOME' .. '/.cache/directories.txt', 'w+')
          directories[name] = directoryPath
          fileToWrite:write(vim.json.encode(directories))
          fileToWrite:close()
          vim.notify 'Directory added'
        end)
      end)
      return
    end

    if item == 'Current directory' then
      vim.cmd('ToggleTerm dir=' .. vim.uv.cwd() .. ' name=current')
      return
    end
    vim.cmd('ToggleTerm dir=' .. directories[item] .. ' name=' .. item)
  end)
end, {
  desc = 'Toggle terminal',
})

local Terminal = require('toggleterm.terminal').Terminal

local lazygit = Terminal:new {
  cmd = 'lazygit',
  dir = 'git_dir',
  direction = 'float',
  float_opts = {
    border = 'curved',
  },
  on_close = function()
    vim.cmd 'startinsert!'
  end,
}

vim.keymap.set('n', '<leader>g', function()
  lazygit:open()
end, { desc = 'lazygit' })

if vim.g.vscode then
  keymap('v', 'J', ':m .+1<CR>==', opts)
  keymap('v', 'K', ':m .-2<CR>==', opts)
  keymap('x', 'J', ":move '>+1<CR>gv-gv", opts)
  keymap('x', 'K', ":move '<-2<CR>gv-gv", opts)
end
