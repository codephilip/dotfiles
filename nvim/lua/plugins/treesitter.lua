-- =========================================================
-- Treesitter — syntax understanding, motions, sticky context
--
-- NOTE: pinned to `branch = "master"`. The `main` branch is a full rewrite
-- that requires Neovim >= 0.12 (nightly); this config targets 0.11.x.
-- When you upgrade to 0.12, migrate this file rather than just unpinning —
-- the setup API is entirely different.
-- =========================================================

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false, -- treesitter does not support lazy-loading
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = {
        "bash", "c", "comment", "css", "diff", "dockerfile", "git_config",
        "gitcommit", "gitignore", "go", "gomod", "gosum", "gotmpl", "hcl",
        "html", "javascript", "json", "jsonc", "lua", "luadoc", "make",
        "markdown", "markdown_inline", "python", "query", "regex", "rust",
        "sql", "terraform", "toml", "tsx", "typescript", "vim", "vimdoc",
        "yaml",
      },
      auto_install = true, -- grab a parser on first visit to a new filetype
      highlight = { enable = true },
      indent = { enable = true },

      -- Grow the selection by syntax node: the fastest way to understand
      -- how an expression nests. Start with <C-space>, repeat to widen.
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },

      textobjects = {
        -- Operate on syntax units: `vaf` a whole function, `dif` its body.
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["ab"] = "@block.outer",
            ["ib"] = "@block.inner",
            ["a/"] = "@comment.outer",
          },
        },
        -- Jump between functions/classes without leaving normal mode.
        move = {
          enable = true,
          set_jumps = true, -- so <C-o> brings you back
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
        },
        swap = {
          enable = true,
          swap_next = { ["<leader>cp"] = "@parameter.inner" },
          swap_previous = { ["<leader>cP"] = "@parameter.inner" },
        },
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "master", -- same 0.12 caveat as above
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = { "BufReadPost", "BufNewFile" },
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
