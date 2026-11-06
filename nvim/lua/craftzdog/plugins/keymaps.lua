-- Every keymap that uses a plugin. Required last, after all plugins are set up.
local map = vim.keymap.set

-- Snacks words: jump between occurrences of the word under the cursor
map({ "n", "t" }, "]]", function()
	Snacks.words.jump(vim.v.count1)
end, { desc = "Next reference" })
map({ "n", "t" }, "[[", function()
	Snacks.words.jump(-vim.v.count1)
end, { desc = "Previous reference" })
