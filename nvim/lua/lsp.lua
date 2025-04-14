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
vim.lsp.config['tailwindcssls'] = {
  filetypes = { 'javascriptreact', 'typescriptreact', 'html' },
  cmd = { 'tailwindcss-language-server', '--stdio' },
}

vim.lsp.enable { 'luals', 'vtsls', 'biome', 'rust_analyzer', 'tailwindcssls' }

require('mason').setup()
