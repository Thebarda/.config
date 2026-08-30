vim.pack.add({ 'https://github.com/greggh/claude-code.nvim' });

require("claude-code").setup({
	window = {
		position = "vertical",
		split_ratio = 0.38
	}
})
