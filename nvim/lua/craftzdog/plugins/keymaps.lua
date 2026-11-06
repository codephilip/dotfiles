-- Every keymap that uses a plugin. Required last, after all plugins are set up.
local map = vim.keymap.set

-- Picker
map("n", ";f", function()
	Snacks.picker.files()
end, { desc = "Find files" })
map("n", ";r", function()
	Snacks.picker.grep()
end, { desc = "Live grep" })
map("n", ";;", function()
	Snacks.picker.resume()
end, { desc = "Resume last picker" })
map("n", "\\\\", function()
	Snacks.picker.buffers({
		-- Jump to a window that already shows the buffer, in any tab
		confirm = function(picker, item)
			picker:close()
			if not item then
				return
			end
			vim.schedule(function()
				local win = vim.fn.win_findbuf(item.buf)[1]
				if win then
					vim.api.nvim_set_current_win(win)
				else
					vim.api.nvim_set_current_buf(item.buf)
				end
			end)
		end,
	})
end, { desc = "Buffers" })
map("n", ";e", function()
	Snacks.picker.diagnostics()
end, { desc = "Diagnostics" })
map("n", ";n", function()
	Snacks.picker.notifications()
end, { desc = "Notification history" })
map("n", ";h", function()
	Snacks.picker.git_diff()
end, { desc = "Git hunks" })

-- File explorer
map("n", "sf", function()
	require("oil").open_float(nil, { preview = {} })
end, { desc = "File explorer" })
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("craftzdog.oil", { clear = true }),
	pattern = "oil",
	callback = function(ev)
		local actions = require("oil.actions")
		map("n", "h", actions.parent.callback, { buffer = ev.buf, desc = "Parent directory" })
		map("n", "q", actions.close.callback, { buffer = ev.buf, desc = "Close oil" })
	end,
})

-- LSP: navigation goes through the picker
map("n", "gd", function()
	Snacks.picker.lsp_definitions()
end, { desc = "Go to definition" })
map("n", "gD", function()
	Snacks.picker.lsp_declarations()
end, { desc = "Go to declaration" })
map("n", "gy", function()
	Snacks.picker.lsp_type_definitions()
end, { desc = "Go to type definition" })
-- nowait: Neovim's default gra/grn/grr/... mappings share the gr prefix
map("n", "gr", function()
	Snacks.picker.lsp_references()
end, { nowait = true, desc = "References" })
map("n", "gI", function()
	-- In TypeScript, skip the .d.ts and land on the real code
	local vtsls = vim.lsp.get_clients({ bufnr = 0, name = "vtsls" })[1]
	if not vtsls then
		return Snacks.picker.lsp_implementations()
	end
	local params = vim.lsp.util.make_position_params(0, vtsls.offset_encoding)
	vtsls:request("workspace/executeCommand", {
		command = "typescript.goToSourceDefinition",
		arguments = { params.textDocument.uri, params.position },
	}, function(err, result)
		if err then
			vim.notify("Source definition: " .. err.message, vim.log.levels.ERROR)
		elseif not result or #result == 0 then
			vim.notify("No source definition found", vim.log.levels.INFO)
		else
			vim.lsp.util.show_document(result[1], vtsls.offset_encoding, { focus = true })
		end
	end, 0)
end, { desc = "Go to source definition / implementation" })
map("n", ";c", function()
	Snacks.picker.lsp_incoming_calls()
end, { desc = "Incoming calls" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
map("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature help" })
map("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature help" })
map("n", "<C-j>", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })
map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename symbol" })
map("n", "<leader>cR", function()
	Snacks.rename.rename_file()
end, { desc = "Rename file" })
map({ "n", "x" }, "<leader>f", function()
	require("conform").format()
end, { desc = "Format" })
map("n", "<leader>cl", function()
	Snacks.picker.lsp_config()
end, { desc = "LSP info" })

-- Git signs and blame
map("n", "<leader>gb", function()
	require("gitsigns").blame_line()
end, { desc = "Blame line" })
map("n", "<leader>gB", function()
	require("gitsigns").blame()
end, { desc = "Blame buffer" })
map("n", "<leader>go", function()
	Craftzdog.git.open_blamed_commit()
end, { desc = "Open file at the line's last commit" })
map("n", "<leader>gs", function()
	local gitsigns = require("gitsigns")
	if #(gitsigns.get_hunks() or {}) > 0 then
		gitsigns.stage_buffer()
	else
		gitsigns.reset_buffer_index()
	end
end, { desc = "Stage / unstage buffer" })
map("n", "<leader>gh", function()
	require("gitsigns").stage_hunk()
end, { desc = "Stage / unstage hunk" })

-- Diff overlay
map("n", "<leader>gd", function()
	MiniDiff.toggle_overlay()
end, { desc = "Toggle diff overlay" })
-- In diff mode, ]c / [c keep their built-in meaning
map({ "n", "x" }, "]c", function()
	if vim.wo.diff then
		vim.cmd("normal! " .. vim.v.count1 .. "]c")
	else
		MiniDiff.goto_hunk("next", { n_times = vim.v.count1 })
	end
end, { desc = "Next hunk" })
map({ "n", "x" }, "[c", function()
	if vim.wo.diff then
		vim.cmd("normal! " .. vim.v.count1 .. "[c")
	else
		MiniDiff.goto_hunk("prev", { n_times = vim.v.count1 })
	end
end, { desc = "Previous hunk" })

-- Diff view
map("n", "<leader>dv", function()
	if vim.t.codediff then
		vim.cmd.tabclose()
	else
		vim.cmd("CodeDiff")
	end
end, { desc = "Toggle diff view" })
map("n", "<leader>dh", "<Cmd>CodeDiff history %<CR>", { desc = "File history" })
map("n", "<leader>dH", "<Cmd>CodeDiff history<CR>", { desc = "Repo history" })

-- Snacks words: jump between occurrences of the word under the cursor
map({ "n", "t" }, "]]", function()
	Snacks.words.jump(vim.v.count1)
end, { desc = "Next reference" })
map({ "n", "t" }, "[[", function()
	Snacks.words.jump(-vim.v.count1)
end, { desc = "Previous reference" })
