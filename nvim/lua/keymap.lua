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

vim.keymap.set('n', '<leader>sf', '<cmd>Pick files<cr>')
vim.keymap.set('n', '<leader>sb', '<cmd>Pick buffers<cr>')
vim.keymap.set('n', '<leader>sg', '<cmd>Pick grep_live<cr>')
vim.keymap.set('n', '<leader>t', function()
	require('neoterm').toggle()
end)
vim.keymap.set('t', '<esc>', function()
	require('neoterm').close()
end)


local imap_expr = function(lhs, rhs)
	vim.keymap.set('i', lhs, rhs, { expr = true })
end
imap_expr('<Tab>', [[pumvisible() ? "\<C-n>" : "\<Tab>"]])
imap_expr('<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]])
