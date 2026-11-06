local function gh(repo)
	return "https://github.com/" .. repo
end

-- Hooks have to exist before vim.pack.add to see installs as well as updates.
vim.api.nvim_create_autocmd("PackChanged", {
	group = vim.api.nvim_create_augroup("craftzdog.pack", { clear = true }),
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		-- Keep parsers in sync with the plugin version
		if name == "nvim-treesitter" and (kind == "install" or kind == "update") then
			if not ev.data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			vim.cmd("TSUpdate")
		end
	end,
})

vim.pack.add({
	-- UI
	{ src = gh("craftzdog/solarized-osaka.nvim") },
	{ src = gh("nvim-mini/mini.icons") },
	{ src = gh("folke/snacks.nvim") },
	{ src = gh("nvim-lualine/lualine.nvim") },
	{ src = gh("b0o/incline.nvim") },
	{ src = gh("rachartier/tiny-cmdline.nvim") },
	-- Syntax
	{ src = gh("nvim-treesitter/nvim-treesitter"), version = "main" },
	{ src = gh("folke/todo-comments.nvim") },
	{ src = gh("brenoprata10/nvim-highlight-colors") },
	-- LSP
	{ src = gh("mason-org/mason.nvim") },
	{ src = gh("WhoIsSethDaniel/mason-tool-installer.nvim") },
	{ src = gh("neovim/nvim-lspconfig") },
	-- Editor
	{ src = gh("stevearc/oil.nvim") },
})

require("craftzdog.plugins.ui")
require("craftzdog.plugins.treesitter")
require("craftzdog.plugins.lsp")
require("craftzdog.plugins.editor")
require("craftzdog.plugins.keymaps")
