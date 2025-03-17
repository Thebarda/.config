return {
  'nvim-lualine/lualine.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  opts = function()
    return {
      theme = 'tokyonight',
      options = {
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        theme = {
          normal = {
            a = { bg = '#82aaff', fg = '#212121', gui = 'bold' },
            b = { bg = '#1e2030', fg = '#82aaff' },
            c = { bg = 'none', gui = 'bold' },
            x = { bg = 'none', gui = 'bold' },
            y = { bg = '#1e2030', fg = '#82aaff' },
            z = { bg = '#82aaff', fg = '#212121', gui = 'bold' },
          },
          insert = {
            a = { bg = '#c3e88d', fg = '#212121', gui = 'bold' },
            b = { bg = '#1e2030', fg = '#c3e88d' },
            c = { bg = 'none', gui = 'bold' },
            x = { bg = 'none', gui = 'bold' },
            y = { bg = '#1e2030', fg = '#c3e88d' },
            z = { bg = '#c3e88d', fg = '#212121', gui = 'bold' },
          },
          replace = {
            a = { bg = '#ff757f', fg = '#212121', gui = 'bold' },
            b = { bg = '#1e2030', fg = '#ff757f' },
            c = { bg = 'none', gui = 'bold' },
            x = { bg = 'none', gui = 'bold' },
            y = { bg = '#1e2030', fg = '#ff757f' },
            z = { bg = '#ff757f', fg = '#212121', gui = 'bold' },
          },
          visual = {
            a = { bg = '#fca7ea', fg = '#212121', gui = 'bold' },
            b = { bg = '#1e2030', fg = '#fca7ea' },
            c = { bg = 'none', gui = 'bold' },
            x = { bg = 'none', gui = 'bold' },
            y = { bg = '#1e2030', fg = '#fca7ea' },
            z = { bg = '#fca7ea', fg = '#212121', gui = 'bold' },
          },
          command = {
            a = { bg = '#ff966c', fg = '#212121', gui = 'bold' },
            b = { bg = '#1e2030', fg = '#ff966c' },
            c = { bg = 'none', gui = 'bold' },
            x = { bg = 'none', gui = 'bold' },
            y = { bg = '#1e2030', fg = '#ff966c' },
            z = { bg = '#ff966c', fg = '#212121', gui = 'bold' },
          },
        },
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
          },
          { 'filetype', icon_only = true, padding = { left = 1, right = 0 } },
          { 'filename', padding = { left = 1, right = 1 } },
        },
        lualine_x = {
          { 'diff' },
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
