return {
  'nvim-lualine/lualine.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  opts = function()
    local defaultColor = { bg = 'NONE', fg = 'NONE', gui = 'NONE' }

    return {
      theme = 'tokyonight',
      options = {
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        theme = 'auto',
        disabled_filetypes = {
          statusline = {
            'dashboard',
            'alpha',
            'toggleterm',
            'TelescopePrompt',
            'help',
            'lazy',
            'qf',
          },
        },
      },
      sections = {
        lualine_a = { { 'mode', icon = '' } },
        lualine_b = { { 'branch', icon = '' } },
        lualine_c = {
          {
            'diagnostics',
            symbols = {
              error = ' ',
              warn = ' ',
              info = ' ',
              hint = '󰴓 ',
            },
            color = defaultColor,
          },
          { 'filetype', icon_only = true, padding = { left = 1, right = 0 }, color = defaultColor },
          { 'filename', padding = { left = 1, right = 1 }, color = defaultColor },
        },
        lualine_x = {
          { 'diff', color = defaultColor },
        },
        lualine_y = {
          {
            'progress',
          },
          {
            'location',
          },
        },
        lualine_z = {
          {
            'datetime',
            style = ' %X',
          },
        },
      },
      extensions = { 'lazy' },
    }
  end,
}
