-- =========================================================
-- nvim-lint — async linters for the things LSP doesn't cover.
--
-- Linters are NOT auto-installed. nvim-lint raises an error for a missing
-- binary, so try_lint() below filters to linters that are actually on
-- $PATH — listing one you haven't installed is harmless. Install the ones
-- you want with `:Mason` (shellcheck, markdownlint, golangci-lint,
-- hadolint, yamllint…) or via brew.
-- =========================================================

return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      sh = { "shellcheck" },
      bash = { "shellcheck" },
      zsh = { "shellcheck" },
      dockerfile = { "hadolint" },
      yaml = { "yamllint" },
      markdown = { "markdownlint" },
      go = { "golangcilint" },
      terraform = { "tflint" },
    }

    -- nvim-lint raises an error for a linter whose binary is missing, so
    -- resolve each linter's command and run only the ones actually present.
    local function available_linters()
      local names = lint.linters_by_ft[vim.bo.filetype] or {}
      local found = {}
      for _, name in ipairs(names) do
        local linter = lint.linters[name]
        if type(linter) == "function" then
          linter = linter()
        end
        local cmd = type(linter) == "table" and linter.cmd or nil
        if type(cmd) == "function" then
          local ok, resolved = pcall(cmd)
          cmd = ok and resolved or nil
        end
        if cmd and vim.fn.executable(cmd) == 1 then
          found[#found + 1] = name
        end
      end
      return found
    end

    local function try_lint()
      -- Don't lint scratch/terminal/plugin UI buffers.
      if vim.bo.buftype ~= "" then
        return
      end
      local names = available_linters()
      if #names > 0 then
        lint.try_lint(names)
      end
    end

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      group = vim.api.nvim_create_augroup("phil_lint", { clear = true }),
      callback = try_lint,
    })

    vim.keymap.set("n", "<leader>cl", try_lint, { desc = "Lint buffer now" })
  end,
}
