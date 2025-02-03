local colors = {
  fg1 = '#282828',
  color2 = '#504945',
  fg2 = '#ddc7a1',
  color3 = '#32302f',
  color4 = '#a89984',
  color5 = '#7daea3',
  color6 = '#a9b665',
  color7 = '#d8a657',
  color8 = '#d3869b',
  color9 = '#ea6962',
}

return {
  'nvim-lualine/lualine.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  opts = function()
    local defaultColor = { bg = 'NONE', fg = 'NONE', gui = 'NONE' }

    return {
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

      extensions = { 'lazy', 'toggleterm', 'mason', 'trouble' },
    }
  end,
}
