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
  -- vtsls: TypeScript/JavaScript. Same tsserver underneath as ts_ls, plus
  -- "go to source definition" (gI) and the workspace's own TypeScript.
  "vtsls",
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

-- gI: go to the code that actually runs.
--   TypeScript: definition jumps to the .d.ts type declaration for any
--   library, so ask vtsls for the source definition instead.
--   Elsewhere: implementations (a Go interface's or Rust trait's
--   implementers), or plain definition where the server has no
--   implementation support (pyright, for one).
local function goto_source()
  local fzf = require("fzf-lua")
  local vtsls = vim.lsp.get_clients({ bufnr = 0, name = "vtsls" })[1]
  if not vtsls then
    if #vim.lsp.get_clients({ bufnr = 0, method = "textDocument/implementation" }) > 0 then
      return fzf.lsp_implementations()
    end
    return fzf.lsp_definitions()
  end

  local params = vim.lsp.util.make_position_params(0, vtsls.offset_encoding)
  vtsls:request("workspace/executeCommand", {
    command = "typescript.goToSourceDefinition",
    arguments = { params.textDocument.uri, params.position },
  }, function(err, result)
    if err then
      vim.notify("Source definition: " .. err.message, vim.log.levels.ERROR)
    elseif not result or #result == 0 then
      vim.notify("No source definition found", vim.log.levels.INFO)
    elseif #result == 1 then
      vim.lsp.util.show_document(result[1], vtsls.offset_encoding, { focus = true })
    else
      vim.fn.setqflist({}, " ", {
        title = "Source definitions",
        items = vim.lsp.util.locations_to_items(result, vtsls.offset_encoding),
      })
      fzf.quickfix()
    end
  end, 0)
end

-- Non-server tools Mason installs on start: the formatters conform.nvim
-- runs (lua/plugins/format.lua) and Copilot's server (lua/plugins/ai.lua).
-- Already-installed ones are skipped.
local TOOLS = {
  "copilot-language-server",
  "oxfmt",
  "prettierd",
  "prettier",
  "ruff",
  "stylua",
  "shfmt",
}

local function ensure_tools()
  local registry = require("mason-registry")
  registry.refresh(function()
    for _, name in ipairs(TOOLS) do
      local ok, pkg = pcall(registry.get_package, name)
      if ok and not pkg:is_installed() then
        vim.notify("Mason: installing " .. name)
        pkg:install()
      end
    end
  end)
end

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
        config = function(_, opts)
          require("mason").setup(opts)
          ensure_tools()
        end,
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
      -- Advertise blink.cmp's extra completion capabilities to every server,
      -- plus file-rename support so oil renames update imports.
      local ok, blink = pcall(require, "blink.cmp")
      if ok then
        vim.lsp.config("*", {
          capabilities = blink.get_lsp_capabilities({
            workspace = { fileOperations = { didRename = true, willRename = true } },
          }, true),
        })
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

      vim.lsp.config("vtsls", {
        settings = {
          vtsls = {
            autoUseWorkspaceTsdk = true, -- the project's own typescript, not the bundled one
            enableMoveToFileCodeAction = true,
            experimental = { completion = { enableServerSideFuzzyMatch = true } },
          },
          typescript = {
            updateImportsOnFileMove = { enabled = "always" },
          },
          javascript = {
            updateImportsOnFileMove = { enabled = "always" },
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
          map("gI", goto_source, "Goto source (TS) / implementation")
          map("gy", fzf.lsp_typedefs, "Goto type definition")
          map("gO", fzf.lsp_document_symbols, "Document symbols")
          map("<leader>cs", fzf.lsp_live_workspace_symbols, "Workspace symbols")
          map("<leader>cc", fzf.lsp_incoming_calls, "Incoming calls")
          map("<leader>cC", fzf.lsp_outgoing_calls, "Outgoing calls")

          -- Actions.
          map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action", { "n", "v" })
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
