local map = vim.keymap.set

-- Edit without touching the yank register
map("n", "x", '"_x', { desc = "Delete char without copying" })
map({ "n", "x" }, "<leader>d", '"_d', { desc = "Delete without copying" })
map({ "n", "x" }, "<leader>c", '"_c', { desc = "Change without copying" })
map({ "n", "x" }, "<leader>p", '"0p', { desc = "Paste the last yank" })
map("n", "dw", 'vb"_d', { desc = "Delete word backwards without copying" })

-- Numbers and selection
map("n", "+", "<C-a>", { desc = "Increment" })
map("n", "-", "<C-x>", { desc = "Decrement" })
map("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })

-- Tabs
map("n", "te", "<Cmd>tabedit<CR>", { desc = "New tab" })
map("n", "<Tab>", "<Cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "<S-Tab>", "<Cmd>tabprevious<CR>", { desc = "Previous tab" })

-- Windows
map("n", "ss", "<Cmd>split<CR>", { desc = "Split below" })
map("n", "sv", "<Cmd>vsplit<CR>", { desc = "Split right" })
map("n", "sh", "<C-w>h", { desc = "Window left" })
map("n", "sj", "<C-w>j", { desc = "Window below" })
map("n", "sk", "<C-w>k", { desc = "Window above" })
map("n", "sl", "<C-w>l", { desc = "Window right" })

-- <C-i> is Tab in the terminal, and Tab switches tabs
map("n", "<C-m>", "<C-i>", { desc = "Jump forward" })

-- New line without continuing a comment
map("n", "<leader>o", "o<Esc>^Da", { desc = "Open line below (no comment)" })
map("n", "<leader>O", "O<Esc>^Da", { desc = "Open line above (no comment)" })

-- Buffers
map("n", "<leader>bd", function()
	Craftzdog.editor.delete_hidden_buffers()
end, { desc = "Delete hidden buffers" })
