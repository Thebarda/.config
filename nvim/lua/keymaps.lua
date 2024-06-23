vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', {
  desc = "Toggle Spectre"
})

vim.keymap.set('n', ';', function()
  vim.ui.input({ prompt = 'Type Vim command' }, function(text)
    if text == nil then
      return
    end
    vim.cmd(text)
  end)
end)
