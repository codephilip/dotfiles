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

-- Completion
require("blink.cmp").setup({
	keymap = { preset = "enter" },
	appearance = {
		kind_icons = vim.tbl_map(vim.trim, icons.kinds),
	},
	completion = {
		accept = { auto_brackets = { enabled = true } },
		menu = {
			draw = { treesitter = { "lsp" } },
		},
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
		},
		-- Copilot already shows inline suggestions
		ghost_text = { enabled = false },
	},
	cmdline = {
		completion = {
			list = { selection = { preselect = false } },
			menu = {
				auto_show = function()
					return vim.fn.getcmdtype() == ":"
				end,
			},
		},
	},
})

-- nvim-lspconfig supplies the defaults, after/lsp/<name>.lua the overrides.
-- Every server gets blink.cmp's completion capabilities and file-rename support.
vim.lsp.config("*", {
	capabilities = require("blink.cmp").get_lsp_capabilities({
		workspace = {
			fileOperations = {
				didRename = true,
				willRename = true,
			},
		},
	}),
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
