return {
  'rachartier/tiny-glimmer.nvim',
  event = 'VeryLazy',
  lazy = false,
  priority = 10,
  opts = {
    enabled = true,
    default_animation = {
      name = 'fade',
    },
    transparency_color = '#4fd6be',
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
