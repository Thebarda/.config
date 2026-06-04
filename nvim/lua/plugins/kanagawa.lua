vim.pack.add({ 'https://github.com/rebelot/kanagawa.nvim' })

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
