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
      -- An open folder's files carry their own markers; don't repeat them on it.
      git = { enable = true, ignore = false, show_on_open_dirs = false },
      renderer = {
        group_empty = true, -- collapse a/b/c chains into one line
        highlight_git = "name",
        highlight_diagnostics = true,
        indent_markers = { enable = true },
        icons = {
          -- One letter at the right edge instead of ✗/★/✓ before the name,
          -- so filenames stay in a straight column. Same letters as review mode.
          git_placement = "right_align",
          glyphs = {
            git = {
              unstaged = "M", staged = "S", untracked = "U",
              renamed = "R", deleted = "D", unmerged = "!",
              ignored = "", -- the dimmed name already says it
            },
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
    config = function(_, opts)
      -- Review mode (<leader>gr) marks files changed vs main on top of the
      -- builtin Git decorator; see lua/config/review.lua. Built here, not
      -- in opts, because it needs nvim-tree on the runtimepath.
      opts.renderer.decorators = {
        "Git", require("config.review").decorator(), "Open", "Hidden",
        "Modified", "Bookmark", "Diagnostics", "Copied", "Cut",
      }
      require("nvim-tree").setup(opts)
    end,
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

  -- oil.nvim — edit a directory as a buffer: rename, delete or add lines,
  -- then :w applies them. Renames ask the language server to update
  -- imports. nvim-tree stays the sidebar and keeps `nvim some/dir`.
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "-", function() require("oil").open_float(nil, { preview = {} }) end, desc = "Oil: edit this directory" },
    },
    opts = {
      default_file_explorer = false,
      columns = {
        "icon",
        { "permissions", highlight = "Type" },
        { "size", highlight = "String" },
        { "mtime", highlight = "Keyword" },
      },
      view_options = { show_hidden = true },
      float = { border = "rounded", max_width = 200 },
      preview_win = { update_on_cursor_moved = true },
      lsp_file_methods = { enabled = true, timeout_ms = 1000, autosave_changes = true },
      keymaps = {
        ["h"] = { "actions.parent", mode = "n" },
        ["q"] = { "actions.close", mode = "n" },
      },
    },
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
