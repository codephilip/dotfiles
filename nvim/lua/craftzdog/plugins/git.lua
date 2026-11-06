-- Signs and blame
require("gitsigns").setup()

-- Diff overlay. The craftzdog/mini.diff fork can group changes into whole
-- hunks, the way `git diff` shows them.
require("mini.diff").setup({
	view = { overlay_style = "hunk" },
})

-- Side-by-side diffs and history, for reviewing larger changes
require("codediff").setup({
	explorer = {
		view_mode = "tree",
		width = 50,
		auto_open_on_cursor = true,
		line_stats = { enabled = true },
	},
	diff = {
		-- only the changes plus 8 lines of context, folds synced across panes
		compact = true,
		compact_context_lines = 8,
		compact_sync_folds = true,
	},
})

-- Mark codediff tabs so <leader>dv can toggle the view
vim.api.nvim_create_autocmd("User", {
	group = vim.api.nvim_create_augroup("craftzdog.codediff", { clear = true }),
	pattern = "CodeDiffOpen",
	callback = function(ev)
		vim.t[ev.data.tabpage].codediff = true
	end,
})
