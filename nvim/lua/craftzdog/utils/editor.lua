local M = {}

--- Delete every listed buffer that no window shows. Unsaved buffers are kept.
function M.delete_hidden_buffers()
	local visible = {}
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		visible[vim.api.nvim_win_get_buf(win)] = true
	end

	local deleted, skipped = 0, 0
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[buf].buflisted and not visible[buf] then
			if vim.bo[buf].modified then
				skipped = skipped + 1
			else
				vim.api.nvim_buf_delete(buf, {})
				deleted = deleted + 1
			end
		end
	end

	local msg = ("Deleted %d hidden buffer%s"):format(deleted, deleted == 1 and "" or "s")
	if skipped > 0 then
		msg = msg .. (" (%d unsaved, kept)"):format(skipped)
	end
	vim.notify(msg, vim.log.levels.INFO)
end

--- Turn format-on-save off or back on for the current buffer.
function M.toggle_formatter()
	local disabled = not vim.b.disable_autoformat
	vim.b.disable_autoformat = disabled
	if disabled then
		vim.notify("Format on save disabled for this buffer", vim.log.levels.WARN)
	else
		vim.notify("Format on save enabled for this buffer", vim.log.levels.INFO)
	end
end

return M
