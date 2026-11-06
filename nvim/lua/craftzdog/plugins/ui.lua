local icons = Craftzdog.icons
local lualine = Craftzdog.lualine

-- Colorscheme
require("solarized-osaka").setup({
	style = "vivid",
	transparent = true,
})
vim.cmd.colorscheme("solarized-osaka")

-- Icons: one source for every plugin
require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()

-- Tabline (no plugin)
Craftzdog.tabline.setup()

-- Snacks
require("snacks").setup({
	notifier = { enabled = true },
	indent = { enabled = true },
	statuscolumn = { enabled = true },
	words = { enabled = true },
	scroll = { enabled = false },
	picker = {
		enabled = true,
		sources = {
			-- dotfiles like .github/ and .env.example are part of real projects
			files = { hidden = true },
			grep = { hidden = true },
		},
	},
})

-- Floating `:` command line, centered, 20% from the top
require("tiny-cmdline").setup({
	position = { y = "20%" },
	-- keep blink.cmp's command-line menu under the floating command line
	on_reposition = require("tiny-cmdline").adapters.blink,
})

-- Statusline
require("lualine").setup({
	options = {
		theme = "auto",
		globalstatus = true,
		refresh = {
			events = {
				"WinEnter",
				"BufEnter",
				"BufWritePost",
				"SessionLoadPost",
				"FileChangedShellPost",
				"VimResized",
				"Filetype",
				"CursorMoved",
				"CursorMovedI",
				"ModeChanged",
				"RecordingEnter",
				"RecordingLeave",
			},
		},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch" },
		lualine_c = {
			lualine.root_dir(),
			{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
			{ lualine.pretty_path() },
		},
		lualine_x = {
			lualine.macro_recording(),
			{
				"diagnostics",
				symbols = {
					error = icons.diagnostics.Error,
					warn = icons.diagnostics.Warn,
					info = icons.diagnostics.Info,
					hint = icons.diagnostics.Hint,
				},
			},
			{
				"diff",
				symbols = {
					added = icons.git.added,
					modified = icons.git.modified,
					removed = icons.git.removed,
				},
			},
		},
		lualine_y = { { "progress", padding = { left = 1, right = 1 } } },
		lualine_z = { { "location", padding = { left = 1, right = 1 } } },
	},
})

-- Window labels: file name tag in the top-right corner of each window
require("incline").setup({
	window = {
		margin = { vertical = 0, horizontal = 1 },
		zindex = 10,
	},
	hide = { cursorline = true },
	render = function(props)
		local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
		if name == "" then
			name = "[No Name]"
		end
		local icon, icon_hl = MiniIcons.get("file", name)
		local label = { { icon, group = icon_hl }, { " " }, { name } }
		if vim.bo[props.buf].modified then
			table.insert(label, 1, { "[+] " })
		end
		return label
	end,
})
