-- =========================================================
-- Git — signs, hunk navigation, blame. Heavy lifting goes to lazygit.
-- =========================================================

return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      signs_staged = {
        add = { text = "┋" },
        change = { text = "┋" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "┋" },
      },
      current_line_blame_opts = { delay = 400, virt_text_pos = "eol" },
      on_attach = function(buffer)
        local gs = require("gitsigns")
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = desc })
        end

        -- Hunk navigation
        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next git hunk")

        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Prev git hunk")

        -- Staging & resetting
        map({ "n", "v" }, "<leader>gh", ":Gitsigns stage_hunk<cr>", "Stage hunk")
        map({ "n", "v" }, "<leader>gH", ":Gitsigns reset_hunk<cr>", "Reset hunk")
        map("n", "<leader>gu", gs.undo_stage_hunk, "Undo stage hunk")
        map("n", "<leader>gS", gs.stage_buffer, "Stage buffer")
        map("n", "<leader>gR", gs.reset_buffer, "Reset buffer")

        -- Inspection — this is the code-archaeology half
        map("n", "<leader>gp", gs.preview_hunk_inline, "Preview hunk inline")
        map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame line (full)")
        map("n", "<leader>gB", gs.blame, "Blame buffer")
        map("n", "<leader>gd", gs.diffthis, "Diff against index")
        map("n", "<leader>gD", function() gs.diffthis("~") end, "Diff against last commit")
        map("n", "<leader>ub", gs.toggle_current_line_blame, "Toggle inline blame")

        -- Text object: `vih` selects the hunk you're standing in
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<cr>", "Select git hunk")
      end,
    },
  },

  -- lazygit itself runs in a FTerm float — see lua/plugins/terminal.lua
  -- (<leader>gg). No extra plugin needed for it.
}
