-- Signs and blame
require("gitsigns").setup()

-- Diff overlay. The craftzdog/mini.diff fork can group changes into whole
-- hunks, the way `git diff` shows them.
require("mini.diff").setup({
	view = { overlay_style = "hunk" },
})
