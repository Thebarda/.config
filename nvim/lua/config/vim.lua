vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local OS = require('utils').getOS()
if OS == 'Linux' then
  vim.opt.shell = '/bin/bash'
end
if OS == 'OSX' then
  vim.opt.shell = '/bin/zsh'
end

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
-- vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

vim.opt.timeoutlen = 300

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.opt.inccommand = 'split'

vim.opt.cursorline = true

vim.opt.scrolloff = 5

vim.opt.hlsearch = true
vim.opt.termguicolors = true
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.expandtab = true
vim.o.guifont = 'Iosevka Term Regular,Hack Nerd Font'

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.api.nvim_set_hl(0, 'SnacksIndent1', { fg = '#82aaff' })
vim.api.nvim_set_hl(0, 'SnacksIndent2', { fg = '#c099ff' })
vim.api.nvim_set_hl(0, 'SnacksIndent3', { fg = '#86e1fc' })
vim.api.nvim_set_hl(0, 'SnacksIndent4', { fg = '#c3e88d' })
vim.api.nvim_set_hl(0, 'SnacksIndent5', { fg = '#ff966c' })
vim.api.nvim_set_hl(0, 'SnacksIndent6', { fg = '#fca7ea' })
vim.api.nvim_set_hl(0, 'SnacksIndent7', { fg = '#c53b53' })
vim.api.nvim_set_hl(0, 'SnacksIndent8', { fg = '#ffc777' })
