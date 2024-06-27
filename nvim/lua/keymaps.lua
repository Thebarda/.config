require('which-key').register({
  L = {
    name = 'Code Actions',
    d = { require('telescope.builtin').lsp_definitions, 'Goto Definition' },
    i = { require('telescope.builtin').lsp_implementations, 'Goto Implementation' },
    r = { vim.lsp.buf.rename, 'Rename' },
    s = { '<cmd>:Lspsaga diagnostic_jump_next<CR>', 'Show next diagnostic' },
    D = { '<cmd>:Lspsaga hover_doc<CR>', 'Show current documentation' },
  },
  s = {
    name = 'Search',
    p = { '<cmd>lua require("spectre").open_file_search({select_word=true})<cr>', 'Search in current file' },
    g = { require('telescope.builtin').live_grep, 'Search globally' },
    f = { '<cmd>lua require("spectre").toggle()<CR>', 'Global find and replace' }
  }
}, {
  prefix = '<leader>',
})

vim.keymap.set('n', ';', function()
  vim.ui.input({ prompt = 'Type Vim command' }, function(text)
    if text == nil then
      return
    end
    vim.cmd(text)
  end)
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

vim.keymap.set('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<cr>', {
  desc = "Search on current file"
})
