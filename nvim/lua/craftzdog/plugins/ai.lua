-- Copilot inline suggestions. Run `:Copilot auth` once.
-- Mason installs copilot-language-server; without it copilot.lua downloads its own.
local mason_server = vim.fn.exepath("copilot-language-server")

require("copilot").setup({
	suggestion = {
		auto_trigger = true,
		-- the keys live in plugins/keymaps.lua
		keymap = {
			accept = false,
			accept_word = false,
			accept_line = false,
			next = false,
			prev = false,
			dismiss = false,
		},
	},
	-- notes and docs benefit from suggestions as much as code does
	filetypes = {
		markdown = true,
		help = true,
	},
	server = {
		type = "binary",
		custom_server_filepath = mason_server ~= "" and mason_server or nil,
	},
})
