-- =========================================================
-- conform.nvim — format on save
--
-- Each filetype gets a dedicated formatter. Where none is listed, the
-- language server formats instead (gopls, terraformls, rust-analyzer).
-- The formatters come from Mason (see TOOLS in lua/plugins/lsp.lua).
--
-- Not formatted on save:
--   shell     shfmt would re-indent hand-aligned scripts. <leader>cf
--             still runs it on demand.
--   markdown  prettier mangles mkdocs-material `!!!` / `===` blocks,
--             so markdown has no formatter at all.
-- =========================================================

-- JS/TS projects: oxfmt when the project is set up for it (an oxfmt
-- config, or a Vite+ config that imports vite-plus), else prettier.
local OXFMT_CONFIGS = { ".oxfmtrc.json", ".oxfmtrc.jsonc", "oxfmt.config.ts" }
local VITE_CONFIGS = { "vite.config.ts", "vite.config.js" }

local function is_oxfmt_config(name, path)
  if vim.list_contains(OXFMT_CONFIGS, name) then
    return true
  end
  if not vim.list_contains(VITE_CONFIGS, name) then
    return false
  end
  local file = io.open(vim.fs.joinpath(path, name))
  if not file then
    return false
  end
  local text = file:read("*a")
  file:close()
  return text:find("vite-plus", 1, true) ~= nil
end

local web = { "oxfmt", "prettierd", "prettier", stop_after_first = true }

local NO_FORMAT_ON_SAVE = { sh = true, bash = true, zsh = true }

local function toggle_format_on_save()
  vim.b.disable_autoformat = not vim.b.disable_autoformat
  vim.notify(
    "Format on save " .. (vim.b.disable_autoformat and "off" or "on") .. " for this buffer",
    vim.b.disable_autoformat and vim.log.levels.WARN or vim.log.levels.INFO
  )
end

return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = "ConformInfo",
  keys = {
    { "<leader>cf", function() require("conform").format() end, mode = { "n", "v" }, desc = "Format buffer / selection" },
    { "<leader>uf", toggle_format_on_save, desc = "Toggle format on save (buffer)" },
  },
  init = function()
    vim.api.nvim_create_user_command("ToggleFormatter", toggle_format_on_save,
      { desc = "Toggle format on save for the current buffer" })
  end,
  opts = {
    default_format_opts = { lsp_format = "fallback" },
    formatters_by_ft = {
      javascript = web,
      typescript = web,
      javascriptreact = web,
      typescriptreact = web,
      json = web,
      jsonc = web,
      css = web,
      scss = web,
      less = web,
      html = web,
      yaml = web,
      graphql = web,
      python = { "ruff_organize_imports", "ruff_format" },
      lua = { "stylua" },
      sh = { "shfmt" },
      bash = { "shfmt" },
    },
    formatters = {
      oxfmt = {
        condition = function(_, ctx)
          return vim.fs.root(ctx.buf, is_oxfmt_config) ~= nil
        end,
      },
      -- Two-space indent and indented `case` branches, like the scripts here.
      shfmt = { prepend_args = { "-i", "2", "-ci" } },
    },
    format_on_save = function(buf)
      if vim.b[buf].disable_autoformat or NO_FORMAT_ON_SAVE[vim.bo[buf].filetype] then
        return
      end
      return { timeout_ms = 1000 }
    end,
  },
}
