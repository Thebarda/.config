-- local all_mode = { 'i', 'c', 'x', 's', 't', 'n', 'v' }

vim.keymap.set({ 'n', 'x' }, 's', '<Nop>')

vim.keymap.set('n', '<leader>e', function()
	MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
end)
vim.keymap.set('n', '<leader>q', function()
	MiniBufremove.wipeout()
end)
vim.keymap.set('n', '<leader>p',
	function()
		vim.api.nvim_call_function("setreg", { "+", vim.fn.fnamemodify(vim.fn.expand("%"), ":.") })
	end)
vim.keymap.set('n', '<leader>r', function()
	local old_name = vim.fn.expand('<cword>')
	require('mini.input').ui_input({ prompt = 'Rename ' .. old_name, scope = 'cursor' },
		function(new_name)
			vim.lsp.buf.rename(new_name)
			vim.notify('Renamed ' .. old_name .. ' to ' .. new_name, vim.log.levels.INFO)
		end)
end)
vim.keymap.set('n', '<leader>sf', '<cmd>Pick files<cr>')
vim.keymap.set('n', '<leader>sb', '<cmd>Pick buffers<cr>')
vim.keymap.set('n', '<leader>sg', '<cmd>Pick grep_live<cr>')
vim.keymap.set('n', '<leader>t', function()
	require('neoterm').toggle()
end)
vim.keymap.set('t', '<esc><esc>', function()
	require('neoterm').close()
end)
vim.keymap.set('n', '<esc><esc>', '<cmd>nohlsearch<cr>')
vim.keymap.set('n', '<s-k>', function()
	vim.lsp.buf.hover({
		title = "Documentation (" .. vim.fn.expand('<cword>') .. ")",
		title_pos = 'left',
		border =
		'rounded'
	})
end)

local expr = function(lhs, rhs)
	vim.keymap.set('i', lhs, rhs, { expr = true })
end
expr('<Tab>', function()
	if vim.fn.pumvisible() == 1 then
		return '<C-n>'
	end
	if not vim.lsp.inline_completion.get() then
		return '<Tab>'
	end
end)
expr('<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]])
