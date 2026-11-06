-- =========================================================
-- FTerm — floating terminals. One generic shell, plus dedicated
-- floats for lazygit and btop-style one-offs. Avoids needing a
-- separate lazygit plugin.
-- =========================================================

return {
  "numToStr/FTerm.nvim",
  cmd = { "FTermToggle", "Lazygit" },
  keys = {
    { "<C-\\>", "<cmd>FTermToggle<cr>", mode = { "n", "t" }, desc = "Floating terminal" },
    { "<leader>gg", "<cmd>Lazygit<cr>", desc = "Lazygit" },
  },
  config = function()
    local fterm = require("FTerm")

    local border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
    local dimensions = { height = 0.9, width = 0.9, x = 0.5, y = 0.5 }

    fterm.setup({
      border = border,
      dimensions = dimensions,
      blend = 0,
      hl = "Normal",
    })

    -- Generic shell toggle.
    vim.api.nvim_create_user_command("FTermToggle", function()
      fterm.toggle()
    end, { desc = "Toggle floating terminal" })

    -- Dedicated lazygit float. Reuses the same window each time.
    local lazygit = fterm:new({
      ft = "fterm_lazygit",
      cmd = "lazygit",
      border = border,
      dimensions = dimensions,
      hl = "Normal",
      -- Refresh gitsigns once lazygit exits, so the gutter matches reality.
      on_exit = function()
        pcall(function() require("gitsigns").refresh() end)
      end,
    })

    vim.api.nvim_create_user_command("Lazygit", function()
      lazygit:toggle()
    end, { desc = "Toggle lazygit in a floating terminal" })
  end,
}
