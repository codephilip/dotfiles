-- =========================================================
-- Review mode — see a branch's changes, not just uncommitted ones.
--
-- gitsigns and nvim-tree both diff against the index by default, so on a
-- branch whose work is already committed they show nothing. Review mode
-- diffs against the merge-base with the default branch: gitsigns rebases
-- its gutter onto it, and nvim-tree marks every file the branch touched
-- (via the decorator below).
-- =========================================================

local M = {
  base = nil,  -- merge-base sha while review mode is on
  files = {},  -- absolute path -> "A" | "M" | "D" | "R"
  dirs = {},   -- absolute path -> true, for every parent of a changed file
}

local function git(dir, ...)
  local out = vim.fn.systemlist({ "git", "-C", dir, ... })
  return vim.v.shell_error == 0 and out or nil
end

local function refresh_tree()
  pcall(function() require("nvim-tree.api").tree.reload() end)
end

-- Recompute the changed-file set: committed + uncommitted + untracked.
function M.scan()
  M.files, M.dirs = {}, {}
  if not M.base then return end

  local root = (git(vim.fn.getcwd(), "rev-parse", "--show-toplevel") or {})[1]
  if not root then return end

  local function mark(rel, status)
    local path = root .. "/" .. rel
    M.files[path] = status
    local dir = vim.fs.dirname(path)
    while dir and #dir >= #root and not M.dirs[dir] do
      M.dirs[dir] = true
      dir = vim.fs.dirname(dir)
    end
  end

  for _, line in ipairs(git(root, "diff", "--name-status", "-M", M.base) or {}) do
    local status, a, b = line:match("^(%a)%d*\t([^\t]+)\t?(.*)$")
    if status then
      -- Renames/copies list old\tnew; mark the new path.
      mark(b ~= "" and b or a, (status == "C" or status == "T") and "M" or status)
    end
  end
  for _, rel in ipairs(git(root, "ls-files", "--others", "--exclude-standard") or {}) do
    mark(rel, "A")
  end
  refresh_tree()
end

function M.toggle()
  local gs = require("gitsigns")
  if M.base then
    M.base = nil
    M.scan()
    gs.change_base(nil, true)
    gs.toggle_word_diff(false)
    vim.notify("Git review off — diffing against index")
    return
  end

  local dir = vim.fn.getcwd()
  local default = (git(dir, "rev-parse", "--abbrev-ref", "origin/HEAD") or { "main" })[1]
  local base = (git(dir, "merge-base", "HEAD", default) or {})[1]
  if not base then
    vim.notify("Git review: no merge-base with " .. default, vim.log.levels.WARN)
    return
  end

  M.base = base
  M.scan()
  gs.change_base(base, true)
  gs.toggle_word_diff(true)
  vim.notify(("Git review on — diffing against %s (%s), %d files"):format(
    default, base:sub(1, 7), vim.tbl_count(M.files)))
end

-- Keep the tree current as you edit during a review.
vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("git_review", { clear = true }),
  callback = function()
    if M.base then M.scan() end
  end,
})

-- ---------------------------------------------------------
-- nvim-tree decorator: colour + letter for files changed in review
-- ---------------------------------------------------------

local ICONS = {
  A = { str = "A", hl = { "NvimTreeGitNewIcon" } },
  M = { str = "M", hl = { "NvimTreeGitDirtyIcon" } },
  R = { str = "R", hl = { "NvimTreeGitRenamedIcon" } },
  D = { str = "D", hl = { "NvimTreeGitDeletedIcon" } },
}
local NAME_HL = {
  A = "NvimTreeGitFileNewHL",
  M = "NvimTreeGitFileDirtyHL",
  R = "NvimTreeGitFileRenamedHL",
  D = "NvimTreeGitFileDeletedHL",
}

function M.decorator()
  local Decorator = require("nvim-tree.api").Decorator:extend()

  function Decorator:new()
    self.enabled = M.base ~= nil
    self.highlight_range = "name"
    self.icon_placement = "after"
  end

  function Decorator:highlight_group(node)
    local status = M.files[node.absolute_path]
    if status then return NAME_HL[status] end
    if M.dirs[node.absolute_path] then return "NvimTreeGitFolderDirtyHL" end
  end

  function Decorator:icons(node)
    local status = M.files[node.absolute_path]
    if status then return { ICONS[status] } end
  end

  return Decorator
end

return M
