-- =========================================================
-- lazy.nvim bootstrap
-- =========================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", repo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  defaults = { lazy = true },
  install = { colorscheme = { "tokyonight-night", "habamax" } },
  checker = { enabled = true, notify = false }, -- check for updates quietly
  change_detection = { notify = false },
  ui = { border = "rounded" },
  performance = {
    rtp = {
      -- Disable built-in plugins we don't use; oil.nvim replaces netrw.
      disabled_plugins = {
        "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin",
        "netrwPlugin", "rplugin", "matchit",
      },
    },
  },
})

vim.keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy (plugin manager)" })
