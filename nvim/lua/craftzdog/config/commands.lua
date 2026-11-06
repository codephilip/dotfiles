-- User commands.

vim.api.nvim_create_user_command("ToggleFormatter", function()
	Craftzdog.editor.toggle_formatter()
end, { desc = "Toggle format on save for the current buffer" })
