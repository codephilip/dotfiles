-- =========================================================
-- Options
-- =========================================================

-- Leader must be set before lazy.nvim loads any plugin.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Remote-plugin providers. Nothing here uses them, and leaving them on
-- costs startup time and produces noisy :checkhealth warnings.
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

local opt = vim.opt

-- Lines & cursor
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true
opt.breakindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

-- UI
opt.termguicolors = true
opt.signcolumn = "yes"
opt.mouse = "a"
opt.showmode = false -- lualine already shows it
opt.showcmd = false  -- ditto for the pending-command display
opt.ruler = false    -- ditto for the position display
opt.title = true     -- put the filename in the terminal/tmux window title
opt.smoothscroll = true -- scroll by screen line, not buffer line, when wrapped
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "screen" -- don't scroll text when windows open/close
opt.winborder = "rounded" -- 0.11: rounded borders for all floats
opt.pumheight = 10
opt.cmdheight = 1
opt.laststatus = 3 -- single global statusline
-- Each field must be exactly one character.
opt.fillchars = { eob = " ", fold = " ", foldopen = "▾", foldsep = " ", foldclose = "▸" }

-- Folding, driven by treesitter (see autocmds)
opt.foldlevel = 99
opt.foldtext = ""

-- Files & undo: no swap/backup, but keep persistent undo
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.undofile = true
opt.undolevels = 10000

-- Timing
opt.updatetime = 250
opt.timeoutlen = 400

-- Misc
opt.clipboard = "unnamedplus"
opt.confirm = true  -- ask instead of failing on unsaved quit
opt.autoread = true -- pick up edits made outside nvim (see autocmds.lua)
opt.completeopt = "menu,menuone,noselect"
opt.virtualedit = "block"
opt.inccommand = "split" -- live preview of :s
opt.jumpoptions = "stack,view"
opt.grepprg = "rg --vimgrep"
opt.grepformat = "%f:%l:%c:%m"
opt.shortmess:append("sI") -- skip intro & search messages

-- Diagnostics: keep the gutter quiet, details on demand.
vim.diagnostic.config({
  virtual_text = { prefix = "●", spacing = 2, source = "if_many" },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = " ",
      [vim.diagnostic.severity.INFO] = " ",
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
})
