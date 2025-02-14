return {
  'rachartier/tiny-glimmer.nvim',
  event = 'VeryLazy',
  lazy = false,
  opts = {
    enabled = true,
    default_animation = 'rainbow',
    transparency_color = '#000000',
    overwrite = {
      search = {
        enabled = true,
      },
      paste = {
        enabled = true,
      },
      undo = {
        enabled = true,
      },
      redo = {
        enabled = true,
      },
    },
  },
}
