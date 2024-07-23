return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  event = 'BufReadPre',
  config = function()
    vim.opt.termguicolors = true
    require('bufferline').setup {
      options = {
        mode = 'buffers',
        offsets = {
          {
            filetype = 'neo-tree',
            text = 'Neo Tree',
            separator = true,
            text_align = 'center',
          },
        },
        themable = true,
        diagnostics = 'nvim_lsp',
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local s = ' '
          for e, n in pairs(diagnostics_dict) do
            local sym = e == 'error' and '  ' or (e == 'warning' and '  ' or '  ')
            s = s .. n .. sym
          end
          return s
        end,
        modified_icon = '●',
        show_close_icon = false,
        show_buffer_close_icons = true,
      },
    }

    -- Fix bufferline when restoring a session
    vim.api.nvim_create_autocmd({ 'BufAdd', 'BufDelete' }, {
      callback = function()
        vim.schedule(function()
          pcall(nvim_bufferline)
        end)
      end,
    })
  end,
}
