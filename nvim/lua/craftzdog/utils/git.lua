local M = {}

--- Open the current file as of the commit that last touched the cursor line,
--- in a new tab, with the cursor on that line.
function M.open_blamed_commit()
	local file = vim.api.nvim_buf_get_name(0)
	local root = file ~= "" and vim.fs.root(file, ".git")
	if not root then
		vim.notify("Not a file in a git repository", vim.log.levels.WARN)
		return
	end

	local lnum = vim.api.nvim_win_get_cursor(0)[1]
	local blame = vim.system(
		{ "git", "blame", "--porcelain", "-L", ("%d,%d"):format(lnum, lnum), "--", file },
		{ cwd = root, text = true }
	):wait()
	if blame.code ~= 0 then
		vim.notify(vim.trim(blame.stderr), vim.log.levels.ERROR)
		return
	end

	local sha, orig_lnum = blame.stdout:match("^(%x+) (%d+)")
	local path = blame.stdout:match("\nfilename ([^\n]+)")
	if not sha or not path then
		vim.notify("Could not parse git blame output", vim.log.levels.ERROR)
		return
	end
	if sha:match("^0+$") then
		vim.notify("Line not committed yet", vim.log.levels.WARN)
		return
	end

	-- gitsigns paths are relative to the repo root, which blame already returns
	require("gitsigns").show(sha .. ":" .. path, { open = "tabnew" }, function(err)
		if err then
			vim.notify(err, vim.log.levels.ERROR)
			return
		end
		vim.schedule(function()
			pcall(vim.api.nvim_win_set_cursor, 0, { tonumber(orig_lnum), 0 })
			vim.cmd("normal! zz")
		end)
	end)
end

return M
