local opt = vim.opt

-- Leader and basics
vim.g.mapleader = " "
vim.g.maplocalleader = " "
opt.mouse = ""
opt.clipboard = "unnamedplus"
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true
opt.iskeyword:append("-")

-- Look of the buffer
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.wrap = false
opt.scrolloff = 10
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.cmdheight = 0
opt.laststatus = 3
opt.winborder = "rounded"
opt.pumheight = 10
opt.pumblend = 10
opt.showmatch = true
opt.matchtime = 2
opt.title = true
opt.fillchars:append({ diff = "╱" })

-- Search, files, undo
opt.ignorecase = true
opt.smartcase = true
opt.path:append("**")
opt.wildmode = "longest:full,full"
opt.wildignore:append({ "*/node_modules/*", "*.o", "*.obj", "*.pyc", "*.class", "*.jar" })
opt.swapfile = false
opt.writebackup = false
opt.undofile = true
opt.undodir = vim.fn.expand("~/.cache/nvim/undodir")
opt.updatetime = 300
opt.timeoutlen = 500
opt.ttimeoutlen = 0

-- Splits and folds
opt.splitbelow = true
opt.splitright = true
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99

-- Messages: the experimental ui2 replaces the message and cmdline UI.
-- Short messages pop up in a corner, long output opens the pager, and anything
-- triggered by a command I type stays in the command line.
require("vim._core.ui2").enable({
	enable = true,
	msg = {
		targets = {
			-- short messages
			[""] = "msg",
			echo = "msg",
			echomsg = "msg",
			lua_print = "msg",
			wmsg = "msg",
			undo = "msg",
			quickfix = "msg",
			bufwrite = "msg",
			-- long output
			emsg = "pager",
			echoerr = "pager",
			lua_error = "pager",
			rpc_error = "pager",
			list_cmd = "pager",
			verbose = "pager",
			shell_cmd = "pager",
			shell_out = "pager",
			shell_err = "pager",
			shell_ret = "pager",
			progress = "pager",
			-- stays in the command line
			empty = "cmd",
			search_cmd = "cmd",
			search_count = "cmd",
			completion = "cmd",
			wildlist = "cmd",
			confirm = "cmd",
			-- triggers take precedence over kinds
			typed_cmd = "cmd",
		},
		cmd = { height = 0.5 },
		msg = { height = 0.3, timeout = 5000 },
		pager = { height = 0.5 },
	},
})
