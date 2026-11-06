local function gh(repo)
	return "https://github.com/" .. repo
end

vim.pack.add({
	-- UI
	{ src = gh("rachartier/tiny-cmdline.nvim") },
})

require("craftzdog.plugins.ui")
