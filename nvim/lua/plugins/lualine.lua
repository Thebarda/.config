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
    local custom_gruvbox = require 'lualine.themes.gruvbox-material'
    local modes = { 'normal', 'command', 'insert', 'inactive', 'replace', 'terminal', 'visual' }

    for _, mode in ipairs(modes) do
      custom_gruvbox[mode].c.bg = 'NONE'
    end

    local sections = { 'b', 'y' }
    for _, section in ipairs(sections) do
      custom_gruvbox.normal[section] = { fg = colors.fg1, bg = colors.color4 }
      custom_gruvbox.insert[section] = { fg = colors.fg1, bg = colors.color6 }
      custom_gruvbox.command[section] = { fg = colors.fg1, bg = colors.color5 }
      custom_gruvbox.inactive[section] = { fg = colors.fg2, bg = colors.color2 }
      custom_gruvbox.replace[section] = { fg = colors.fg1, bg = colors.color7 }
      custom_gruvbox.terminal[section] = { fg = colors.fg1, bg = colors.color8 }
      custom_gruvbox.visual[section] = { fg = colors.fg1, bg = colors.color9 }
    end

    return {
      options = {
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        theme = custom_gruvbox,
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

      extensions = { 'lazy', 'toggleterm', 'mason', 'neo-tree', 'trouble' },
    }
  end,
}
