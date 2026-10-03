-- =========================================================
-- Autocommands
-- =========================================================

local function augroup(name)
  return vim.api.nvim_create_augroup("phil_" .. name, { clear = true })
end

-- Briefly highlight whatever you just yanked.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank({ timeout = 150 })
  end,
})

-- Jump back to the last cursor position when reopening a file.
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_location"),
  callback = function(event)
    local exclude = { "gitcommit", "gitrebase" }
    if vim.tbl_contains(exclude, vim.bo[event.buf].filetype) then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(event.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Close throwaway/informational buffers with a bare `q`.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "help", "man", "qf", "checkhealth", "lspinfo", "startuptime",
    "fugitive", "git", "gitsigns-blame", "notify", "query",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true, desc = "Close window" })
  end,
})

-- Resize splits proportionally when the terminal window changes size.
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Create missing parent directories when writing a new file.
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return -- skip URLs (oil://, fugitive://, …)
    end
    vim.fn.mkdir(vim.fn.fnamemodify(vim.uv.fs_realpath(event.match) or event.match, ":p:h"), "p")
  end,
})

-- Trim trailing whitespace on save, but only in ordinary editable file
-- buffers — never in scratch/terminal/plugin UI buffers, where :s errors.
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("trim_whitespace"),
  callback = function(event)
    if vim.bo[event.buf].buftype ~= "" or not vim.bo[event.buf].modifiable then
      return
    end
    local skip = { "diff", "gitcommit", "markdown" } -- trailing spaces are meaningful
    if vim.tbl_contains(skip, vim.bo[event.buf].filetype) then
      return
    end
    local view = vim.fn.winsaveview()
    pcall(function() vim.cmd([[keeppatterns %s/\s\+$//e]]) end)
    vim.fn.winrestview(view)
  end,
})

-- Treesitter-based folding and smarter indent, where a parser exists.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("treesitter_fold"),
  callback = function(event)
    local ok, parser = pcall(vim.treesitter.get_parser, event.buf)
    if ok and parser then
      vim.wo.foldmethod = "expr"
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end
  end,
})

-- Don't continue comment leaders onto a new line. Stops `-- foo<CR>` from
-- producing another `-- `, which is almost never what you want.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("no_auto_comment"),
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- Reload buffers that changed on disk. This matters a lot here: Claude Code
-- and lazygit both edit files behind your back, and without this you'd keep
-- editing a stale buffer and clobber their work on the next :w.
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "TermClose", "TermLeave" }, {
  group = augroup("auto_reload"),
  callback = function()
    if vim.bo.buftype == "" and vim.fn.getcmdwintype() == "" then
      vim.cmd("checktime")
    end
  end,
})

-- Say so when that happens, rather than silently swapping the text.
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  group = augroup("auto_reload_notify"),
  callback = function()
    vim.notify("File changed on disk — buffer reloaded", vim.log.levels.INFO)
  end,
})

-- Relative numbers while moving around, absolute while typing or when the
-- window isn't focused (relative numbers are useless in both cases).
local function relnum(on)
  return function()
    if vim.wo.number and vim.api.nvim_get_mode().mode ~= "i" then
      vim.wo.relativenumber = on
    end
  end
end
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
  group = augroup("relnum"),
  callback = relnum(true),
})
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
  group = augroup("relnum"),
  callback = relnum(false),
})

-- Don't leave Neovim sitting open with nothing but the file tree in it.
vim.api.nvim_create_autocmd("QuitPre", {
  group = augroup("close_tree_last"),
  callback = function()
    local floating = function(w)
      return vim.api.nvim_win_get_config(w).relative ~= ""
    end
    local wins = vim.tbl_filter(function(w)
      return not floating(w)
    end, vim.api.nvim_tabpage_list_wins(0))

    if #wins == 2 then
      for _, w in ipairs(wins) do
        if vim.bo[vim.api.nvim_win_get_buf(w)].filetype == "NvimTree" then
          vim.api.nvim_win_close(w, true)
        end
      end
    end
  end,
})

-- Soft wrap and spell check in prose buffers.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("prose"),
  pattern = { "markdown", "gitcommit", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.spell = true
    -- Render **bold** and `code` rather than showing the markers, but
    -- reveal them again on the line you're actually editing.
    vim.opt_local.conceallevel = 2
    vim.opt_local.concealcursor = "nc"
  end,
})
