return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  event = { 'BufReadPre', 'BufNewFile' },
  cmd = 'Neotree',
  after = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  requires = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
    {
      's1n7ax/nvim-window-picker',
      version = '2.*',
      config = function()
        require('window-picker').setup {
          filter_rules = {
            include_current_win = false,
            autoselect_one = true,
            -- filter using buffer options
            bo = {
              -- if the file type is one of following, the window will be ignored
              filetype = { 'neo-tree', 'neo-tree-popup', 'notify' },
              -- if the buffer type is one of following, the window will be ignored
              buftype = { 'terminal', 'quickfix' },
            },
          },
        }
      end,
    },
  },
  config = function()
    -- If you want icons for diagnostic errors, you'll need to define them somewhere:
    vim.fn.sign_define('DiagnosticSignError', { text = ' ', texthl = 'DiagnosticSignError' })
    vim.fn.sign_define('DiagnosticSignWarn', { text = ' ', texthl = 'DiagnosticSignWarn' })
    vim.fn.sign_define('DiagnosticSignInfo', { text = ' ', texthl = 'DiagnosticSignInfo' })
    vim.fn.sign_define('DiagnosticSignHint', { text = '󰴓 ', texthl = 'DiagnosticSignHint' })

    require('neo-tree').setup {
      sources = { 'filesystem', 'buffers', 'git_status' },
      open_files_do_not_replace_types = { 'terminal', 'Trouble', 'trouble', 'qf', 'Outline' },
      close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
      popup_border_style = 'rounded',
      enable_git_status = true,
      enable_diagnostics = true,
      sort_case_insensitive = true, -- used when sorting files and directories in the tree
      sort_function = nil, -- use a custom function for sorting files and directories in the tree
      default_component_configs = {
        container = {
          enable_character_fade = true,
        },
        indent = {
          indent_size = 2,
          padding = 1, -- extra padding on left hand side
          -- indent guides
          with_markers = true,
          indent_marker = '│',
          last_indent_marker = '└',
          highlight = 'NeoTreeIndentMarker',
          -- expander config, needed for nesting files
          with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = '?',
          expander_expanded = '?',
          expander_highlight = 'NeoTreeExpander',
        },
        icon = {
          folder_closed = '',
          folder_open = '',
          folder_empty = '󰜌',
          -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
          -- then these will never be used.
          default = '*',
          highlight = 'NeoTreeFileIcon',
        },
        modified = {
          symbol = '[+]',
          highlight = 'NeoTreeModified',
        },
        name = {
          trailing_slash = false,
          use_git_status_colors = true,
          highlight = 'NeoTreeFileName',
          highlight_opened_files = true,
        },
        git_status = {
          symbols = {
            -- Change type
            added = '+', -- or "?", but this is redundant info if you use git_status_colors on the name
            modified = '~', -- or "?", but this is redundant info if you use git_status_colors on the name
            deleted = '-', -- this can only be used in the git_status source
            renamed = '??', -- this can only be used in the git_status source
            -- Status type
            untracked = 'U',
            ignored = 'I',
            unstaged = 'U',
            staged = 'S',
            conflict = 'C',
          },
        },
        -- If you don't want to use these columns, you can set `enabled = false` for each of them individually
        file_size = {
          enabled = true,
          required_width = 64, -- min width of window required to show this column
        },
        type = {
          enabled = true,
          required_width = 122, -- min width of window required to show this column
        },
        last_modified = {
          enabled = true,
          required_width = 88, -- min width of window required to show this column
        },
        created = {
          enabled = true,
          required_width = 110, -- min width of window required to show this column
        },
        symlink_target = {
          enabled = false,
        },
      },
      -- A list of functions, each representing a global custom command
      -- that will be available in all sources (if not overridden in `opts[source_name].commands`)
      -- see `:h neo-tree-custom-commands-global`
      commands = {},
      window = {
        position = 'left',
        width = 40,
        mapping_options = {
          noremap = true,
          nowait = true,
        },
        mappings = {
          ['<space>'] = {
            'toggle_node',
            nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
          },
          ['<2-LeftMouse>'] = 'open',
          -- ['<cr>'] = 'open',
          ['<esc>'] = 'cancel', -- close preview or floating neo-tree window
          ['P'] = { 'toggle_preview', config = { use_float = true, use_image_nvim = true } },
          -- Read `# Preview Mode` for more information
          ['l'] = 'focus_preview',
          -- ['S'] = 'open_split',
          -- ['s'] = 'open_vsplit',
          ['S'] = 'split_with_window_picker',
          ['s'] = 'vsplit_with_window_picker',
          -- ['t'] = 'open_tabnew',
          ['<cr>'] = 'open_drop',
          ['t'] = 'open_tab_drop',
          ['w'] = 'open_with_window_picker',
          --["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
          -- ['C'] = 'close_node',
          -- ['C'] = 'close_all_subnodes',
          ['z'] = 'close_all_nodes',
          --["Z"] = "expand_all_nodes",
          ['a'] = {
            'add',
            -- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
            -- some commands may take optional config options, see `:h neo-tree-mappings` for details
            config = {
              show_path = 'none', -- "none", "relative", "absolute"
            },
          },
          ['A'] = 'add_directory', -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
          ['d'] = 'delete',
          ['r'] = 'rename',
          ['y'] = 'copy_to_clipboard',
          ['x'] = 'cut_to_clipboard',
          ['p'] = 'paste_from_clipboard',
          ['c'] = 'copy', -- takes text input for destination, also accepts the optional config.show_path option like "add":
          -- ["c"] = {
          --  "copy",
          --  config = {
          --    show_path = "none" -- "none", "relative", "absolute"
          --  }
          --}
          ['m'] = 'move', -- takes text input for destination, also accepts the optional config.show_path option like "add".
          ['q'] = 'close_window',
          ['R'] = 'refresh',
          ['?'] = 'show_help',
          ['<'] = 'prev_source',
          ['>'] = 'next_source',
          ['i'] = 'show_file_details',
        },
      },
      nesting_rules = {},
      filesystem = {
        filtered_items = {
          visible = true, -- when true, they will just be displayed differently than normal items
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_hidden = true, -- only works on Windows for hidden files/directories
          hide_by_name = {
            --"node_modules"
          },
          hide_by_pattern = { -- uses glob style patterns
            --"*.meta",
            --"*/src/*/tsconfig.json",
          },
          always_show = { -- remains visible even if other settings would normally hide it
            --".gitignored",
          },
          never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
            '.git',
            --".DS_Store",
            --"thumbs.db"
          },
          never_show_by_pattern = { -- uses glob style patterns
            --".null-ls_*",
          },
        },
        follow_current_file = { enabled = true },
        filesystem = {
          bind_to_cwd = false,
          use_libuv_file_watcher = true,
        },
        group_empty_dirs = false, -- when true, empty folders will be grouped together
        hijack_netrw_behavior = 'open_default', -- netrw disabled, opening a directory opens neo-tree
        -- in whatever position is specified in window.position
        -- "open_current",  -- netrw disabled, opening a directory opens within the
        -- window like netrw would, regardless of window.position
        -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
        use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
        -- instead of relying on nvim autocmd events.
        window = {
          mappings = {
            ['<bs>'] = 'navigate_up',
            ['.'] = 'set_root',
            ['H'] = 'toggle_hidden',
            ['/'] = 'fuzzy_finder',
            ['D'] = 'fuzzy_finder_directory',
            ['#'] = 'fuzzy_sorter', -- fuzzy sorting using the fzy algorithm
            -- ["D"] = "fuzzy_sorter_directory",
            ['f'] = 'filter_on_submit',
            ['<c-x>'] = 'clear_filter',
            ['[g'] = 'prev_git_modified',
            [']g'] = 'next_git_modified',
            ['o'] = 'system_open',
            ['c'] = 'cypress_run',
            ['C'] = 'cypress_run_update',
            ['t'] = 'open_terminal',
          },
          fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
            ['<down>'] = 'move_cursor_down',
            ['<C-n>'] = 'move_cursor_down',
            ['<up>'] = 'move_cursor_up',
            ['<C-p>'] = 'move_cursor_up',
            -- ['<key>'] = function(state, scroll_padding) ... end,
          },
        },

        commands = {
          open_terminal = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()

            Snacks.terminal.toggle(nil, { cwd = path })
          end,
          cypress_run_update = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()

            if path:sub(-#'cypress.spec.tsx') ~= 'cypress.spec.tsx' then
              vim.notify('Cannot run and update test file', vim.log.levels.ERROR)
              return
            end

            Snacks.terminal.get('pnpm cypress:run --env updateSnapshots=true --spec ' .. path)

            vim.notify('Running cypress for ' .. path)
          end,
          cypress_run = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()

            if path:sub(-#'cypress.spec.tsx') ~= 'cypress.spec.tsx' then
              vim.notify('Cannot run test file', vim.log.levels.ERROR)
              return
            end

            Snacks.terminal.get('pnpm cypress:run --spec ' .. path)

            vim.notify('Running cypress for ' .. path)
          end,
          system_open = function(state)
            local OS = require('utils').getOS()
            local node = state.tree:get_node()
            local path = node:get_id()
            if OS == 'OSX' then
              -- macOs: open file in default application in the background.
              vim.fn.jobstart({ 'open', '-g', path }, { detach = true })
            end
            if OS == 'Linux' then
              -- Linux: open file in default application
              vim.fn.jobstart({ 'xdg-open', path }, { detach = true })
            end

            -- Windows: Without removing the file from the path, it opens in code.exe instead of explorer.exe
            local p
            local lastSlashIndex = path:match '^.+()\\[^\\]*$' -- Match the last slash and everything before it
            if lastSlashIndex then
              p = path:sub(1, lastSlashIndex - 1) -- Extract substring before the last slash
            else
              p = path -- If no slash found, return original path
            end
            vim.cmd('silent !start explorer ' .. p)
          end,
        }, -- Add a custom command or override a global one using the same function name
      },
      git_status = {
        window = {
          position = 'float',
        },
      },
    }
  end,
}
