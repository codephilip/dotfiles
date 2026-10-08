-- =========================================================
-- Treesitter — syntax understanding, motions, sticky context
--
-- Targets Neovim >= 0.12 and the `main` branch of nvim-treesitter (a full
-- rewrite of the frozen `master` branch, which breaks on 0.12). On `main`
-- the plugin only installs parsers and queries; highlighting, folding and
-- incremental selection are Neovim built-ins we switch on ourselves.
-- Building parsers needs the `tree-sitter` CLI (brew: tree-sitter-cli).
-- =========================================================

local ensure_installed = {
  "bash", "c", "comment", "css", "diff", "dockerfile", "git_config",
  "gitcommit", "gitignore", "go", "gomod", "gosum", "gotmpl", "hcl",
  "html", "javascript", "json", "lua", "luadoc", "make",
  "markdown", "markdown_inline", "python", "query", "regex", "rust",
  "sql", "terraform", "toml", "tsx", "typescript", "vim", "vimdoc",
  "yaml",
}

-- Highlighting and (experimental) treesitter indent for a buffer.
local function attach(buf, lang)
  if not vim.api.nvim_buf_is_valid(buf) then return end
  if not pcall(vim.treesitter.start, buf, lang) then return end
  vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end

-- Textobject helpers: `main` has no keymap tables, so we map them by hand.
local function select_to(query)
  return function()
    require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
  end
end

local function move(fn, query)
  return function()
    require("nvim-treesitter-textobjects.move")[fn](query, "textobjects")
  end
end

local function swap(fn, query)
  return function()
    require("nvim-treesitter-textobjects.swap")[fn](query)
  end
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- treesitter does not support lazy-loading
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      ts.install(ensure_installed)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter_attach", { clear = true }),
        callback = function(event)
          local lang = vim.treesitter.language.get_lang(event.match)
          if not lang then return end

          if vim.list_contains(ts.get_installed("parsers"), lang) then
            attach(event.buf, lang)
          elseif vim.list_contains(ts.get_available(), lang) then
            -- Grab a parser on first visit to a new filetype, then attach.
            ts.install({ lang }):await(function(err)
              if not err then
                vim.schedule(function() attach(event.buf, lang) end)
              end
            end)
          end
        end,
      })

      -- Grow the selection by syntax node: the fastest way to understand
      -- how an expression nests. Start with <C-space>, repeat to widen.
      -- (Neovim 0.12 also ships `an`/`in`/`]n`/`[n` in visual mode.)
      vim.keymap.set({ "n", "x" }, "<C-space>", function()
        vim.treesitter.select("parent", vim.v.count1)
      end, { desc = "Expand selection by node" })
      vim.keymap.set("x", "<bs>", function()
        vim.treesitter.select("child", vim.v.count1)
      end, { desc = "Shrink selection by node" })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      select = { lookahead = true },
      move = { set_jumps = true }, -- so <C-o> brings you back
    },
    keys = {
      -- Operate on syntax units: `vaf` a whole function, `dif` its body.
      { "af", select_to("@function.outer"), mode = { "x", "o" }, desc = "Function (outer)" },
      { "if", select_to("@function.inner"), mode = { "x", "o" }, desc = "Function (inner)" },
      { "ac", select_to("@class.outer"), mode = { "x", "o" }, desc = "Class (outer)" },
      { "ic", select_to("@class.inner"), mode = { "x", "o" }, desc = "Class (inner)" },
      { "aa", select_to("@parameter.outer"), mode = { "x", "o" }, desc = "Parameter (outer)" },
      { "ia", select_to("@parameter.inner"), mode = { "x", "o" }, desc = "Parameter (inner)" },
      { "ab", select_to("@block.outer"), mode = { "x", "o" }, desc = "Block (outer)" },
      { "ib", select_to("@block.inner"), mode = { "x", "o" }, desc = "Block (inner)" },
      { "a/", select_to("@comment.outer"), mode = { "x", "o" }, desc = "Comment" },

      -- Jump between functions/classes without leaving normal mode.
      { "]f", move("goto_next_start", "@function.outer"), mode = { "n", "x", "o" }, desc = "Next function start" },
      { "]c", move("goto_next_start", "@class.outer"), mode = { "n", "x", "o" }, desc = "Next class start" },
      { "]F", move("goto_next_end", "@function.outer"), mode = { "n", "x", "o" }, desc = "Next function end" },
      { "]C", move("goto_next_end", "@class.outer"), mode = { "n", "x", "o" }, desc = "Next class end" },
      { "[f", move("goto_previous_start", "@function.outer"), mode = { "n", "x", "o" }, desc = "Prev function start" },
      { "[c", move("goto_previous_start", "@class.outer"), mode = { "n", "x", "o" }, desc = "Prev class start" },
      { "[F", move("goto_previous_end", "@function.outer"), mode = { "n", "x", "o" }, desc = "Prev function end" },
      { "[C", move("goto_previous_end", "@class.outer"), mode = { "n", "x", "o" }, desc = "Prev class end" },

      { "<leader>cp", swap("swap_next", "@parameter.inner"), desc = "Swap parameter with next" },
      { "<leader>cP", swap("swap_previous", "@parameter.inner"), desc = "Swap parameter with previous" },
    },
  },

  -- Sticky header showing the function/class/if you're currently inside.
  -- Invaluable when scrolling through a long unfamiliar function.
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      max_lines = 4,
      multiline_threshold = 1,
      trim_scope = "outer",
      mode = "cursor",
      separator = "─",
    },
    keys = {
      {
        "<leader>ut",
        function() require("treesitter-context").toggle() end,
        desc = "Toggle treesitter context",
      },
      {
        "[x",
        function() require("treesitter-context").go_to_context(vim.v.count1) end,
        desc = "Jump to context (upwards)",
      },
    },
  },
}
