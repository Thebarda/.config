return { -- Fuzzy Finder (files, lsp, etc)
  'nvim-telescope/telescope.nvim',
  cmd = 'Telescope',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      'nvim-telescope/telescope-fzf-native.nvim',

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = 'make',

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loade;webd.
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },

    -- Useful for getting pretty icons, but requires a Nerd Font.
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    {
      'nvim-telescope/telescope-live-grep-args.nvim',
      version = '^1.0.0',
    },
    { 'nvim-telescope/telescope-project.nvim' },
  },
  config = function()
    local telescope = require 'telescope'
    local project_actions = require 'telescope._extensions.project.actions'

    telescope.setup {
      defaults = {
        file_ignore_patterns = { 'node_modules', '*.lock', 'static', '*.po', '*.png', '*.jpg' },
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
        live_grep_args = {
          auto_quoting = true,
          previewer = true,
        },
        project = {
          on_project_selected = function(prompt_bufnr)
            project_actions.change_working_directory(prompt_bufnr, false)
            vim.cmd 'lua Snacks.explorer()'
          end,
        },
      },
    }
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')
    telescope.load_extension 'live_grep_args'
    require('telescope').load_extension 'project'
  end,
}
