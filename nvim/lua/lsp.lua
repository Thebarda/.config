vim.lsp.config['luals'] = {
	cmd = { 'lua-language-server' },
	filetypes = { 'lua' },
	root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
	settings = {
		Lua = {
			runtime = {
				version = 'LuaJIT',
			},
			diagnostics = {
				globals = { 'vim' },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file('', true),
			},
		},
	},
}
vim.lsp.config['vtsls'] = {
	cmd = { 'vtsls', '--stdio' },
	filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact', 'vue' },
	root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' },
}
vim.lsp.config['biome'] = {
	cmd = { 'biome', 'lsp-proxy' },
	filetypes = {
		'astro',
		'css',
		'graphql',
		'javascript',
		'javascriptreact',
		'json',
		'jsonc',
		'svelte',
		'typescript',
		'typescript.tsx',
		'typescriptreact',
		'vue',
	},
	single_file_support = false,
}
vim.lsp.config['rust_analyzer'] = {
	filetypes = { 'rust' },
	cmd = { 'rust-analyzer' },
}

vim.lsp.config['cssvars'] = {
	cmd = { 'css-variables-language-server', '--stdio' },
	filetypes = { 'css', 'scss', 'less' },
	settings = {
		cssVariables = {
			lookupFiles = { '**/*.less', '**/*.scss', '**/*.sass', '**/*.css' },
			blacklistFolders = {
				'**/.cache',
				'**/.DS_Store',
				'**/.git',
				'**/.hg',
				'**/.next',
				'**/.svn',
				'**/bower_components',
				'**/CVS',
				'**/dist',
				'**/node_modules',
				'**/tests',
				'**/tmp',
			},
		},
	},
}
vim.lsp.config['cssls'] = {
	cmd = { 'vscode-css-language-server', '--stdio' },
	filetypes = { 'css', 'scss', 'less' },
	init_options = { provideFormatter = true }, -- needed to enable formatting capabilities
	single_file_support = true,
	settings = {
		css = { validate = true },
		scss = { validate = true },
		less = { validate = true },
	},
}

vim.lsp.config['markdown'] = {
	cmd = { 'marksman', 'markdown.mdx' },
	filetypes = { 'markdown', 'markdown.mdx' },
	root_markers = { '.marksman.toml', '.git' },
}

local port = os.getenv 'GDScript_Port' or '6005'
local cmd = vim.lsp.rpc.connect('127.0.0.1', tonumber(port))
vim.lsp.config['gdscript'] = {
	cmd = cmd,
	filetypes = { 'gd', 'gdscript', 'gdscript3' },
	root_markers = { 'project.godot', '.git' },
}

vim.lsp.config['tailwindcss'] = {
	cmd = { 'tailwindcss-language-server', '--stdio' },
	filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact', 'vue', 'css' },
	workspace_required = false,
}

vim.lsp.config('*', {
	capabilities = require('mini.completion').get_lsp_capabilities(),
})

vim.lsp.enable { 'luals', 'vtsls', 'biome', 'rust_analyzer', 'cssvars', 'cssls', 'markdown', 'gdscript', 'tailwindcss' }

vim.opt.completeopt =
"menu,menuone,noselect,popup"                       -- Ensures the menu appears even for a single match and uses the native popup window.
vim.o.autocomplete = true                           -- Enables the overall completion feature.

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp_completion", { clear = true }),
	callback = function(args)
		local client_id = args.data.client_id
		if not client_id then
			return
		end
	end,
})

vim.diagnostic.config({
	severity_sort = true,
	update_in_insert = false,
	float = {
		border = 'rounded',
		source = 'if_many',
	},
	underline = true,
	virtual_text = {
		spacing = 2,
		source = 'if_many',
		prefix = '●',
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = 'E',
			[vim.diagnostic.severity.WARN] = 'W',
			[vim.diagnostic.severity.INFO] = 'I',
			[vim.diagnostic.severity.HINT] = 'H',
		},
	},
})

-- Preferred formatter per filetype; everything else uses any capable client.
local format_with = {
	javascript = 'biome',
	javascriptreact = 'biome',
	typescript = 'biome',
	typescriptreact = 'biome',
	json = 'biome',
	jsonc = 'biome',
	css = 'cssls',
	scss = 'cssls',
	less = 'cssls',
	lua = 'luals',
}

vim.api.nvim_create_autocmd('BufWritePre', {
	group = vim.api.nvim_create_augroup('lsp_format_on_save', { clear = true }),
	callback = function(args)
		local preferred = format_with[vim.bo[args.buf].filetype]
		vim.lsp.buf.format {
			bufnr = args.buf,
			timeout_ms = 2000,
			filter = function(client)
				if preferred then
					return client.name == preferred
				end
				return true
			end,
		}
	end,
})
