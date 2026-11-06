-- Temporary workarounds for upstream bugs. Remove each once fixed upstream.

-- neovim/neovim#40290: setting 'foldminlines' refreshes treesitter folds for
-- every tracked buffer without checking the buffer is still valid, which throws
-- "Invalid buffer id" once a tracked buffer is wiped (codediff's compact mode
-- sets it on every file switch). The refresh only matters when changing
-- 'foldminlines' or 'foldnestmax', so drop it.
require("vim.treesitter._fold")
for _, au in ipairs(vim.api.nvim_get_autocmds({ event = "OptionSet" })) do
	if au.desc == "Refresh treesitter folds" then
		vim.api.nvim_del_autocmd(au.id)
	end
end
