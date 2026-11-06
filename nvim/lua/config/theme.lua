-- =========================================================
-- Theme resolution
--
-- Reads ~/.config/theme/current -- the same file zsh, ghostty and
-- delta read -- and maps the name to the plugin, colorscheme and
-- lualine theme that implement it.
--
-- Unlike the other tools, nvim does not consume the THEME_* hex
-- values. Each colorscheme plugin ships its own, far more detailed,
-- highlight definitions (treesitter captures, LSP semantic tokens,
-- diagnostics). Re-deriving those from sixteen ANSI slots would be
-- strictly worse, so here the shared file only decides *which*
-- plugin is in charge.
--
-- All three plugins are installed; only the active one is loaded
-- eagerly. Switching themes therefore needs a restart, not a
-- :Lazy sync.
-- =========================================================

local M = {}

local FALLBACK = "tokyonight"

---@type table<string, { colorscheme: string, lualine: string }>
M.themes = {
  ["tokyonight"] = {
    colorscheme = "tokyonight-night",
    lualine = "tokyonight",
  },
  ["solarized-osaka"] = {
    -- The -vivid variant, as in craftzdog's own config: the same palette
    -- with text brightened for contrast. Everything outside nvim uses
    -- the plain palette, which vivid only lightens. For the unsuffixed
    -- dark default, set this to "solarized-osaka".
    colorscheme = "solarized-osaka-vivid",
    -- The plugin ships a lightline theme but no lualine one, so let
    -- lualine derive its colours from the loaded highlight groups.
    lualine = "auto",
  },
  ["catppuccin-mocha"] = {
    colorscheme = "catppuccin-mocha",
    lualine = "catppuccin",
  },
}

local function read_current()
  local path = vim.fn.expand("~/.config/theme/current")
  local fd = io.open(path, "r")
  if not fd then
    return FALLBACK
  end

  local line = fd:read("l")
  fd:close()

  if not line then
    return FALLBACK
  end

  local name = line:gsub("%s", "")
  -- An unknown name means the file and this table have drifted. Fall
  -- back rather than letting vim.cmd.colorscheme throw at startup,
  -- which would leave the editor unusably unstyled.
  if name == "" or not M.themes[name] then
    return FALLBACK
  end

  return name
end

M.name = read_current()
M.current = M.themes[M.name]

---@param name string
---@return boolean
function M.is_active(name)
  return name == M.name
end

return M
