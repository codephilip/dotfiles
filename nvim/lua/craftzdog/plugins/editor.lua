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
