-- =========================================================
-- PR review — diffview for reading a branch (whole or commit by commit),
-- octo for the GitHub side (inline comments, review submit).
-- gh-dash launches these; see ~/.config/gh-dash/config.yml.
-- =========================================================

-- Base for the branch being reviewed: origin's default branch, unless the
-- caller (gh-dash) passes one in REVIEW_BASE.
local function base()
  local env = vim.env.REVIEW_BASE
  if env and env ~= "" then return "origin/" .. env end
  local out = vim.fn.systemlist({ "git", "rev-parse", "--abbrev-ref", "origin/HEAD" })
  return vim.v.shell_error == 0 and out[1] or "origin/main"
end

return {
  -- codediff — VS Code-style side-by-side diff with a file tree, showing
  -- only the changes plus 8 lines of context. Quicker to skim than
  -- diffview; diffview stays for the gh-dash PR flow and merge conflicts.
  -- Downloads a prebuilt diff library on first use (`:CodeDiff install!`
  -- reinstalls it).
  {
    "esmuellert/codediff.nvim",
    cmd = "CodeDiff",
    keys = {
      {
        "<leader>dv",
        function()
          if vim.t.codediff then
            vim.cmd.tabclose()
          else
            vim.cmd("CodeDiff")
          end
        end,
        desc = "Toggle diff view (working tree)",
      },
      { "<leader>dh", "<cmd>CodeDiff history %<cr>", desc = "Diff history of this file" },
      { "<leader>dH", "<cmd>CodeDiff history<cr>", desc = "Diff history of the repo" },
    },
    opts = {
      explorer = {
        view_mode = "tree",
        width = 50,
        auto_open_on_cursor = true,
        line_stats = { enabled = true },
      },
      diff = {
        compact = true,
        compact_context_lines = 8,
        compact_sync_folds = true,
      },
    },
    config = function(_, opts)
      -- Workaround for neovim/neovim#40290: setting 'foldminlines' (which
      -- compact mode does on every file switch) refreshes treesitter folds
      -- in wiped buffers and throws "Invalid buffer id". The refresh only
      -- matters when changing 'foldminlines'/'foldnestmax', so drop it.
      -- Remove once the issue is fixed upstream.
      require("vim.treesitter._fold")
      for _, au in ipairs(vim.api.nvim_get_autocmds({ event = "OptionSet" })) do
        if au.desc == "Refresh treesitter folds" then
          vim.api.nvim_del_autocmd(au.id)
        end
      end

      require("codediff").setup(opts)

      -- Mark codediff tabs so <leader>dv closes the view instead of opening another.
      vim.api.nvim_create_autocmd("User", {
        group = vim.api.nvim_create_augroup("phil_codediff", { clear = true }),
        pattern = "CodeDiffOpen",
        callback = function(ev)
          vim.t[ev.data.tabpage].codediff = true
        end,
      })
    end,
  },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
    keys = {
      { "<leader>gv", function() vim.cmd("DiffviewOpen " .. base() .. "...HEAD") end, desc = "Review: whole branch vs base" },
      { "<leader>gm", function() vim.cmd("DiffviewFileHistory --range=" .. base() .. "..HEAD") end, desc = "Review: branch commit by commit" },
      { "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", desc = "History of this file" },
      { "<leader>gx", "<cmd>DiffviewClose<cr>", desc = "Close diffview" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = { merge_tool = { layout = "diff3_mixed" } },
      keymaps = {
        view = { { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } } },
        file_panel = { { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } } },
        file_history_panel = { { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } } },
      },
    },
  },

  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    dependencies = { "nvim-lua/plenary.nvim", "ibhagwan/fzf-lua", "nvim-tree/nvim-web-devicons" },
    keys = {
      -- <leader>r, not <leader>p: octo's own buffer keys live under
      -- <localleader>p/v/c, and localleader is <space> here too.
      { "<leader>rl", "<cmd>Octo pr list<cr>", desc = "PR: list open PRs" },
      -- gh-dash checks PRs out detached, where octo can't infer the PR from
      -- the branch; review-pr.sh passes the number in REVIEW_PR.
      { "<leader>ro", function()
        local pr = vim.env.REVIEW_PR
        if not pr or pr == "" then
          local out = vim.fn.system({ "gh", "pr", "view", "--json", "number", "-q", ".number" })
          pr = vim.v.shell_error == 0 and vim.trim(out) or nil
        end
        if pr then vim.cmd("Octo pr edit " .. pr) else vim.notify("No PR for this checkout", vim.log.levels.WARN) end
      end, desc = "PR: open this checkout's PR" },
      { "<leader>rs", "<cmd>Octo review start<cr>", desc = "PR: start review" },
      { "<leader>rr", "<cmd>Octo review resume<cr>", desc = "PR: resume pending review" },
      { "<leader>rc", "<cmd>Octo review commit<cr>", desc = "PR: review one commit" },
      { "<leader>rb", "<cmd>Octo pr browser<cr>", desc = "PR: open in browser" },
    },
    opts = {
      picker = "fzf-lua",
      enable_builtin = true,
      default_merge_method = "merge",
    },
  },
}
