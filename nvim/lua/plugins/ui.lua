-- =========================================================
-- Look & feel: colorscheme, icons, statusline, bufferline,
-- dashboard, colour highlighting, keymap discovery.
-- =========================================================

local theme = require("config.theme")

return {
  -- Colorschemes -----------------------------------------------------------
  -- All three are installed; `lazy` is driven by which one
  -- ~/.config/theme/current names, so exactly one loads at startup with
  -- priority 1000 and the other two sit on disk unloaded.
  --
  -- Switch with `theme <name>` in the shell, then restart nvim.
  --
  -- Every one of them is set transparent: the background comes from
  -- Ghostty, which is what lets its blur show through the editor
  -- instead of nvim painting an opaque rectangle over the glass.

  -- Tokyo Night ------------------------------------------------------------
  {
    "folke/tokyonight.nvim",
    lazy = not theme.is_active("tokyonight"),
    priority = 1000,
    opts = {
      style = "night",
      transparent = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = { bold = true },
        -- Without these two the sidebar and float backgrounds stay
        -- opaque and the transparency looks half-applied.
        sidebars = "transparent",
        floats = "transparent",
      },
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      if theme.is_active("tokyonight") then
        vim.cmd.colorscheme(theme.current.colorscheme)
      end
    end,
  },

  -- Solarized Osaka --------------------------------------------------------
  -- craftzdog's theme; a tokyonight fork, so it takes the same options.
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = not theme.is_active("solarized-osaka"),
    priority = 1000,
    opts = {
      transparent = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = { bold = true },
        sidebars = "transparent",
        floats = "transparent",
      },
    },
    config = function(_, opts)
      require("solarized-osaka").setup(opts)
      if theme.is_active("solarized-osaka") then
        vim.cmd.colorscheme(theme.current.colorscheme)
      end
    end,
  },

  -- Catppuccin Mocha -------------------------------------------------------
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = not theme.is_active("catppuccin-mocha"),
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = true,
      styles = {
        comments = { "italic" },
        keywords = { "italic" },
        functions = { "bold" },
      },
      integrations = {
        blink_cmp = true,
        fzf = true,
        gitsigns = true,
        aerial = true,
        alpha = true,
        barbar = true,
        nvimtree = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
        mason = true,
        flash = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      if theme.is_active("catppuccin-mocha") then
        vim.cmd.colorscheme(theme.current.colorscheme)
      end
    end,
  },

  -- Icons -----------------------------------------------------------------
  { "nvim-tree/nvim-web-devicons", lazy = true, opts = {} },

  -- Statusline ------------------------------------------------------------
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = theme.current.lualine,
        globalstatus = true,
        component_separators = { left = "│", right = "│" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = { statusline = { "alpha" } },
      },
      sections = {
        lualine_a = { { "mode", separator = { left = "" }, padding = { left = 1, right = 1 } } },
        lualine_b = { "branch" },
        lualine_c = {
          { "diagnostics", symbols = { error = " ", warn = " ", info = " ", hint = " " } },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { "filename", path = 1 }, -- relative path: useful when exploring
        },
        lualine_x = {
          { "diff", symbols = { added = " ", modified = " ", removed = " " } },
          -- Show which LSP servers are attached to this buffer.
          {
            function()
              local names = {}
              for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
                names[#names + 1] = client.name
              end
              return #names > 0 and (" " .. table.concat(names, " ")) or ""
            end,
            cond = function() return vim.o.columns > 100 end,
          },
        },
        lualine_y = { { "progress", padding = { left = 1, right = 0 } } },
        lualine_z = { { "location", separator = { right = "" }, padding = { left = 1, right = 1 } } },
      },
      extensions = { "lazy", "mason", "nvim-tree", "aerial", "quickfix" },
    },
  },

  -- Bufferline ------------------------------------------------------------
  -- barbar gives real, reorderable buffer tabs along the top.
  {
    "romgrk/barbar.nvim",
    event = "VeryLazy",
    dependencies = {
      "lewis6991/gitsigns.nvim",      -- git status in the tab
      "nvim-tree/nvim-web-devicons",  -- filetype icons
    },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    opts = {
      animation = true,
      clickable = true,
      insert_at_end = true,
      icons = {
        button = "",
        separator = { left = "▎", right = "" },
        modified = { button = "●" },
        pinned = { button = "", filename = true },
        gitsigns = {
          added = { enabled = true, icon = "+" },
          changed = { enabled = true, icon = "~" },
          deleted = { enabled = true, icon = "-" },
        },
      },
      -- Shift tabs aside rather than covering them when nvim-tree opens.
      sidebar_filetypes = {
        NvimTree = true,
        aerial = { text = "Outline" },
      },
    },
    keys = {
      { "<S-h>", "<cmd>BufferPrevious<cr>", desc = "Previous buffer" },
      { "<S-l>", "<cmd>BufferNext<cr>", desc = "Next buffer" },
      { "<leader>b<", "<cmd>BufferMovePrevious<cr>", desc = "Move buffer left" },
      { "<leader>b>", "<cmd>BufferMoveNext<cr>", desc = "Move buffer right" },
      { "<leader>bp", "<cmd>BufferPin<cr>", desc = "Pin/unpin buffer" },
      { "<leader>bd", "<cmd>BufferClose<cr>", desc = "Close buffer" },
      { "<leader>bo", "<cmd>BufferCloseAllButCurrentOrPinned<cr>", desc = "Close other buffers" },
      { "<leader>bP", "<cmd>BufferCloseAllButPinned<cr>", desc = "Close unpinned buffers" },
      { "<leader>bs", "<cmd>BufferPick<cr>", desc = "Pick buffer (jump by letter)" },
      -- Jump straight to a tab position
      { "<leader>1", "<cmd>BufferGoto 1<cr>", desc = "Buffer 1" },
      { "<leader>2", "<cmd>BufferGoto 2<cr>", desc = "Buffer 2" },
      { "<leader>3", "<cmd>BufferGoto 3<cr>", desc = "Buffer 3" },
      { "<leader>4", "<cmd>BufferGoto 4<cr>", desc = "Buffer 4" },
      { "<leader>5", "<cmd>BufferGoto 5<cr>", desc = "Buffer 5" },
      { "<leader>9", "<cmd>BufferLast<cr>", desc = "Last buffer" },
    },
  },

  -- Startup dashboard ------------------------------------------------------
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = {
        [[                                                    ]],
        [[ ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗ ]],
        [[ ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║ ]],
        [[ ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║ ]],
        [[ ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║ ]],
        [[ ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║ ]],
        [[ ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝ ]],
        [[                                                    ]],
      }

      dashboard.section.buttons.val = {
        dashboard.button("f", "  Find file", "<cmd>FzfLua files<cr>"),
        dashboard.button("/", "  Grep text", "<cmd>FzfLua live_grep<cr>"),
        dashboard.button("r", "  Recent files", "<cmd>FzfLua oldfiles<cr>"),
        dashboard.button("e", "  File explorer", "<cmd>NvimTreeToggle<cr>"),
        dashboard.button("g", "  Lazygit", "<cmd>Lazygit<cr>"),
        dashboard.button("a", "  Claude Code", "<cmd>ClaudeCode<cr>"),
        dashboard.button("c", "  Config", "<cmd>lua require('fzf-lua').files({ cwd = vim.fn.stdpath('config') })<cr>"),
        dashboard.button("l", "󰒲  Lazy", "<cmd>Lazy<cr>"),
        dashboard.button("q", "  Quit", "<cmd>qa<cr>"),
      }

      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.opts.layout[1].val = 6

      alpha.setup(dashboard.opts)

      -- Once lazy.nvim finishes, show the startup time in the footer.
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        once = true,
        callback = function()
          local stats = require("lazy").stats()
          local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
          dashboard.section.footer.val =
            "⚡ " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms"
          dashboard.section.footer.opts.hl = "AlphaFooter"
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },

  -- Inline colour swatches for hex/rgb/named colours -----------------------
  -- Using the maintained fork; norcalli/nvim-colorizer.lua is archived.
  {
    "catgoose/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "ColorizerToggle", "ColorizerAttachToBuffer", "ColorizerReloadAllBuffers" },
    opts = {
      filetypes = { "*", "!lazy", "!alpha", "!NvimTree" },
      user_default_options = {
        names = false,     -- don't colour the word "red" in prose
        tailwind = true,
        css = true,
        mode = "virtualtext",
        virtualtext = "■",
        always_update = true,
      },
    },
    keys = {
      { "<leader>uc", "<cmd>ColorizerToggle<cr>", desc = "Toggle colour swatches" },
    },
  },

  -- Keymap discovery ------------------------------------------------------
  -- Press <leader> and wait: every binding shows up, grouped.
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      spec = {
        { "<leader>a", group = "ai (claude code)" },
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>m", group = "markdown" },
        { "<leader>n", group = "ai chat" },
        { "<leader>s", group = "search" },
        { "<leader>u", group = "ui/toggle" },
        { "<leader>x", group = "diagnostics/quickfix" },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },
      },
    },
    keys = {
      { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer keymaps" },
    },
  },
}
