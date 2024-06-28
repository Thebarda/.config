return {
  'WhoIsSethDaniel/mason-tool-installer.nvim',
  config = function()
    require('mason-tool-installer').setup {
      auto_update = true,
      ensure_installed = {
        'vtsls',
        'stylua',
        'shfmt',
        'stylelint',
        'lua-language-server',
        'shellcheck',
        'jsonlint',
        'json-lsp',
        'intelephense',
        'htmlhint',
        'html-lsp',
        'graphql-language-service-cli',
        'fixjson',
        'eslint_d',
        'eslint-lsp',
        'dockerfile-language-server',
        'docker-compose-language-service',
        'css-lsp',
        'biome',
        'vim-language-server',
        'pyright',
        'tailwindcss-language-server',
        'svelte-language-server',
      },
    }
  end,
}
