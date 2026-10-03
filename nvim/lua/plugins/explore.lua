-- =========================================================
-- Structural exploration: file tree, symbol outline, motion
-- =========================================================

return {
  -- nvim-tree — the project sidebar.
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false, -- so `nvim some/dir` opens the tree
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      hijack_cursor = true,
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      update_focused_file = { enable = true, update_root = false },
      view = { width = 34, preserve_window_proportions = true },
      filters = { dotfiles = false, custom = { "^%.git$", "^node_modules$", "^%.DS_Store$" } },
      git = { enable = true, ignore = false },
      renderer = {
        group_empty = true, -- collapse a/b/c chains into one line
        highlight_git = true,
        highlight_diagnostics = true,
        indent_markers = { enable = true },
        icons = {
          glyphs = {
            git = { unstaged = "", staged = "", unmerged = "", renamed = "", untracked = "", deleted = "" },
          },
        },
      },
      diagnostics = { enable = true, show_on_dirs = true },
      actions = { open_file = { quit_on_open = false, window_picker = { enable = false } } },
      on_attach = function(bufnr)
        local api = require("nvim-tree.api")
        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- Start from the sane defaults, then adjust.
        api.config.mappings.default_on_attach(bufnr)

        -- Free <C-k>/<C-h> etc. for window navigation.
        vim.keymap.del("n", "<C-k>", { buffer = bufnr })
        vim.keymap.set("n", "i", api.node.show_info_popup, opts("Info"))
        vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close directory"))
        vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "<C-t>", api.tree.change_root_to_node, opts("CD into directory"))
      end,
    },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "File explorer" },
      { "<leader>E", "<cmd>NvimTreeFindFile<cr>", desc = "Reveal current file in tree" },
    },
    init = function()
      -- nvim-tree requires netrw be disabled before it loads.
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
  },

  -- aerial.nvim — a symbol outline of the current file. The single best
  -- plugin for getting oriented in a large unfamiliar source file.
  {
    "stevearc/aerial.nvim",
    -- master requires Neovim 0.12; this is the maintained 0.11 branch.
    -- Drop the pin once you're on 0.12.
    branch = "nvim-0.11",
    cmd = { "AerialToggle", "AerialOpen", "AerialNavToggle" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      backends = { "lsp", "treesitter", "markdown", "man" },
      layout = { default_direction = "right", width = 34, min_width = 28 },
      attach_mode = "global",
      show_guides = true,
      filter_kind = false, -- show every symbol kind, not just the big ones
      guides = {
        mid_item = "├─",
        last_item = "└─",
        nested_top = "│ ",
        whitespace = "  ",
      },
      keymaps = {
        ["<CR>"] = "actions.jump",
        ["o"] = "actions.jump",
        ["q"] = "actions.close",
      },
    },
    keys = {
      { "<leader>o", "<cmd>AerialToggle<cr>", desc = "Symbol outline" },
      { "<leader>cO", "<cmd>AerialNavToggle<cr>", desc = "Symbol nav (floating)" },
      { "[[", "<cmd>AerialPrev<cr>", desc = "Prev symbol" },
      { "]]", "<cmd>AerialNext<cr>", desc = "Next symbol" },
    },
  },

  -- flash.nvim — jump anywhere visible by typing 2 characters plus a label.
  -- Replaces most `/`-searching when you can already see your target.
  -- Note: this takes over `s` in normal mode; use `cl` for the old behaviour.
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      modes = {
        char = { jump_labels = true }, -- label f/t/F/T targets too
        search = { enabled = false },  -- don't hijack `/`
      },
    },
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash jump" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote flash" },
    },
  },

  -- Auto-close brackets and quotes, aware of treesitter context.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      fast_wrap = {}, -- <M-e> to wrap the next object in the pair you just typed
    },
  },
}
