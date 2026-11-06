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
