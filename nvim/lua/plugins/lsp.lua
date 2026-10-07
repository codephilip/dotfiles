-- =========================================================
-- LSP — uses Neovim 0.11's native vim.lsp.config / vim.lsp.enable.
-- mason installs the servers; mason-lspconfig enables each installed
-- server automatically (automatic_enable defaults to true in v2).
-- =========================================================

-- Language servers to install and enable. Keep this list short; every
-- entry is a process Neovim will spawn.
local SERVERS = {
  "lua_ls",
  "gopls",
  "ts_ls",
  "pyright",
  "bashls",
  "jsonls",
  "yamlls",
  "terraformls",
  "dockerls",
  -- marksman: markdown. Completion for `[](relative/path)` links and
  -- `#heading` anchors, go-to-definition on a link, and document symbols
  -- (`gO`) as a heading outline. That is what makes a 20-file
  -- cross-linked mkdocs site navigable.
  "marksman",
}

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      {
        "mason-org/mason.nvim",
        -- Also loadable on its own, so :Mason works from the dashboard
        -- before any file buffer has opened.
        cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate", "MasonLog" },
        keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason (LSP/tool installer)" } },
        opts = { ui = { border = "rounded" } },
      },
      { "mason-org/mason-lspconfig.nvim", opts = {
        -- Servers matching the toolchains you already have installed.
        -- Add more with `:Mason`, then add the name to BOTH lists below.
        ensure_installed = SERVERS,
        -- Explicit allow-list rather than the default `true`. Mason also
        -- holds formatters/linters (stylua, shellcheck…); some of those
        -- share a name with an nvim-lspconfig entry and would otherwise be
        -- started as a language server and immediately crash.
        automatic_enable = SERVERS,
      } },
      "saghen/blink.cmp", -- load first so capabilities are registered
    },
    config = function()
      -- Advertise blink.cmp's extra completion capabilities to every server.
      local ok, blink = pcall(require, "blink.cmp")
      if ok then
        vim.lsp.config("*", { capabilities = blink.get_lsp_capabilities(nil, true) })
      end

      -- Per-server tweaks. These merge into whatever nvim-lspconfig ships.
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            codeLens = { enable = true },
            hint = { enable = true, arrayIndex = "Disable" },
            diagnostics = { globals = { "vim" } },
            telemetry = { enable = false },
          },
        },
      })

      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            analyses = { unusedparams = true, unusedwrite = true, nilness = true },
            staticcheck = true,
          },
        },
      })

      -- Keymaps attach per-buffer, only once a server is actually running.
      -- Neovim 0.11 already provides: K (hover), grn (rename), gra (code
      -- action), grr (references), gri (implementation), gO (symbols).
      -- These add picker-backed versions and a few extras.
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("phil_lsp_attach", { clear = true }),
        callback = function(event)
          local fzf = require("fzf-lua")
          local function map(keys, fn, desc, mode)
            vim.keymap.set(mode or "n", keys, fn, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- Navigation — the core of reading unfamiliar code.
          map("gd", fzf.lsp_definitions, "Goto definition")
          map("gD", fzf.lsp_declarations, "Goto declaration")
          map("gr", fzf.lsp_references, "References")
          map("gI", fzf.lsp_implementations, "Goto implementation")
          map("gy", fzf.lsp_typedefs, "Goto type definition")
          map("gO", fzf.lsp_document_symbols, "Document symbols")
          map("<leader>cs", fzf.lsp_live_workspace_symbols, "Workspace symbols")
          map("<leader>cc", fzf.lsp_incoming_calls, "Incoming calls")
          map("<leader>cC", fzf.lsp_outgoing_calls, "Outgoing calls")

          -- Actions.
          map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action", { "n", "v" })
          map("<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "Format buffer")
          map("<leader>ci", vim.lsp.buf.hover, "Hover info")
          -- Signature help in insert mode is <C-s>, provided by Neovim 0.11
          -- by default. Not remapped here: <C-k> belongs to blink.cmp.

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if not client then
            return
          end

          -- Inlay hints: off by default (they add visual noise), toggleable.
          if client:supports_method("textDocument/inlayHint") then
            map("<leader>uh", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }),
                { bufnr = event.buf })
            end, "Toggle inlay hints")
          end

          -- Highlight other references to the symbol under the cursor.
          if client:supports_method("textDocument/documentHighlight") then
            local group = vim.api.nvim_create_augroup("phil_lsp_highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              group = group,
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              group = group,
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })
    end,
  },

  -- Completion ------------------------------------------------------------
  -- blink.cmp pinned to 1.* so lazy.nvim fetches the prebuilt Rust binary
  -- (no cargo needed). v2 is still landing breaking changes.
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      -- 'default' preset: <C-y> accepts, <C-n>/<C-p> cycle, <C-space> opens
      -- docs. Leaves <Tab> and <CR> alone, which keeps snippets predictable.
      keymap = {
        preset = "default",
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
      },
      appearance = { nerd_font_variant = "mono" },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        ghost_text = { enabled = false },
        menu = {
          draw = { treesitter = { "lsp" } },
        },
      },
      signature = { enabled = true },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
}
