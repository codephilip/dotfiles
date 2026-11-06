-- =========================================================
-- Context for AI agents: copy a file reference or a code block to paste
-- into a chat (Claude Code in another pane, a web chat, a PR comment).
-- Keys in lua/config/keymaps.lua, under <leader>y.
--
-- claudecode.nvim (<leader>as / <leader>ab) is the other route, for the
-- Claude split inside Neovim.
-- =========================================================

local M = {}

local ROOT_MARKERS = { ".git", "package.json", "pyproject.toml", "go.mod", "Cargo.toml", "Makefile" }

-- Resolve symlinks and drop a trailing slash.
local function normalize(path)
  path = vim.uv.fs_realpath(path) or path
  return (path:gsub("(.)/$", "%1"))
end

-- Project root of the current buffer: the nearest parent holding a root
-- marker, or cwd.
function M.root()
  local name = vim.api.nvim_buf_get_name(0)
  local start = name ~= "" and vim.fs.dirname(name) or vim.uv.cwd()
  local marker = vim.fs.find(ROOT_MARKERS, { path = start, upward = true })[1]
  return normalize(marker and vim.fs.dirname(marker) or vim.uv.cwd())
end

local function copy(text, msg)
  vim.fn.setreg("+", text)
  vim.notify(msg or ("Copied: " .. text), vim.log.levels.INFO)
end

-- `path/relative/to/cwd#L42`
function M.copy_relative_path()
  copy(vim.fn.expand("%:.") .. "#L" .. vim.fn.line("."))
end

-- `/absolute/path#L42`
function M.copy_absolute_path()
  copy(vim.fn.expand("%:p") .. "#L" .. vim.fn.line("."))
end

local SHORT_LANG = {
  typescriptreact = "tsx",
  javascriptreact = "jsx",
  typescript = "ts",
  javascript = "js",
  python = "py",
}

-- The visual selection as a Markdown code block carrying the path from
-- the project root and the first line number:
--   ```ts filename="src/app.ts" line=12
function M.copy_as_codeblock()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("Buffer has no file name", vim.log.levels.WARN)
    return
  end
  local first, last = vim.fn.line("v"), vim.fn.line(".")
  if first > last then
    first, last = last, first
  end
  vim.cmd("normal! " .. vim.keycode("<Esc>"))

  local root, path = M.root(), normalize(file)
  if path:find(root .. "/", 1, true) == 1 then
    path = path:sub(#root + 2)
  end
  local lang = SHORT_LANG[vim.bo.filetype] or vim.bo.filetype
  local lines = vim.api.nvim_buf_get_lines(0, first - 1, last, false)

  local block = { ('```%s filename="%s" line=%d'):format(lang, path, first) }
  vim.list_extend(block, lines)
  block[#block + 1] = "```"
  copy(table.concat(block, "\n"), ("Copied %d line%s as a code block"):format(#lines, #lines == 1 and "" or "s"))
end

-- The project's package.json in a centred float, 80% of the editor.
-- q or <Esc> closes it.
function M.open_package_json()
  local file = vim.fs.joinpath(M.root(), "package.json")
  if not vim.uv.fs_stat(file) then
    vim.notify("No package.json in " .. M.root(), vim.log.levels.WARN)
    return
  end

  local width, height = math.floor(vim.o.columns * 0.8), math.floor(vim.o.lines * 0.8)
  local buf = vim.fn.bufadd(file)
  vim.fn.bufload(buf)
  vim.bo[buf].buflisted = true
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    title = " package.json ",
    title_pos = "center",
  })

  local keys = { "q", "<Esc>" }
  for _, key in ipairs(keys) do
    vim.keymap.set("n", key, function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, false)
      end
    end, { buffer = buf, nowait = true, desc = "Close package.json" })
  end
  -- The buffer may be opened in a normal window later: drop the keys then.
  vim.api.nvim_create_autocmd("WinClosed", {
    pattern = tostring(win),
    once = true,
    callback = function()
      for _, key in ipairs(keys) do
        pcall(vim.keymap.del, "n", key, { buffer = buf })
      end
    end,
  })
end

return M
