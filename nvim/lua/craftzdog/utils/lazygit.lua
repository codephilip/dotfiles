-- Open files picked in lazygit (`e`) in the window lazygit was launched from:
-- not a new tab, and not a nested Neovim.
local M = {}

--- Window lazygit was launched from.
local origin_win = nil

--- Open lazygit, remembering the current window for files opened from it.
function M.open()
	origin_win = vim.api.nvim_get_current_win()
	Snacks.lazygit()
end

--- Focus the window lazygit was launched from, so the following
--- `nvim --remote <file>` edits there. Called from inside lazygit through
--- `--remote-send`. If that window is gone, --remote uses the current one.
function M.focus_origin()
	if origin_win and vim.api.nvim_win_is_valid(origin_win) then
		pcall(vim.api.nvim_set_current_win, origin_win)
	end
end

--- Build lazygit's `os.edit` / `os.editAtLine` command, in POSIX sh syntax.
--- Inside Neovim ($NVIM is its RPC socket) it quits lazygit, focuses the
--- launch window, then opens the file there. Outside Neovim it runs nvim.
--- lazygit fills in {{filename}} (shell-quoted) and {{line}}.
---@param opts? { at_line?: boolean }
---@return string
function M.edit_command(opts)
	local at_line = opts and opts.at_line
	local server = 'nvim --server "$NVIM"'

	local outside = at_line and "nvim +{{line}} -- {{filename}}" or "nvim -- {{filename}}"
	local inside = {
		server .. ' --remote-send "q"',
		server .. [[ --remote-send '<Cmd>lua Craftzdog.lazygit.focus_origin()<CR>']],
		server .. " --remote {{filename}}",
	}
	if at_line then
		inside[#inside + 1] = server .. ' --remote-send ":{{line}}<CR>"'
	end

	return ('if [ -z "$NVIM" ]; then %s; else %s; fi'):format(outside, table.concat(inside, "; "))
end

return M
