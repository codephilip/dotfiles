-- =========================================================
-- Plugins — minimal IDE, tmux-friendly
-- =========================================================

-- -------------------------
-- Bootstrap lazy.nvim
-- -------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  -- =========================================================
  -- File tree (Space + e)
  -- =========================================================
{
  "nvim-tree/nvim-tree.lua",
  config = function()
    require("nvim-tree").setup({
      view = { width = 32 },
      renderer = {
        highlight_git = true,
        icons = {
          show = {
            file = false,
            folder = false,
            folder_arrow = false,
            git = false,
          },
        },
      },
      filters = { dotfiles = false },
    })

    vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true })
  end,
},
  -- =========================================================
  -- tmux <-> nvim navigation
  -- =========================================================
  {
    "christoomey/vim-tmux-navigator",
  },

  -- =========================================================
  -- Fuzzy finder (fzf)
  -- =========================================================
  {
    "junegunn/fzf",
    build = "./install --bin",
  },
  {
    "junegunn/fzf.vim",
    dependencies = { "junegunn/fzf" },
    config = function()
      vim.g.fzf_layout = {
        window = {
          width = 0.9,
          height = 0.8,
          border = "rounded",
        },
      }

      local map = vim.keymap.set
      map("n", "<leader>ff", ":Files<CR>")
      map("n", "<leader>fg", ":GFiles<CR>")
      map("n", "<leader>fb", ":Buffers<CR>")
      map("n", "<leader>fw", ":Rg<CR>")
      map("n", "<leader>fh", ":Helptags<CR>")
    end,
  },

  -- =========================================================
  -- Treesitter
  -- =========================================================
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua", "vim", "bash",
          "json", "yaml",
          "javascript", "typescript",
          "html", "css", "python",
        },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- =========================================================
  -- Git signs
  -- =========================================================
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- =========================================================
  -- Autocompletion (minimal)
  -- =========================================================
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        },
        snippet = {
  expand = function(args)
    require("luasnip").lsp_expand(args.body)
  end,
},
      })
    end,
  },

  -- =========================================================
  -- LSP
  -- =========================================================
  {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local lsp = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local on_attach = function(_, bufnr)
        local map = vim.keymap.set
        local opts = { buffer = bufnr }
        map("n", "<leader>f", function()
          vim.lsp.buf.format({ async = true })
        end, opts)
        map("n", "gd", vim.lsp.buf.definition, opts)
        map("n", "gr", vim.lsp.buf.references, opts)
        map("n", "K", vim.lsp.buf.hover, opts)
        map("n", "<leader>rn", vim.lsp.buf.rename, opts)
        map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      end

lsp.lua_ls.setup({ on_attach = on_attach, capabilities = capabilities })
lsp.ts_ls.setup({ on_attach = on_attach, capabilities = capabilities })
lsp.pyright.setup({ on_attach = on_attach, capabilities = capabilities })
lsp.gopls.setup({ on_attach = on_attach, capabilities = capabilities })
lsp.rust_analyzer.setup({ on_attach = on_attach, capabilities = capabilities })
lsp.bashls.setup({ on_attach = on_attach, capabilities = capabilities })
lsp.yamlls.setup({ on_attach = on_attach, capabilities = capabilities })
lsp.jsonls.setup({ on_attach = on_attach, capabilities = capabilities })

    end,
  },

  -- =========================================================
  -- LSP installer
  -- =========================================================
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  -- =========================================================
  -- Safe buffer delete
  -- =========================================================
  {
    "famiu/bufdelete.nvim",
    config = function()
      vim.keymap.set("n", "<leader>bd", ":Bdelete<CR>", { silent = true })
    end,
  },
})
