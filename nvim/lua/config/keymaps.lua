-- =========================================================
-- Keymaps (plugin-specific maps live with their plugin spec)
-- =========================================================

local map = vim.keymap.set

-- Write / quit
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Write file" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit window" })
map("n", "<leader>Q", "<cmd>qall<cr>", { desc = "Quit all" })
map("n", "<esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Window navigation (also works across tmux panes via vim-tmux-navigator
-- if you add it later; plain window moves otherwise)
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Window splits & resize
map("n", "<leader>-", "<C-w>s", { desc = "Split window below" })
map("n", "<leader>|", "<C-w>v", { desc = "Split window right" })
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Buffers (<S-h>/<S-l>, <leader>bd and friends come from barbar — see
-- lua/plugins/ui.lua, so that tab order and pinning stay consistent)
map("n", "<leader>bb", "<cmd>buffer #<cr>", { desc = "Switch to other buffer" })

-- Keep the cursor centred while sweeping through a file
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centred)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centred)" })
map("n", "n", "nzzzv", { desc = "Next search result (centred)" })
map("n", "N", "Nzzzv", { desc = "Prev search result (centred)" })

-- Move lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Better indenting: stay in visual mode
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Paste over a selection without clobbering the unnamed register
map("v", "p", '"_dP', { desc = "Paste without yanking" })

-- Diagnostics
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next diagnostic" })
map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Prev diagnostic" })

-- Quickfix / location list — where grep and LSP results land
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix list" })
map("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix item" })
map("n", "[q", "<cmd>cprevious<cr>", { desc = "Prev quickfix item" })

-- Terminal
map("t", "<C-/>", "<C-\\><C-n>", { desc = "Leave terminal mode" })
map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })

-- Small conveniences
-- Start a project-wide-feeling substitution with the cursor parked between
-- the slashes: type the pattern, <Right><Right>, then the replacement.
map("n", "<leader>sR", ":%s//g<Left><Left>", { desc = "Substitute in buffer", silent = false })
map("v", "<leader>sR", ":s//g<Left><Left>", { desc = "Substitute in selection", silent = false })

map("n", "<leader>cx", "<cmd>!chmod +x %<cr>", { desc = "Make current file executable" })
map("n", "<leader>cR", function()
  -- Re-source the file you're editing. Handy while tweaking this config;
  -- note plugin specs still need :Lazy reload to fully take effect.
  vim.cmd.source("%")
  vim.notify("Sourced " .. vim.fn.expand("%:t"), vim.log.levels.INFO)
end, { desc = "Source current file" })

-- `gx` (built in since 0.10) already opens the URL under the cursor.

-- Toggles worth having at hand while reading code
map("n", "<leader>uw", function() vim.opt.wrap = not vim.opt.wrap:get() end, { desc = "Toggle wrap" })
map("n", "<leader>ur", function() vim.opt.relativenumber = not vim.opt.relativenumber:get() end,
  { desc = "Toggle relative number" })
map("n", "<leader>ud", function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end,
  { desc = "Toggle diagnostics" })
map("n", "<leader>ui", vim.show_pos, { desc = "Inspect highlight under cursor" })
