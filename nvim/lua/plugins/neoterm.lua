vim.pack.add({ 'https://github.com/itmecho/neoterm.nvim' })

require('neoterm').setup({
	clear_on_run = false, -- Run clear command before user specified commands
	position = 'center', -- Position of the terminal window: fullscreen (0), top (1), right (2), bottom (3), left (4), center (5) (string or integer value)
	noinsert = false,    -- Disable entering insert mode when opening the neoterm window
	width = 0.75,        -- Width of the terminal window (percentage, ratio, or range between 0-1)
	height = 0.75,       -- Height of the terminal window (percentage, ratio, or range between 0-1)
})
