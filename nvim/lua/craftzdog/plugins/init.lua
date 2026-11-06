local function gh(repo)
	return "https://github.com/" .. repo
end

vim.pack.add({
	-- UI
	{ src = gh("craftzdog/solarized-osaka.nvim") },
	{ src = gh("nvim-mini/mini.icons") },
	{ src = gh("folke/snacks.nvim") },
	{ src = gh("nvim-lualine/lualine.nvim") },
	{ src = gh("b0o/incline.nvim") },
	{ src = gh("rachartier/tiny-cmdline.nvim") },
	-- Editor
	{ src = gh("stevearc/oil.nvim") },
})

require("craftzdog.plugins.ui")
require("craftzdog.plugins.editor")
require("craftzdog.plugins.keymaps")
