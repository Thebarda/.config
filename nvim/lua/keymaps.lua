local Input = require 'nui.input'

require('which-key').add {
  { '<leader>L', group = 'Code actions', icon = { icon = ' ', color = 'blue' } },
  { '<leader>Ld', require('telescope.builtin').lsp_definitions, desc = 'Goto Definition' },
  { '<leader>LD', '<cmd>:Lspsaga hover_doc<CR>', desc = 'Show current documentation' },
  { '<leader>Li', require('telescope.builtin').lsp_implementations, desc = 'Goto Implementation' },
  { '<leader>Lr', vim.lsp.buf.rename, desc = 'Rename' },
  { '<leader>Ls', '<cmd>:Lspsaga code_action<CR>', desc = 'Show code action' },
  { '<leader>P', '<cmd>Telescope project<CR>', desc = 'Open project', icon = ' ' },
  { '<leader>s', group = 'Search', icon = { icon = ' ', color = 'green' } },
  { '<leader>sf', require('telescope.builtin').find_files, desc = 'Find file' },
  { '<leader>sp', require('telescope-live-grep-args.shortcuts').grep_word_under_cursor_current_buffer, desc = 'Search in current file' },
  { '<leader>sP', '<cmd>lua require("spectre").open_file_search({select_word=true})<cr>', desc = 'Search and replace in current file' },
  { '<leader>sg', '<cmd>lua require("telescope").extensions.live_grep_args.live_grep_args()<CR>', desc = 'Live grep' },
  { '<leader>sh', '<cmd>lua require("spectre").toggle()<CR>', desc = 'Global find and replace' },
  { '<leader>sb', require('telescope.builtin').buffers, desc = 'Search buffers' },
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
  on_open = function(term)
    vim.cmd 'startinsert!'
    vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true })
  end,
  on_close = function()
    vim.cmd 'startinsert!'
  end,
}

vim.keymap.set('n', '<leader>g', function()
  lazygit:open()
end, { desc = 'lazygit' })
