require 'config.vim'

vim.pack.add({ 'https://github.com/nvim-mini/mini.nvim' })
vim.pack.add({ 'https://github.com/mason-org/mason.nvim' })
vim.pack.add({ 'https://github.com/rebelot/kanagawa.nvim' })

require 'lsp'

require('mini.basics').setup()
require('mini.files').setup({
	mappings = {
		go_in = '<Right>',
		go_out = '<Left>',
		close = '<esc>'
	}
})
require('mini.icons').setup({})
require('mini.pairs').setup({})
require('mini.keymap').setup({})
require('mini.completion').setup({
	set_vim_settings = false
})
require('mini.notify').setup({})
require('mini.pick').setup({})
require('mini.comment').setup({})
require('mini.cursorword').setup({})
require('mini.diff').setup({
	view = {
      style = 'sign',
      signs = { add = '+', change = '~', delete = '-' },
    }
})
require('mini.tabline').setup({
	format = function(buf_id, label)
    local suffix = vim.bo[buf_id].modified and '+ ' or ''
    return MiniTabline.default_format(buf_id, label) .. suffix
	end
})
require('mini.statusline').setup({})
require('mini.indentscope').setup({
	border = 'both',
	indent_at_cursor = true,
	try_as_border = true
})
require('mini.extra').setup({})
require('mini.git').setup({})
require('mini.sessions').setup({
	autoread = true
})
require('mini.bufremove').setup({})

require("mason").setup()
require("kanagawa").setup({
	transparent = true,
	theme = 'dragon',
	overrides = function(colors)
		return {
			LineNr = { bg = "none" },
			SignColumn = { bg = "none" },
			FoldColumn = { bg = "none" },
			CursorLineNr = { bg = "none" },
			CursorLine = { bg = colors.palette.dragonBlack4 },
		}
	end,
})
vim.cmd("colorscheme kanagawa")

require 'keymap'

