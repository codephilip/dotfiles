-- =========================================================
-- Neovim — clean, modern, remote-friendly
-- =========================================================

-- -------------------------
-- Basics
-- -------------------------
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.mouse = "a"

vim.opt.clipboard = "unnamedplus"

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

vim.opt.updatetime = 300
vim.opt.timeoutlen = 500

-- -------------------------
-- Leader
-- -------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- -------------------------
-- Keymaps
-- -------------------------
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", "<leader>w", ":w<CR>", opts)
map("n", "<leader>q", ":q<CR>", opts)
map("n", "<leader>Q", ":qa!<CR>", opts)
map("n", "<leader>h", ":nohlsearch<CR>", opts)

map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

map("t", "<Esc>", "<C-\\><C-n>", opts)

-- -------------------------
-- Tabs
-- -------------------------
map("n", "<leader>tn", ":tabnew<CR>", opts)
map("n", "<leader>tc", ":tabclose<CR>", opts)
map("n", "<leader>to", ":tabonly<CR>", opts)
map("n", "<leader>tl", ":tabnext<CR>", opts)
map("n", "<leader>th", ":tabprevious<CR>", opts)

-- -------------------------
-- Buffers
-- -------------------------
map("n", "<leader>bn", ":bnext<CR>", opts)
map("n", "<leader>bp", ":bprevious<CR>", opts)
map("n", "<leader>bd", ":bdelete<CR>", opts)

-- -------------------------
-- Diagnostics (IDE clarity)
-- -------------------------
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)

-- -------------------------
-- File actions
-- -------------------------
map("n", "<leader>nf", ":ene | startinsert<CR>", opts) -- new file
map("n", "<leader>sf", ":w<CR>", opts)                 -- save file

-- -------------------------
-- Visual polish (minimal)
-- -------------------------
vim.cmd([[
  highlight Normal guibg=NONE
  highlight NonText guibg=NONE
  highlight LineNr guifg=#555555
  highlight CursorLineNr guifg=#a6e3a1 gui=bold
]])

-- -------------------------
-- Plugins
-- -------------------------
require("plugins")
