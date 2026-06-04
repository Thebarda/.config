local start = os.clock()

require 'config.vim'

for _, file in ipairs(vim.fn.readdir(vim.fn.stdpath('config') .. '/lua/plugins', [[v:val =~ '\.lua$']])) do
	require('plugins.' .. file:gsub('%.lua$', ''))
end

require 'lsp'
require 'keymap'

local elapsed_time = os.clock() - start

vim.notify(string.format('Config loaded in: %.2f CPU ms', elapsed_time * 1000))
