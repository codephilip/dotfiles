-- Formatting
local OXFMT_CONFIGS = { ".oxfmtrc.json", ".oxfmtrc.jsonc", "oxfmt.config.ts" }
local VITE_CONFIGS = { "vite.config.ts", "vite.config.js" }

--- oxfmt config marker for vim.fs.root: an oxfmt config file, or a Vite+
--- config (a vite.config that imports vite-plus). A plain Vite config doesn't
--- count, so projects on prettier keep it.
---@param name string
---@param path string
---@return boolean
local function is_oxfmt_config(name, path)
	if vim.list_contains(OXFMT_CONFIGS, name) then
		return true
	end
	if not vim.list_contains(VITE_CONFIGS, name) then
		return false
	end
	local file = io.open(vim.fs.joinpath(path, name))
	if not file then
		return false
	end
	local text = file:read("*a")
	file:close()
	return text:find("vite-plus", 1, true) ~= nil
end

local js_formatters = { "oxfmt", "prettierd", "prettier", stop_after_first = true }
require("conform").setup({
	default_format_opts = { lsp_format = "fallback" },
	formatters_by_ft = {
		javascript = js_formatters,
		typescript = js_formatters,
		javascriptreact = js_formatters,
		typescriptreact = js_formatters,
		json = js_formatters,
		css = js_formatters,
		scss = js_formatters,
		less = js_formatters,
		html = js_formatters,
		markdown = js_formatters,
		mdx = js_formatters,
		yaml = js_formatters,
		lua = { "stylua" },
		sh = { "shfmt" },
		fish = { "fish_indent" },
	},
	formatters = {
		oxfmt = {
			condition = function(_, ctx)
				return vim.fs.root(ctx.buf, is_oxfmt_config) ~= nil
			end,
		},
	},
	format_on_save = function(buf)
		if vim.b[buf].disable_autoformat then
			return
		end
		return { timeout_ms = 1000, lsp_format = "fallback" }
	end,
})

-- MDX has no parser of its own; render it with the Markdown one
vim.filetype.add({ extension = { mdx = "mdx" } })
vim.treesitter.language.register("markdown", "mdx")

-- Auto pairs in insert and command mode
require("mini.pairs").setup({
	modes = { insert = true, command = true, terminal = false },
})

-- TODO, FIXME and the like
require("todo-comments").setup()

-- Paint colors as their own background. The LSP's document colors are off so
-- colors aren't painted twice.
vim.lsp.document_color.enable(false)
require("nvim-highlight-colors").setup({
	render = "background",
	enable_hex = true,
	enable_short_hex = true,
	enable_rgb = true,
	enable_hsl = true,
	enable_hsl_without_function = true,
	enable_ansi = true,
	enable_var_usage = true,
	enable_tailwind = false,
})

-- File explorer: the directory is a buffer, edit it and :w to apply
require("oil").setup({
	columns = {
		"icon",
		{ "permissions", highlight = "Type" },
		{ "size", highlight = "String" },
		{ "mtime", highlight = "Keyword" },
	},
	view_options = { show_hidden = true },
	float = {
		border = "rounded",
		max_width = 200,
	},
	preview_win = { update_on_cursor_moved = true },
	-- Renames ask the LSP to update imports, and those edits are saved
	lsp_file_methods = {
		enabled = true,
		timeout_ms = 1000,
		autosave_changes = true,
	},
})
