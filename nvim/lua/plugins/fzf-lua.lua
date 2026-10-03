-- =========================================================
-- fzf-lua — the main way you'll move around a codebase
-- Uses the fzf, ripgrep, fd and bat binaries already on your PATH.
-- =========================================================

return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    { "default-title" }, -- profile: titled windows rather than inline prompts
    winopts = {
      height = 0.85,
      width = 0.85,
      preview = {
        default = "bat",
        layout = "flex", -- side-by-side when wide, stacked when narrow
        flip_columns = 160,
        scrollbar = "float",
      },
    },
    keymap = {
      builtin = {
        ["<C-/>"] = "toggle-help",
        ["<C-u>"] = "preview-page-up",
        ["<C-d>"] = "preview-page-down",
      },
      fzf = {
        ["ctrl-q"] = "select-all+accept", -- dump all matches into quickfix
        ["ctrl-u"] = "unix-line-discard",
      },
    },
    files = {
      cwd_prompt = false,
      fd_opts = [[--color=never --type f --hidden --follow --exclude .git]],
    },
    grep = {
      rg_opts = "--column --line-number --no-heading --color=always --smart-case "
        .. "--hidden --glob=!.git/ --max-columns=512",
    },
    lsp = {
      -- Jump straight there when a symbol has exactly one definition.
      jump1 = true,
      includeDeclaration = false,
      symbols = { symbol_style = 1 },
    },
  },
  keys = {
    -- Find ----------------------------------------------------------------
    { "<leader><leader>", "<cmd>FzfLua files<cr>", desc = "Find files" },
    { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find files" },
    { "<leader>fg", "<cmd>FzfLua git_files<cr>", desc = "Find git files" },
    { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent files" },
    { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Buffers" },
    { "<leader>fc", function() require("fzf-lua").files({ cwd = vim.fn.stdpath("config") }) end,
      desc = "Find in nvim config" },

    -- Search --------------------------------------------------------------
    { "<leader>/", "<cmd>FzfLua live_grep<cr>", desc = "Grep (live)" },
    { "<leader>sg", "<cmd>FzfLua live_grep<cr>", desc = "Grep (live)" },
    { "<leader>sw", "<cmd>FzfLua grep_cword<cr>", desc = "Grep word under cursor" },
    { "<leader>sw", "<cmd>FzfLua grep_visual<cr>", mode = "v", desc = "Grep selection" },
    { "<leader>sb", "<cmd>FzfLua lgrep_curbuf<cr>", desc = "Grep current buffer" },
    { "<leader>sh", "<cmd>FzfLua helptags<cr>", desc = "Help pages" },
    { "<leader>sk", "<cmd>FzfLua keymaps<cr>", desc = "Keymaps" },
    { "<leader>sm", "<cmd>FzfLua marks<cr>", desc = "Marks" },
    { "<leader>sj", "<cmd>FzfLua jumps<cr>", desc = "Jumplist" },
    { "<leader>sq", "<cmd>FzfLua quickfix<cr>", desc = "Quickfix list" },
    { "<leader>sr", "<cmd>FzfLua resume<cr>", desc = "Resume last picker" },
    { "<leader>s:", "<cmd>FzfLua command_history<cr>", desc = "Command history" },
    { "<leader>sd", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Workspace diagnostics" },

    -- Git -----------------------------------------------------------------
    { "<leader>gc", "<cmd>FzfLua git_commits<cr>", desc = "Git commits (repo)" },
    { "<leader>gC", "<cmd>FzfLua git_bcommits<cr>", desc = "Git commits (buffer)" },
    { "<leader>gs", "<cmd>FzfLua git_status<cr>", desc = "Git status" },
    -- Branch switching lives in lazygit (<leader>gg); <leader>gB is gitsigns
    -- blame-buffer. Use :FzfLua git_branches if you want the picker.
  },
  config = function(_, opts)
    local fzf = require("fzf-lua")
    fzf.setup(opts)
    -- Route vim.ui.select (code actions, etc.) through fzf.
    fzf.register_ui_select()
  end,
}
