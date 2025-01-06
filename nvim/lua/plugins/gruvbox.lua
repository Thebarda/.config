return {
  'sainnhe/gruvbox-material',
  lazy = false,
  priority = 1000,
  config = function()
    local g = vim.g
    g.gruvbox_material_enable_bold = '1'
    g.gruvbox_material_enable_italic = '1'
    g.gruvbox_material_transparent_background = '2'
    g.gruvbox_material_visual = 'blue background'
    g.gruvbox_material_current_word = 'underline'
    g.gruvbox_material_diagnostic_virtual_text = 'highlighted'
    g.gruvbox_material_float_style = 'dim'
    vim.cmd.colorscheme 'cyberdream'
  end,
}
