vim.lsp.config['luals'] = {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.luarc.jsonc' },
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
      },
    },
  },
}
vim.lsp.config['vtsls'] = {
  cmd = { 'vtsls', '--stdio' },
  filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact', 'vue' },
}
vim.lsp.config['biome'] = {
  cmd = { 'biome', 'lsp-proxy' },
  filetypes = {
    'astro',
    'css',
    'graphql',
    'javascript',
    'javascriptreact',
    'json',
    'jsonc',
    'svelte',
    'typescript',
    'typescript.tsx',
    'typescriptreact',
    'vue',
  },
  single_file_support = false,
}
vim.lsp.config['rust_analyzer'] = {
  filetypes = { 'rust' },
  cmd = { 'rust-analyzer' },
}

vim.lsp.config['cssvars'] = {
  cmd = { 'css-variables-language-server', '--stdio' },
  filetypes = { 'css', 'scss', 'less' },
  settings = {
    cssVariables = {
      lookupFiles = { '**/*.less', '**/*.scss', '**/*.sass', '**/*.css' },
      blacklistFolders = {
        '**/.cache',
        '**/.DS_Store',
        '**/.git',
        '**/.hg',
        '**/.next',
        '**/.svn',
        '**/bower_components',
        '**/CVS',
        '**/dist',
        '**/node_modules',
        '**/tests',
        '**/tmp',
      },
    },
  },
}

vim.lsp.config['cssls'] = {
  cmd = { 'vscode-css-language-server', '--stdio' },
  filetypes = { 'css', 'scss', 'less' },
  init_options = { provideFormatter = true }, -- needed to enable formatting capabilities
  single_file_support = true,
  settings = {
    css = { validate = true },
    scss = { validate = true },
    less = { validate = true },
  },
}

vim.lsp.enable { 'luals', 'vtsls', 'biome', 'rust_analyzer', 'cssvars', 'cssls' }

require('mason').setup()
