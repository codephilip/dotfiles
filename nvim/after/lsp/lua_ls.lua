---@type vim.lsp.Config
return {
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			workspace = {
				checkThirdParty = false,
				library = { vim.env.VIMRUNTIME },
			},
			hint = {
				enable = true,
				setType = false,
				paramType = true,
				paramName = "Disable",
				semicolon = "Disable",
				arrayIndex = "Disable",
			},
			diagnostics = {
				-- globals set up by this config and its plugins
				globals = { "Craftzdog", "Snacks", "MiniIcons" },
				disable = { "incomplete-signature-doc", "trailing-space" },
				unusedLocalExclude = { "_*" },
			},
		},
	},
}
