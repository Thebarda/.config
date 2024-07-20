return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  opts = function()
    local defaultColor = { bg = 'NONE', fg = 'NONE' }

    return {
      options = {
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        theme = 'gruvbox-material',
        disabled_filetypes = {
          statusline = {
            'dashboard',
            'alpha',
            'toggleterm',
            'TelescopePrompt',
            'neo-tree',
            'help',
            'lazy',
            'qf',
          },
        },
      },
      sections = {
        lualine_a = { { 'mode', icon = '' } },
        lualine_b = { { 'branch', icon = '', color = defaultColor } },
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
          {
            function()
              local buffer_count = require('core.utils').get_buffer_count()

              return '+' .. buffer_count - 1 .. '  '
            end,
            cond = function()
              return require('core.utils').get_buffer_count() > 1
            end,
            padding = { left = 1, right = 1 },
            color = defaultColor,
          },
          {
            function()
              return require('nvim-navic').get_location()
            end,
            cond = function()
              return package.loaded['nvim-navic'] and require('nvim-navic').is_available()
            end,
            color = defaultColor,
          },
        },
        lualine_x = {
          {
            require('lazy.status').updates,
            cond = require('lazy.status').has_updates,
            color = defaultColor,
          },
          { 'diff', color = defaultColor },
        },
        lualine_y = {
          {
            'progress',
            color = defaultColor,
          },
          {
            'location',
            color = defaultColor,
          },
        },
        lualine_z = {
          {
            'datetime',
            style = '  %X',
          },
        },
      },

      extensions = { 'lazy', 'toggleterm', 'mason', 'neo-tree', 'trouble' },
    }
  end,
}
