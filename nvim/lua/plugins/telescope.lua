return { -- Fuzzy Finder (files, lsp, etc)
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      'nvim-telescope/telescope-fzf-native.nvim',

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = 'make',

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
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
    local lga_actions = require 'telescope-live-grep-args.actions'
    local project_actions = require 'telescope._extensions.project.actions'

    local extensions = { 'tsx', 'ts', 'php', 'go', 'js', 'lua', 'js', 'md', 'json' }
    local includes = ''

    for key, ext in pairs(extensions) do
      includes = includes .. ' -g *.' .. ext
    end

    telescope.setup {
      defaults = {
        file_ignore_patterns = { 'node_modules', '*.lock', 'static', '*.po', '*.png', '*.jpg' },
        layout_strategy = 'vertical',
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
        live_grep_args = {
          auto_quoting = true,
          previewer = true,
          mappings = {
            i = {
              ['<C-k>'] = lga_actions.quote_prompt { postfix = includes .. ' -g !static/ -g !**/pnpm-lock.yaml -g !**/package-lock.json' },
            },
          },
        },
        project = {
          on_project_selected = function(prompt_bufnr)
            project_actions.change_working_directory(prompt_bufnr, false)
            vim.cmd 'Neotree reveal'
            vim.cmd 'Telescope find_files'
          end,
        },
      },
    }
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')
    telescope.load_extension 'live_grep_args'
    require('telescope').load_extension 'project'

    -- local builtin = require 'telescope.builtin'
    -- vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    -- vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    -- vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    -- vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    -- vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    -- vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    -- vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    -- vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    -- vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    -- vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
    -- It's also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    -- vim.keymap.set('n', '<leader>s/', function()
    --   builtin.live_grep {
    --     prompt_title = 'Live Grep',
    --   }
    -- end, { desc = '[S]earch [/] in files' })
    --
    -- -- Shortcut for searching your Neovim configuration files
    -- vim.keymap.set('n', '<leader>sn', function()
    --   builtin.find_files { cwd = vim.fn.stdpath 'config' }
    -- end, { desc = '[S]earch [N]eovim files' })
  end,
}
