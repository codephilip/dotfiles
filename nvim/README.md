# Neovim config

A minimal Lua config built for **reading and exploring code**, with Claude wired in.

Leader is `<Space>`. Press `<Space>` and wait — which-key lists everything.

## Requirements

| Thing | Why | Status |
|---|---|---|
| Neovim >= 0.11 | native `vim.lsp.config` / `vim.lsp.enable` | ✅ 0.11.2 |
| `ripgrep` | live grep | ✅ |
| `fd` | fast file finding | ✅ |
| `fzf` | picker backend | ✅ |
| `bat` | picker previews | ✅ |
| `lazygit` | git UI (`<leader>gg`) | ✅ |
| `claude` CLI | Claude Code integration | ✅ |
| JetBrainsMono Nerd Font | icons | ✅ (alacritty.toml updated) |
| `ANTHROPIC_API_KEY` | **CodeCompanion only** | ❌ not set — see below |

## Layout

```
init.lua
lua/config/     options, keymaps, autocmds, lazy bootstrap
lua/plugins/    one file per concern
  ui.lua          catppuccin, devicons, lualine, barbar, alpha, colorizer, which-key
  explore.lua     nvim-tree, aerial, flash, autopairs
  treesitter.lua  treesitter + textobjects + context
  fzf-lua.lua     every picker
  lsp.lua         mason + lspconfig + blink.cmp
  lint.lua        nvim-lint
  git.lua         gitsigns
  terminal.lua    FTerm (floating shell + lazygit)
  ai.lua          claudecode.nvim + CodeCompanion
```

## Reading code — the parts that matter

| Key | Does |
|---|---|
| `<leader><leader>` / `<leader>ff` | find files |
| `<leader>/` | live grep the project |
| `<leader>sw` | grep word under cursor |
| `gd` `gr` `gI` `gy` | definition / references / implementation / type def |
| `<leader>cc` `<leader>cC` | incoming / outgoing call hierarchy |
| `<leader>o` | **symbol outline** (aerial) — get oriented in a big file |
| `gO` / `<leader>cs` | document / workspace symbols |
| `<C-space>` | grow selection by syntax node (repeat to widen) |
| `]f` `[f` `]c` `[c` | jump between functions / classes |
| `vaf` `vif` `vac` `vaa` | select a function / its body / a class / an argument |
| `s` | flash jump — type 2 chars + a label to go anywhere visible |
| sticky header | treesitter-context shows the enclosing function as you scroll |
| `<leader>gb` | blame the current line (full commit) |
| `<leader>gC` | this file's commit history |

`<leader>e` toggles the file tree, `-` is unused (oil was dropped — add it back if
you miss editing directories as buffers).

## AI

Two tools, deliberately separate:

**`<leader>a…` — Claude Code** (`coder/claudecode.nvim`). Runs the `claude` CLI in a
split using the same protocol as the VS Code extension. Uses your Claude
subscription; **no API key needed.**

| Key | Does |
|---|---|
| `<leader>ac` | toggle Claude |
| `<leader>as` | (visual) send selection as context / (in tree) add file |
| `<leader>ab` | add current buffer as context |
| `<leader>ar` / `<leader>aC` | resume / continue a session |
| `<leader>aa` / `<leader>ad` | **accept / deny** a proposed diff |
| `<leader>am` | pick model |

Claude's edits open as real Neovim diffs — review them before they land.

**`<leader>n…` — CodeCompanion.** Native chat buffer + inline assistant, talking
straight to the Anthropic API. **Needs `ANTHROPIC_API_KEY` exported** (billed per
token, separate from your subscription). Without it, `<leader>nn` warns you once.
`<leader>nn` chat, `<leader>ni` inline, `<leader>na` action palette.

## Small conveniences

| Key | Does |
|---|---|
| `<leader>sR` | start a substitution (`:%s//g`, cursor between the slashes) |
| `<leader>cx` | `chmod +x` the current file |
| `<leader>cR` | re-source the current file |
| `<leader>cm` | Mason (install LSP servers / linters) |
| `gx` | open the URL under the cursor (built in) |
| `<leader>uw` / `<leader>ur` / `<leader>uc` | toggle wrap / relative number / colour swatches |

Buffers reload automatically when something changes them on disk, and you get a
notification when that happens — important because Claude Code and lazygit both
edit files outside your buffer.

Line numbers go relative while you're moving and absolute while you're typing.
Comment leaders are not continued onto new lines.

## Pinned versions — do not unpin casually

Three plugins are pinned because their default branches now require **Neovim 0.12**:

- `nvim-treesitter` → `branch = "master"` (main is a full rewrite with a different API)
- `nvim-treesitter-textobjects` → `branch = "master"`
- `aerial.nvim` → `branch = "nvim-0.11"`

`blink.cmp` is pinned to `version = "1.*"` (v2 is still making breaking changes).

When you upgrade to Neovim 0.12, **migrate** these rather than just removing the pins.

## Notes

- **Comment.nvim was intentionally left out** — Neovim 0.10+ ships `gc`/`gcc`
  commenting natively, so it would be dead weight.
- `s` is taken over by flash.nvim. Use `cl` for the old `s` behaviour.
- Formatters/linters are **not** auto-installed. `nvim-lint` is wired to skip any
  linter whose binary isn't on `$PATH`, so the list in `lint.lua` is safe even if
  you've installed none of them. Add the ones you want via `:Mason` (`<leader>cm`).
- LSP servers live in the `SERVERS` list at the top of `lua/plugins/lsp.lua`. Add a
  name there (not just via `:Mason`) — the enable list is an explicit allow-list so
  that mason formatters can't get started as language servers.
