local M = {}

local ROOT_MARKERS = { ".git", "lua", "package.json", "Makefile", "Cargo.toml", "go.mod", "pyproject.toml" }

--- Resolve symlinks and drop a trailing slash.
---@param path string
---@return string
function M.normalize(path)
	path = vim.uv.fs_realpath(path) or path
	return (path:gsub("(.)/$", "%1"))
end

---@return string
function M.cwd()
	return M.normalize(vim.uv.cwd() or vim.fn.getcwd())
end

--- Project root of the current buffer: the nearest parent holding a root
--- marker, or cwd.
---@return string
function M.root()
	local name = vim.api.nvim_buf_get_name(0)
	local start = name ~= "" and vim.fs.dirname(name) or M.cwd()
	local marker = vim.fs.find(ROOT_MARKERS, { path = start, upward = true })[1]
	return marker and M.normalize(vim.fs.dirname(marker)) or M.cwd()
end

---@param text string
local function copy(text)
	vim.fn.setreg("+", text)
	vim.notify("Copied: " .. text, vim.log.levels.INFO)
end

--- Copy the current file's path relative to cwd, with `#L<line>`.
function M.copy_relative_path()
	copy(vim.fn.expand("%:.") .. "#L" .. vim.fn.line("."))
end

--- Copy the current file's absolute path, with `#L<line>`.
function M.copy_absolute_path()
	copy(vim.fn.expand("%:p") .. "#L" .. vim.fn.line("."))
end

local SHORT_LANG = {
	typescriptreact = "tsx",
	javascriptreact = "jsx",
	typescript = "ts",
	javascript = "js",
}

--- Copy the visual selection as a Markdown code block carrying
--- `filename="<path from the project root>"` and `line=<first line>`.
function M.copy_as_codeblock()
	local file = vim.api.nvim_buf_get_name(0)
	if file == "" then
		vim.notify("Buffer has no file name", vim.log.levels.WARN)
		return
	end
	local first, last = vim.fn.line("v"), vim.fn.line(".")
	if first > last then
		first, last = last, first
	end
	vim.cmd("normal! " .. vim.keycode("<Esc>"))

	local root = M.root()
	local path = M.normalize(file)
	if path:find(root .. "/", 1, true) == 1 then
		path = path:sub(#root + 2)
	end
	local lang = SHORT_LANG[vim.bo.filetype] or vim.bo.filetype
	local lines = vim.api.nvim_buf_get_lines(0, first - 1, last, false)

	local block = { ('```%s filename="%s" line=%d'):format(lang, path, first) }
	vim.list_extend(block, lines)
	block[#block + 1] = "```"
	vim.fn.setreg("+", table.concat(block, "\n"))
	vim.notify(("Copied %d line%s as a code block"):format(#lines, #lines == 1 and "" or "s"), vim.log.levels.INFO)
end

--- Open the project's package.json in a centered float, 80% of the editor.
--- q or <Esc> closes it.
function M.open_package_json()
	local file = vim.fs.joinpath(M.root(), "package.json")
	if not vim.uv.fs_stat(file) then
		vim.notify("No package.json in " .. M.root(), vim.log.levels.WARN)
		return
	end

	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local buf = vim.fn.bufadd(file)
	vim.fn.bufload(buf)
	vim.bo[buf].buflisted = true
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = math.floor((vim.o.columns - width) / 2),
		row = math.floor((vim.o.lines - height) / 2),
		title = " package.json ",
		title_pos = "center",
	})

	local function close()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, false)
		end
	end
	for _, key in ipairs({ "q", "<Esc>" }) do
		vim.keymap.set("n", key, close, { buffer = buf, nowait = true, desc = "Close package.json" })
	end
	-- the buffer may also be open in a normal window later: drop the keys then
	vim.api.nvim_create_autocmd("WinClosed", {
		pattern = tostring(win),
		once = true,
		callback = function()
			for _, key in ipairs({ "q", "<Esc>" }) do
				pcall(vim.keymap.del, "n", key, { buffer = buf })
			end
		end,
	})
end

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
