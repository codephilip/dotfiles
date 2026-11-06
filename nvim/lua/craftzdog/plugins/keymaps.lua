-- Every keymap that uses a plugin. Required last, after all plugins are set up.
local map = vim.keymap.set

-- Picker
map("n", ";f", function()
	Snacks.picker.files()
end, { desc = "Find files" })
map("n", ";r", function()
	Snacks.picker.grep()
end, { desc = "Live grep" })
map("n", ";;", function()
	Snacks.picker.resume()
end, { desc = "Resume last picker" })
map("n", "\\\\", function()
	Snacks.picker.buffers({
		-- Jump to a window that already shows the buffer, in any tab
		confirm = function(picker, item)
			picker:close()
			if not item then
				return
			end
			vim.schedule(function()
				local win = vim.fn.win_findbuf(item.buf)[1]
				if win then
					vim.api.nvim_set_current_win(win)
				else
					vim.api.nvim_set_current_buf(item.buf)
				end
			end)
		end,
	})
end, { desc = "Buffers" })
map("n", ";e", function()
	Snacks.picker.diagnostics()
end, { desc = "Diagnostics" })
map("n", ";n", function()
	Snacks.picker.notifications()
end, { desc = "Notification history" })
map("n", ";h", function()
	Snacks.picker.git_diff()
end, { desc = "Git hunks" })

-- File explorer
map("n", "sf", function()
	require("oil").open_float(nil, { preview = {} })
end, { desc = "File explorer" })
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("craftzdog.oil", { clear = true }),
	pattern = "oil",
	callback = function(ev)
		local actions = require("oil.actions")
		map("n", "h", actions.parent.callback, { buffer = ev.buf, desc = "Parent directory" })
		map("n", "q", actions.close.callback, { buffer = ev.buf, desc = "Close oil" })
	end,
})

-- Snacks words: jump between occurrences of the word under the cursor
map({ "n", "t" }, "]]", function()
	Snacks.words.jump(vim.v.count1)
end, { desc = "Next reference" })
map({ "n", "t" }, "[[", function()
	Snacks.words.jump(-vim.v.count1)
end, { desc = "Previous reference" })
