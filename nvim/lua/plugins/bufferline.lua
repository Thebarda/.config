return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    vim.opt.termguicolors = true
    require("bufferline").setup({
      options = {
        mode = "buffers",
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo Tree",
            separator = true,
            text_align = "left",
          },
        },
        diagnostics = "nvim_lsp",
        separator_style = "slant",
        modified_icon = "●",
        show_close_icon = false,
        show_buffer_close_icons = true,
      },
    })
    -- Fix bufferline when restoring a session
    vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
      callback = function()
        vim.schedule(function()
          pcall(nvim_bufferline)
        end)
      end,
    })
  end,
}
