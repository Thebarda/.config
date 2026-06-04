local start = os.clock()

require 'config.vim'

vim.pack.add({ 'https://github.com/nvim-mini/mini.nvim' })
vim.pack.add({ 'https://github.com/mason-org/mason.nvim' })
vim.pack.add({ 'https://github.com/rebelot/kanagawa.nvim' })
vim.pack.add({ 'https://github.com/itmecho/neoterm.nvim' })

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
require('mini.comment').setup({
	options = {
		ignore_blank_line = true
	}
})
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
require('mini.move').setup({
	mappings = {
		line_up = '<M-Up>',
		line_down = '<M-Down>',
		line_left = '<M-Left>',
		line_right = '<M-Right>',
		up = '<M-Up>',
		down = '<M-Down>',
		left = '<M-Left>',
		right = '<M-Right>'
	}
})

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
require('neoterm').setup({
	clear_on_run = false, -- Run clear command before user specified commands
	position = 'center', -- Position of the terminal window: fullscreen (0), top (1), right (2), bottom (3), left (4), center (5) (string or integer value)
	noinsert = false,    -- Disable entering insert mode when opening the neoterm window
	width = 0.75,        -- Width of the terminal window (percentage, ratio, or range between 0-1)
	height = 0.75,       -- Height of the terminal window (percentage, ratio, or range between 0-1)
})

require 'lsp'
require 'keymap'

local elapsed_time = os.clock() - start

vim.notify(string.format('Config loaded in: %.2f CPU ms', elapsed_time * 1000))
