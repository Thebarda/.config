vim.pack.add({ 'https://github.com/nvim-mini/mini.nvim' })

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
local gen_loader = require('mini.snippets').gen_loader
require('mini.snippets').setup({
	snippets = {
		-- Load snippets based on current language by reading files from
		-- "snippets/" subdirectories from 'runtimepath' directories.
		gen_loader.from_lang({
			lang_patterns = {
				tsx = { 'typescript.json' },
				typescriptreact = { 'typescript.json' },
			},
		}),
	},
})
MiniSnippets.start_lsp_server({ match = false })
local map = require('mini.map')
map.setup({
	integrations = {
		map.gen_integration.diagnostic(),
		map.gen_integration.diff(),
		map.gen_integration.builtin_search(),
	},
})
vim.api.nvim_create_autocmd('BufEnter', {
	callback = function()
		map.open()
	end
})
require('mini.input').setup({})
