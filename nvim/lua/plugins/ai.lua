-- =========================================================
-- AI tooling
--
-- Two complementary tools:
--
--   claudecode.nvim  — runs the Claude Code CLI in a split and speaks the
--                      same protocol as the official VS Code extension.
--                      Your selection / buffer becomes @-context, and the
--                      edits Claude proposes open as real Neovim diffs you
--                      accept or deny. Uses your Claude subscription via
--                      the `claude` binary; no API key needed.
--                      Everything under <leader>a.
--
--   CodeCompanion    — a native chat buffer and inline assistant talking
--                      straight to the Anthropic API. Good for questions
--                      that don't need to touch files.
--                      REQUIRES: export ANTHROPIC_API_KEY=...  (billed
--                      per token, separate from your subscription).
--                      Everything under <leader>n.
--
--   copilot.lua      — inline ghost-text suggestions while typing. Keys
--                      are insert-mode only (below). Run `:Copilot auth`
--                      once per machine; the login lives in
--                      ~/.config/github-copilot (gitignored).
-- =========================================================

-- Mason's copilot-language-server (lua/plugins/lsp.lua TOOLS). Without it
-- copilot.lua downloads a server of its own.
local copilot_server = vim.fn.stdpath("data") .. "/mason/bin/copilot-language-server"

return {
  -- Copilot ---------------------------------------------------------------
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        auto_trigger = true,
        -- Mapped in config below, so <C-]> can fall back to its built-in job.
        keymap = {
          accept = false,
          accept_word = false,
          accept_line = false,
          next = false,
          prev = false,
          dismiss = false,
        },
      },
      -- Copilot's default list turns these off; notes and docs benefit too.
      filetypes = { markdown = true, help = true },
    },
    config = function(_, opts)
      if vim.fn.executable(copilot_server) == 1 then
        opts.server = { type = "binary", custom_server_filepath = copilot_server }
      end
      require("copilot").setup(opts)

      local suggestion = require("copilot.suggestion")
      local function map(lhs, fn, desc)
        vim.keymap.set("i", lhs, fn, { desc = "Copilot: " .. desc })
      end
      -- On macOS the <M-…> keys need the terminal's Option-as-Alt.
      map("<C-l>", suggestion.accept, "accept")
      map("<M-l>", suggestion.accept_word, "accept word")
      map("<M-L>", suggestion.accept_line, "accept line")
      map("<M-]>", suggestion.next, "next suggestion")
      map("<M-[>", suggestion.prev, "previous suggestion")
      map("<C-]>", function()
        if suggestion.is_visible() then
          suggestion.dismiss()
        else
          -- nothing showing: keep <C-]>'s built-in meaning (expand abbreviation)
          vim.api.nvim_feedkeys(vim.keycode("<C-]>"), "n", false)
        end
      end, "dismiss")
    end,
  },

  -- Claude Code -----------------------------------------------------------
  {
    "coder/claudecode.nvim",
    -- Terminal provider is "native", so folke/snacks.nvim is not required.
    opts = {
      terminal_cmd = "claude",
      auto_start = true,       -- start the WebSocket server on load
      track_selection = true,  -- keep Claude aware of your current selection
      focus_after_send = false, -- stay in your buffer after sending context
      terminal = {
        provider = "native",
        split_side = "right",
        split_width_percentage = 0.40,
        auto_close = true,
      },
      diff_opts = {
        vertical_split = true,
        open_in_current_tab = true,
      },
    },
    cmd = {
      "ClaudeCode",
      "ClaudeCodeFocus",
      "ClaudeCodeSelectModel",
      "ClaudeCodeAdd",
      "ClaudeCodeSend",
      "ClaudeCodeTreeAdd",
      "ClaudeCodeStatus",
      "ClaudeCodeStart",
      "ClaudeCodeStop",
      "ClaudeCodeOpen",
      "ClaudeCodeClose",
      "ClaudeCodeDiffAccept",
      "ClaudeCodeDiffDeny",
      "ClaudeCodeCloseAllDiffs",
    },
    keys = {
      { "<leader>a", nil, desc = "ai (claude)" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume session" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue last session" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer as context" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection" },
      -- Inside nvim-tree, <leader>as adds the file under the cursor instead.
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        ft = { "NvimTree" },
        desc = "Add file under cursor",
      },
      -- Diff review
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
      { "<leader>aq", "<cmd>ClaudeCodeCloseAllDiffs<cr>", desc = "Close all diffs" },
      { "<leader>a?", "<cmd>ClaudeCodeStatus<cr>", desc = "Connection status" },
    },
  },

  -- CodeCompanion ---------------------------------------------------------
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions", "CodeCompanionCmd" },
    opts = {
      adapters = {
        anthropic = function()
          return require("codecompanion.adapters").extend("anthropic", {
            env = { api_key = "ANTHROPIC_API_KEY" },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = "anthropic",
          keymaps = {
            send = { modes = { n = "<CR>", i = "<C-s>" } },
            close = { modes = { n = "q", i = "<C-c>" } },
          },
        },
        inline = { adapter = "anthropic" },
        cmd = { adapter = "anthropic" },
      },
      display = {
        chat = {
          window = { layout = "vertical", width = 0.40 },
          show_settings = false,
        },
        -- Review inline suggestions as a diff before they land.
        diff = { enabled = true, provider = "default" },
      },
      opts = { log_level = "ERROR" },
    },
    keys = {
      { "<leader>n", nil, desc = "ai chat (codecompanion)" },
      { "<leader>nn", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Toggle chat" },
      { "<leader>na", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "Action palette" },
      { "<leader>ni", "<cmd>CodeCompanion<cr>", mode = { "n", "v" }, desc = "Inline assistant" },
      { "<leader>nd", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add selection to chat" },
      { "<leader>nc", "<cmd>CodeCompanionCmd<cr>", desc = "Generate a :command" },
    },
    init = function()
      -- Warn once, lazily, instead of failing mysteriously mid-request.
      vim.api.nvim_create_autocmd("User", {
        pattern = "CodeCompanionChatOpened",
        once = true,
        callback = function()
          if not os.getenv("ANTHROPIC_API_KEY") then
            vim.notify(
              "ANTHROPIC_API_KEY is not set — CodeCompanion requests will fail.\n"
                .. "Use <leader>ac (Claude Code) instead, or export the key in your shell.",
              vim.log.levels.WARN,
              { title = "CodeCompanion" }
            )
          end
        end,
      })
    end,
  },
}
