-- A plugin-free tabline. Each tab is a trapezoid: the separators slant outward
-- going down, so the tab is wider at the bottom.
local M = {}

local SEP_LEFT = "\u{e0ba}" -- lower right triangle
local SEP_RIGHT = "\u{e0b8}" -- lower left triangle
local PADDING = "   "
local MAX_NAME = 20
local TRUNCATE_TO = 17

--- Define the tabline highlights from the solarized-osaka palette.
function M.set_highlights()
	local ok, palette = pcall(require, "solarized-osaka.colors")
	if not ok then
		return
	end
	local c = palette.setup()
	local hl = vim.api.nvim_set_hl
	hl(0, "TabLineActive", { fg = c.base4, bg = c.yellow, bold = true })
	hl(0, "TabLineInactive", { fg = c.base0, bg = c.base02 })
	hl(0, "TabLineSepActive", { fg = c.yellow, bg = "NONE" })
	hl(0, "TabLineSepInactive", { fg = c.base02, bg = "NONE" })
	hl(0, "TabLineFill", { bg = "NONE" })
end

--- Name and icon for the buffer a tab shows.
---@param buf integer
---@return string name, string icon
local function label(buf)
	local bufname = vim.api.nvim_buf_get_name(buf)

	if vim.bo[buf].buftype == "terminal" then
		return "[Terminal]", ""
	end
	if bufname == "" then
		return "[No Name]", ""
	end

	local name = vim.fn.fnamemodify(bufname, ":t")
	local icon = MiniIcons and MiniIcons.get("file", name) or ""
	if vim.fn.strchars(name) > MAX_NAME then
		name = vim.fn.strcharpart(name, 0, TRUNCATE_TO) .. "…"
	end
	return name, icon
end

---@param tabnr integer
---@param active boolean
---@return string
local function render_tab(tabnr, active)
	local buflist = vim.fn.tabpagebuflist(tabnr)
	local buf = buflist[vim.fn.tabpagewinnr(tabnr)]
	if not buf then
		return ""
	end

	local name, icon = label(buf)
	local parts = {}
	if vim.bo[buf].modified then
		parts[#parts + 1] = "[+]"
	end
	if icon ~= "" then
		parts[#parts + 1] = icon
	end
	parts[#parts + 1] = name

	local tab_hl = active and "%#TabLineActive#" or "%#TabLineInactive#"
	local sep_hl = active and "%#TabLineSepActive#" or "%#TabLineSepInactive#"
	local title = PADDING .. table.concat(parts, " "):gsub("%%", "%%%%") .. PADDING

	-- %{n}T makes the tab clickable, %T ends the click region
	return ("%%%dT%s%s%s%s%s%s%%T"):format(tabnr, sep_hl, SEP_LEFT, tab_hl, title, sep_hl, SEP_RIGHT)
end

--- Render the whole tabline. Used as `%!v:lua...` in 'tabline'.
---@return string
function M.render()
	local ok, result = pcall(function()
		local current = vim.fn.tabpagenr()
		local tabs = {}
		for tabnr = 1, vim.fn.tabpagenr("$") do
			tabs[#tabs + 1] = render_tab(tabnr, tabnr == current)
		end
		return table.concat(tabs) .. "%#TabLineFill#"
	end)
	return ok and result or "%#TabLineFill#"
end

function M.setup()
	M.set_highlights()
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = vim.api.nvim_create_augroup("craftzdog.tabline", { clear = true }),
		callback = M.set_highlights,
	})
	vim.o.showtabline = 1
	vim.o.tabline = "%!v:lua.Craftzdog.tabline.render()"
end

return M
