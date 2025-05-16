local last_grep_search = ''

return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    lazygit = {
      enabled = true,
    },
    picker = {
      enabled = true,
      sources = {
        explorer = {
          layout = { preset = 'default', preview = true },
          auto_close = true,
          hidden = true,
          follow = true,
          ignored = true,
          focus = 'input',
          exclude = { 'node_modules' },
        },
        files = {
          hidden = true,
        },
      },
    },
    explorer = {
      enabled = true,
    },
    dim = {
      enabled = true,
      scope = {
        min_size = 2,
        max_size = 50,
        siblings = true,
      },
      animate = {
        enabled = vim.fn.has 'nvim-0.10' == 1,
        easing = 'outQuad',
        duration = {
          step = 20, -- ms per step
          total = 300, -- maximum duration
        },
      },
    },
    bigfile = { enabled = true },
    dashboard = {
      enabled = true,
      sections = {
        {
          section = 'terminal',
          cmd = 'lolcat ~/.config/nvim/dashboard-header.txt',
          indent = -5,
          height = 8,
          width = 69,
          padding = 1,
        },
        { section = 'keys', gap = 1, padding = 1 },
        { section = 'terminal', cmd = "curl -s 'wttr.in/{Toulouse,Paris,Limoges,Helsinki}?format=4'", pane = 2 },
        { pane = 2, icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
        { pane = 2, icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
        {
          pane = 2,
          icon = ' ',
          title = 'Git Status',
          section = 'terminal',
          enabled = vim.fn.isdirectory '.git' == 1,
          cmd = 'hub status --short --branch --renames',
          height = 5,
          padding = 1,
          ttl = 5 * 60,
          indent = 3,
        },
        { section = 'startup' },
      },
      preset = {
        keys = {
          { icon = ' ', key = 'p', desc = 'Projects', action = ':Telescope project' },
          { icon = ' ', key = 'f', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files')" },
          { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
          { icon = ' ', key = 'g', desc = 'Find Text', action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = ' ', key = 'r', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = ' ', key = 'c', desc = 'Config', action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = ' ', key = 's', desc = 'Restore Session', section = 'session' },
          { icon = '󰒲 ', key = 'L', desc = 'Lazy', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
          { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
        },
      },
    },
    notifier = {
      enabled = true,
      timeout = 5000,
      icons = {
        error = ' ',
        warn = ' ',
        info = ' ',
        debug = ' ',
        trace = ' ',
      },
      style = 'compact',
    },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    styles = {
      notification = {
        wo = { wrap = true }, -- Wrap notifications
      },
    },
    indent = {
      enabled = true,
      hl = {
        'SnacksIndent1',
        'SnacksIndent2',
        'SnacksIndent3',
        'SnacksIndent4',
        'SnacksIndent5',
        'SnacksIndent6',
        'SnacksIndent7',
        'SnacksIndent8',
      },
      chunk = {
        enabled = true,
        only_current = false,
        priority = 200,
        hl = {
          'SnacksIndent1',
          'SnacksIndent2',
          'SnacksIndent3',
          'SnacksIndent4',
          'SnacksIndent5',
          'SnacksIndent6',
          'SnacksIndent7',
          'SnacksIndent8',
        },
        char = {
          corner_top = '╭',
          corner_bottom = '╰',
          horizontal = '─',
          vertical = '│',
          arrow = '─',
        },
      },
    },
    scope = {
      enabled = true,
    },
    scroll = {
      enabled = true,
    },
    terminal = {
      enabled = true,
    },
    scratch = {
      enabled = true,
    },
  },
  keys = {
    {
      '<leader>sg',
      function()
        Snacks.picker.grep {
          on_close = function(picker)
            last_grep_search = picker.input.filter.search
          end,
          on_show = function(picker)
            picker.input:set(nil, last_grep_search)
          end,
        }
      end,
      desc = 'Search with grep',
    },
    {
      '<leader>un',
      function()
        Snacks.notifier.hide()
      end,
      desc = 'Dismiss All Notifications',
    },
    {
      '<leader>bd',
      function()
        Snacks.bufdelete()
      end,
      desc = 'Delete Buffer',
    },
    {
      '<leader>gg',
      function()
        Snacks.lazygit()
      end,
      desc = 'Lazygit',
    },
    {
      '<leader>gb',
      function()
        Snacks.git.blame_line()
      end,
      desc = 'Git Blame Line',
    },
    {
      '<leader>gB',
      function()
        Snacks.gitbrowse()
      end,
      desc = 'Git Browse',
    },
    {
      '<leader>gd',
      function()
        Snacks.picker.git_diff()
      end,
      desc = 'Git diff',
    },
    {
      '<leader>gf',
      function()
        Snacks.lazygit.log_file()
      end,
      desc = 'Lazygit Current File History',
    },
    {
      '<leader>gl',
      function()
        Snacks.lazygit.log()
      end,
      desc = 'Lazygit Log (cwd)',
    },
    {
      '<leader>cR',
      function()
        Snacks.rename.rename_file()
      end,
      desc = 'Rename File',
    },
    {
      '<leader>tt',
      function()
        Snacks.terminal.toggle()
      end,
      desc = 'Toggle Terminal',
    },
    {
      '<leader>to',
      function()
        Snacks.terminal.open()
      end,
      desc = 'Open Terminal',
    },
    {
      '<leader>.',
      function()
        Snacks.scratch()
      end,
      desc = 'Toggle Scratch Buffer',
    },
    {
      '<c-_>',
      function()
        Snacks.terminal()
      end,
      desc = 'which_key_ignore',
    },
  },
}
