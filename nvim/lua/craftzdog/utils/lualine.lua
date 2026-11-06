-- Custom lualine components.
local editor = require("craftzdog.utils.editor")
local normalize, cwd = editor.normalize, editor.cwd

local M = {}

--- Project root name, shown only when the root differs from cwd.
function M.root_dir()
	local function name()
		local root = editor.root()
		return root ~= cwd() and vim.fs.basename(root) or nil
	end
	return {
		function()
			return "\u{f126d} " .. name()
		end,
		cond = function()
			return name() ~= nil
		end,
		color = function()
			return { fg = Snacks.util.color("Special") }
		end,
	}
end

--- Current file path relative to cwd, directory dimmed and file name in bold
--- (MatchParen when modified), with a lock when read-only.
function M.pretty_path()
	return function(self)
		local path = vim.fn.expand("%:p")
		if path == "" then
			return ""
		end
		path = normalize(path)
		local dir = cwd()
		if path:find(dir .. "/", 1, true) == 1 then
			path = path:sub(#dir + 2)
		end

		local section_hl = ("%%#lualine_%s_normal#"):format(self and self.options and self.options.section or "c")
		local file_hl = vim.bo.modified and "%#MatchParen#" or "%#Bold#"
		local head, tail = path:match("^(.*/)([^/]*)$")
		local result = (head or ""):gsub("%%", "%%%%") .. file_hl .. (tail or path):gsub("%%", "%%%%") .. section_hl

		if vim.bo.readonly or not vim.bo.modifiable then
			result = result .. " \u{f033e} "
		end
		return result
	end
end

--- Register a macro is being recorded into. The command line is hidden
--- (cmdheight 0), so this replaces its "recording @q" message.
function M.macro_recording()
	return {
		function()
			return "\u{f044b} " .. vim.fn.reg_recording()
		end,
		cond = function()
			return vim.fn.reg_recording() ~= ""
		end,
		color = function()
			return { fg = Snacks.util.color("DiagnosticError"), gui = "bold" }
		end,
	}
end

return M
