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
	settings = {
		vtsls = { autoUseWorkspaceTsdk = true },
	},
}

-- Flush tsserver's stale auto-import cache without restarting Neovim
vim.api.nvim_create_user_command('TsRestart', function()
	for _, client in ipairs(vim.lsp.get_clients { name = 'vtsls' }) do
		client:exec_cmd { title = 'Restart tsserver', command = 'typescript.restartTsServer' }
	end
end, { desc = 'Restart the TypeScript server' })
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
	-- Walk up past nested configs ("root": false) so biome loads the
	-- monorepo root config; nested configs only work under their root.
	root_dir = function(bufnr, on_dir)
		local found
		for dir in vim.fs.parents(vim.api.nvim_buf_get_name(bufnr)) do
			for _, name in ipairs { 'biome.json', 'biome.jsonc' } do
				local config = dir .. '/' .. name
				if vim.uv.fs_stat(config) then
					found = dir
					local text = table.concat(vim.fn.readfile(config), '\n')
					if not text:find '"root"%s*:%s*false' then
						return on_dir(dir)
					end
				end
			end
		end
		if found then
			on_dir(found)
		end
	end,
	workspace_required = true,
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

-- Sign-in flow for copilot-language-server: custom 'signIn' request returns a
-- one-time code and a command to run once the device flow is confirmed.
local function copilot_sign_in(bufnr, client)
	client:request('signIn', vim.empty_dict(), function(err, result)
		if err then
			vim.notify(err.message, vim.log.levels.ERROR)
			return
		end
		if result.command then
			vim.fn.setreg('+', result.userCode)
			local continue = vim.fn.confirm(
				'Copied your one-time code to clipboard.\nOpen the browser to complete the sign-in process?',
				'&Yes\n&No'
			)
			if continue == 1 then
				client:exec_cmd(result.command, { bufnr = bufnr }, function(cmd_err, cmd_result)
					if cmd_err then
						vim.notify(cmd_err.message, vim.log.levels.ERROR)
						return
					end
					if cmd_result.status == 'OK' then
						vim.notify('Signed in as ' .. cmd_result.user .. '.')
					end
				end)
			end
		end
		if result.status == 'PromptUserDeviceFlow' then
			vim.notify('Enter your one-time code ' .. result.userCode .. ' in ' .. result.verificationUri)
		elseif result.status == 'AlreadySignedIn' then
			vim.notify('Already signed in as ' .. result.user .. '.')
		end
	end)
end

local function copilot_sign_out(_, client)
	client:request('signOut', vim.empty_dict(), function(err, result)
		if err then
			vim.notify(err.message, vim.log.levels.ERROR)
			return
		end
		if result.status == 'NotSignedIn' then
			vim.notify('Not signed in.')
		end
	end)
end

vim.lsp.config('copilot', {
	cmd = { 'copilot-language-server', '--stdio' },
	root_markers = { '.git' },
	init_options = {
		editorInfo = {
			name = 'Neovim',
			version = tostring(vim.version())
		},
		editorPluginInfo = { name = 'Neovim', version = tostring(vim.version()) }
	},
	on_attach = function(client, bufnr)
		vim.api.nvim_buf_create_user_command(bufnr, 'LspCopilotSignIn', function()
			copilot_sign_in(bufnr, client)
		end, { desc = 'Sign in Copilot with GitHub' })
		vim.api.nvim_buf_create_user_command(bufnr, 'LspCopilotSignOut', function()
			copilot_sign_out(bufnr, client)
		end, { desc = 'Sign out Copilot with GitHub' })
	end,
})

vim.lsp.config("fallow", {
	cmd = { "fallow-lsp" },
	filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
	root_markers = { ".fallowrc.json", "package.json", ".git" },
	init_options = {
		-- Every issue type is enabled by default. List only the ones you
		-- want to turn off; any key you omit stays enabled.
		issueTypes = {
			["circular-dependencies"] = false,
		},
	},
})

vim.lsp.config('*', {
	capabilities = vim.tbl_deep_extend(
		'force',
		vim.lsp.protocol.make_client_capabilities(),
		require('mini.completion').get_lsp_capabilities()
	),
})

vim.lsp.enable { 'luals', 'vtsls', 'biome', 'rust_analyzer', 'cssvars', 'cssls', 'markdown', 'gdscript', 'tailwindcss', 'copilot', 'fallow' }

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp_completion", { clear = true }),
	callback = function(args)
		local client_id = args.data.client_id
		if not client_id then
			return
		end

		local client = vim.lsp.get_client_by_id(client_id)
		if client and client:supports_method('textDocument/inlineCompletion', args.buf) then
			vim.lsp.inline_completion.enable(true, { bufnr = args.buf })
		end

		local bufopts = { noremap = true, silent = true, buffer = args.buf }
		vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
		vim.keymap.set("i", "<a-cr>", vim.lsp.buf.code_action, bufopts)
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

-- Biome assist actions (sorting) are code actions, not formatting; apply them
-- one kind at a time so each request sees the previously applied edits.
local biome_save_actions = {
	'source.organizeImports.biome',
	'source.biome.useSortedAttributes',
	'source.biome.useSortedKeys',
}

local function apply_biome_save_actions(buf)
	local client = vim.lsp.get_clients({ bufnr = buf, name = 'biome' })[1]
	if not client then
		return
	end
	for _, kind in ipairs(biome_save_actions) do
		local params = {
			textDocument = { uri = vim.uri_from_bufnr(buf) },
			range = {
				start = { line = 0, character = 0 },
				['end'] = { line = vim.api.nvim_buf_line_count(buf), character = 0 },
			},
			context = { diagnostics = {}, only = { kind } },
		}
		local res = client:request_sync('textDocument/codeAction', params, 2000, buf)
		local action = res and res.result and res.result[1]
		if action then
			if not action.edit and action.data then
				local resolved = client:request_sync('codeAction/resolve', action, 2000, buf)
				action = resolved and resolved.result or action
			end
			if action.edit then
				vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
			end
		end
	end
end

vim.api.nvim_create_autocmd('BufWritePre', {
	group = vim.api.nvim_create_augroup('lsp_format_on_save', { clear = true }),
	callback = function(args)
		local preferred = format_with[vim.bo[args.buf].filetype]
		apply_biome_save_actions(args.buf)
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
