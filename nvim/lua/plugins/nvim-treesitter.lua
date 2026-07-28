vim.pack.add({ 'https://github.com/nvim-treesitter/nvim-treesitter' });

local treesitter = require('nvim-treesitter')

treesitter.install({ 'rust', 'css', 'json', 'javascript', 'typescript', 'html', 'lua', 'tsx' })

local ts_filetypes = { 'rust', 'css', 'json', 'javascript', 'typescript', 'html', 'lua', 'typescriptreact' }

local function setup_treesitter_buffer()
	-- syntax highlighting, provided by Neovim
	vim.treesitter.start()
	-- folds, provided by Neovim
	vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
	vim.wo.foldmethod = 'expr'
end

vim.api.nvim_create_autocmd('FileType', {
	pattern = ts_filetypes,
	callback = setup_treesitter_buffer,
})

vim.api.nvim_create_autocmd('BufWinEnter', {
	callback = function()
		if vim.tbl_contains(ts_filetypes, vim.bo.filetype) then
			setup_treesitter_buffer()
		end
	end,
})

vim.opt.foldenable = false
vim.opt.foldlevelstart = 99
