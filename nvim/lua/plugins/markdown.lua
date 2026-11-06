-- =========================================================
-- Markdown — in-buffer rendering, tables, checkboxes, mkdocs
--
-- This repo is markdown-heavy: 20 files, a mkdocs-material site under
-- docs/, the cheatsheets, and README.md. The setup is built around that
-- rather than around note-taking.
--
-- Deliberately NOT a browser-preview plugin. markdown-preview.nvim and
-- friends render *GitHub* markdown, but docs/ is mkdocs-material:
-- `!!! tip` admonitions, `=== "Tab"` content tabs and the Material
-- theme. A browser preview would show those as literal text, i.e. be
-- wrong in exactly the places it matters. For a true preview of the
-- site, `make serve` already exists — <leader>mp below wires it up.
--
-- So: render in-buffer for editing, mkdocs for the real thing.
--
-- Prose options (wrap, linebreak, spell, conceallevel) are set by the
-- "prose" FileType autocmd in config/autocmds.lua, not here.
-- =========================================================

-- --- mkdocs-material syntax ------------------------------
-- render-markdown handles GitHub callouts (`> [!NOTE]`) but has no idea
-- about Material's `!!! tip` / `=== "Tab"`, which are the two
-- constructs this repo uses most (19 admonitions across docs/). To
-- treesitter they are ordinary paragraph text, so they'd sit in the
-- buffer looking like body copy.
--
-- matchadd() is used rather than a treesitter query because it draws on
-- top of whatever the active colorscheme's markdown highlights are, and
-- does not depend on the markdown_inline parse tree staying the same
-- shape across treesitter versions.
local MKDOCS_MATCHES = {
  -- `!!! warning "Title"` and the collapsible `???` / `???+` variants.
  { group = "MkdocsAdmonition", pattern = [[^\s*\(!!!\|???+\?\)\s\+\S\+]] },
  -- `=== "Ghostty"` content tabs.
  { group = "MkdocsTab", pattern = [[^\s*===\s\+".\{-}"]] },
}

local function set_mkdocs_highlights()
  -- Linked rather than given literal colours so these follow the active
  -- theme. Re-applied on ColorScheme because loading a colorscheme
  -- clears every highlight, links included.
  vim.api.nvim_set_hl(0, "MkdocsAdmonition", { link = "Special", bold = true })
  vim.api.nvim_set_hl(0, "MkdocsTab", { link = "Identifier", bold = true })
end

local function apply_mkdocs_matches()
  -- matchadd() is window-local, so this has to run per window, and
  -- guard against stacking duplicates when the same buffer is revisited.
  if vim.w.mkdocs_matched then
    return
  end
  vim.w.mkdocs_matched = true
  for _, m in ipairs(MKDOCS_MATCHES) do
    -- Priority below the default 10 so search highlighting still wins.
    pcall(vim.fn.matchadd, m.group, m.pattern, 8)
  end
end

local function setup_mkdocs_syntax()
  local group = vim.api.nvim_create_augroup("phil_mkdocs_syntax", { clear = true })
  set_mkdocs_highlights()
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = set_mkdocs_highlights,
  })
  vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
    group = group,
    pattern = "markdown",
    callback = apply_mkdocs_matches,
  })
end

-- --- Checkbox toggling -----------------------------------
-- Written here rather than pulled in as a plugin: it is a line
-- substitution, and a dependency for that is not worth the update
-- surface. Cycles [ ] -> [x] -> [ ], and turns a plain list item into a
-- checkbox so you don't have to type the brackets.

-- End index of the line's list marker, or nil if it isn't a list item.
-- Lua patterns have no alternation, hence the two attempts. Ordered
-- markers are included because `1. [ ] item` is a valid task list.
local function list_marker_end(line)
  local _, e = line:find("^%s*[-*+]%s+")
  if e then
    return e
  end
  _, e = line:find("^%s*%d+[%.%)]%s+")
  return e
end

local function toggle_line(line)
  local marker = list_marker_end(line)
  if not marker then
    return nil
  end

  local head, rest = line:sub(1, marker), line:sub(marker + 1)

  -- Anchored to the text immediately after the marker, so a `[x]`
  -- appearing later in the prose is never the thing that gets toggled.
  if rest:match("^%[ %]") then
    return head .. rest:gsub("^%[ %]", "[x]", 1)
  elseif rest:match("^%[[xX]%]") then
    return head .. rest:gsub("^%[[xX]%]", "[ ]", 1)
  elseif rest:match("^%S") then
    -- A plain list item: promote it to an unchecked checkbox.
    return head .. "[ ] " .. rest
  end

  return nil
end

local function toggle_checkbox()
  local first, last = vim.fn.line("v"), vim.fn.line(".")
  -- In normal mode line("v") == line("."), so this covers both a single
  -- line and a visual selection without branching on the mode.
  if first > last then
    first, last = last, first
  end

  for lnum = first, last do
    local new = toggle_line(vim.fn.getline(lnum))
    if new then
      vim.fn.setline(lnum, new)
    end
  end

  -- Leave visual mode so a selection doesn't linger over edited text.
  if vim.fn.mode():match("^[vV]") then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
  end
end

-- --- mkdocs serve ----------------------------------------
-- The real preview. Starts `mkdocs serve` next to the nearest
-- mkdocs.yml and opens the browser; pressing it again stops the server.
local mkdocs_job = nil

local function mkdocs_toggle()
  if mkdocs_job then
    mkdocs_job:kill(15) -- SIGTERM
    mkdocs_job = nil
    vim.notify("mkdocs serve stopped", vim.log.levels.INFO)
    return
  end

  local found = vim.fs.find("mkdocs.yml", { upward = true, path = vim.fn.expand("%:p:h") })[1]
  if not found then
    vim.notify("No mkdocs.yml found above this file", vim.log.levels.WARN)
    return
  end

  if vim.fn.executable("mkdocs") == 0 then
    vim.notify("mkdocs not installed (brew install mkdocs-material)", vim.log.levels.ERROR)
    return
  end

  local root = vim.fs.dirname(found)
  mkdocs_job = vim.system({ "mkdocs", "serve" }, { cwd = root, text = true }, function(res)
    mkdocs_job = nil
    -- code 0 is a clean stop; 143 is the SIGTERM above. Anything else is
    -- a real failure worth surfacing, since the server is detached and
    -- its output is otherwise invisible.
    if res.code ~= 0 and res.code ~= 143 then
      local msg = (res.stderr or ""):gsub("%s+$", "")
      vim.schedule(function()
        vim.notify("mkdocs serve exited (" .. res.code .. ")\n" .. msg, vim.log.levels.ERROR)
      end)
    end
  end)

  vim.notify("mkdocs serve → http://127.0.0.1:8000", vim.log.levels.INFO)
  -- Give the server a moment to bind before the browser asks for it.
  vim.defer_fn(function()
    vim.ui.open("http://127.0.0.1:8000")
  end, 1500)
end

return {
  -- In-buffer rendering ---------------------------------------------------
  -- Draws headings, code blocks, tables, bullets, checkboxes and links as
  -- styled text in the buffer itself. `render_modes` leaves insert mode
  -- raw, and anti_conceal un-renders the line under the cursor, so you
  -- always edit the real source and only ever *read* the pretty version.
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ft = { "markdown", "codecompanion" },
    opts = {
      -- codecompanion's chat buffer is markdown; rendering it makes the
      -- AI responses far easier to skim.
      file_types = { "markdown", "codecompanion" },

      -- Raw source in insert mode. Without this you are editing text
      -- that is shifted by the rendered padding, which feels awful.
      render_modes = { "n", "c", "t" },
      anti_conceal = { enabled = true, above = 0, below = 0 },

      -- The prose autocmd sets conceallevel=2/concealcursor=nc. Restate
      -- the defaults here so toggling render off restores *those* rather
      -- than the global values (which are 0 and "", i.e. raw markers
      -- everywhere).
      win_options = {
        conceallevel = { default = 2, rendered = 3 },
        concealcursor = { default = "nc", rendered = "" },
      },

      heading = {
        sign = false, -- the sign column is already busy with git + diagnostics
        width = "block",
        left_pad = 0,
        right_pad = 2,
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      },

      code = {
        style = "full",
        width = "block",
        border = "thin",
        left_pad = 2,
        right_pad = 2,
        language_pad = 2,
        min_width = 45,
      },

      bullet = { icons = { "●", "○", "◆", "◇" } },

      checkbox = {
        unchecked = { icon = "󰄱 " },
        checked = { icon = "󰱒 ", scope_highlight = "@markup.strikethrough" },
      },

      pipe_table = { preset = "round" },

      -- LaTeX rendering shells out to `latex2text`, which isn't installed
      -- and isn't wanted — off, so it doesn't warn on every $ in prose.
      latex = { enabled = false },

      -- Offer heading/link completion from render-markdown's own source
      -- in addition to marksman's.
      completions = { lsp = { enabled = true } },
    },
    keys = {
      { "<leader>um", "<cmd>RenderMarkdown buf_toggle<cr>", desc = "Toggle markdown render" },
    },
    config = function(_, opts)
      require("render-markdown").setup(opts)
      setup_mkdocs_syntax()
    end,
  },

  -- Tables ----------------------------------------------------------------
  -- Tables are the one part of markdown that is genuinely painful to hand
  -- edit, and 10 files here have them. With table mode on, typing `|`
  -- re-aligns the whole table as you go.
  {
    "dhruvasagar/vim-table-mode",
    cmd = { "TableModeToggle", "TableModeRealign", "Tableize" },
    ft = { "markdown" },
    init = function()
      -- Default corner is `+`, which produces reStructuredText-style
      -- tables that markdown does not understand.
      vim.g.table_mode_corner = "|"
      vim.g.table_mode_corner_corner = "|"
      vim.g.table_mode_header_fillchar = "-"
      -- Don't let the plugin claim <leader>t*; the bindings below are
      -- explicit and scoped to the markdown group.
      vim.g.table_mode_map_prefix = ""
      vim.g.table_mode_disable_mappings = 1
    end,
    keys = {
      { "<leader>mt", "<cmd>TableModeToggle<cr>", desc = "Toggle table mode", ft = "markdown" },
      { "<leader>mr", "<cmd>TableModeRealign<cr>", desc = "Realign table", ft = "markdown" },
      { "<leader>mT", "<cmd>Tableize<cr>", desc = "Tableize selection (CSV → table)", mode = { "n", "v" }, ft = "markdown" },
    },
  },

  -- Local keymaps ---------------------------------------------------------
  -- A specless entry: no plugin, just somewhere to hang the bindings for
  -- the two functions defined at the top of this file, loaded on the same
  -- event as everything else here.
  {
    "nvim-lua/plenary.nvim", -- already a dependency elsewhere; nothing new installed
    ft = "markdown",
    keys = {
      {
        "<leader>mx",
        toggle_checkbox,
        desc = "Toggle checkbox",
        mode = { "n", "v" },
        ft = "markdown",
      },
      { "<leader>mp", mkdocs_toggle, desc = "Toggle mkdocs serve + browser" },
    },
  },
}
