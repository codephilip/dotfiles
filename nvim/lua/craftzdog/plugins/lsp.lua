local icons = Craftzdog.icons

-- Mason installs servers and formatters on start, and never auto-updates them
require("mason").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		-- servers
		"lua-language-server",
		"vtsls",
		"eslint-lsp",
		"oxlint",
		"tailwindcss-language-server",
		"css-lsp",
		"rust-analyzer",
		"copilot-language-server",
		-- formatters
		"prettier",
		"prettierd",
		"oxfmt",
		"stylua",
		"shfmt",
	},
	auto_update = false,
	run_on_start = true,
})

-- nvim-lspconfig supplies the defaults, after/lsp/<name>.lua the overrides.
-- Every server gets file-rename support.
vim.lsp.config("*", {
	capabilities = {
		workspace = {
			fileOperations = {
				didRename = true,
				willRename = true,
			},
		},
	},
})

vim.lsp.enable({
	"eslint",
	"oxlint",
	"lua_ls",
	"cssls",
	"vtsls",
	"tailwindcss",
	"rust_analyzer",
})

-- Diagnostics
vim.diagnostic.config({
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	virtual_text = {
		spacing = 4,
		prefix = "●",
		source = "if_many",
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
			[vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
			[vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
			[vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
		},
	},
})
