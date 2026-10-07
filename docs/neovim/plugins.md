# Plugins

All 27, grouped by what they are for. Versions are pinned in `lazy-lock.json`.

## Reading and navigation

The reason the config exists.

| Plugin | What it does | Key |
|---|---|---|
| [`fzf-lua`](https://github.com/ibhagwan/fzf-lua) | Every picker: files, live grep, buffers, git, and all LSP result lists. Wraps the `fzf` binary, so it stays fast on large repos. | ++space++ ++f++ ++f++ |
| [`nvim-treesitter`](https://github.com/nvim-treesitter/nvim-treesitter) | Parses the buffer into a syntax tree on every keystroke. Drives highlighting, indentation and folding. | ++ctrl+space++ |
| [`nvim-treesitter-textobjects`](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) | Makes functions, classes and arguments selectable and jumpable. | `vaf` `]f` |
| [`nvim-treesitter-context`](https://github.com/nvim-treesitter/nvim-treesitter-context) | Pins the enclosing function signature to the top of the window while you scroll. | `[x` |
| [`aerial.nvim`](https://github.com/stevearc/aerial.nvim) | Symbol outline sidebar. Fastest way to get oriented in a long file. | ++space++ ++o++ |
| [`nvim-tree.lua`](https://github.com/nvim-tree/nvim-tree.lua) | Project file tree with git status and diagnostics per file. | ++space++ ++e++ |
| [`flash.nvim`](https://github.com/folke/flash.nvim) | Type two characters plus a label to jump anywhere visible. | ++s++ |

!!! note "`nvim-treesitter-context` is the sleeper"
    It looks like decoration. In practice it is the single highest-value plugin
    here — scrolling through a 300-line function without losing the signature
    changes how fast you can read.

## Code intelligence

| Plugin | What it does | Key |
|---|---|---|
| [`nvim-lspconfig`](https://github.com/neovim/nvim-lspconfig) | Server definitions consumed by Neovim 0.11's native `vim.lsp.config` / `vim.lsp.enable`. | `gd` `gr` |
| [`mason.nvim`](https://github.com/mason-org/mason.nvim) | Installs servers, linters and formatters without touching system package managers. | ++space++ ++c++ ++m++ |
| [`mason-lspconfig.nvim`](https://github.com/mason-org/mason-lspconfig.nvim) | Bridges the two — installs the `SERVERS` list and enables exactly those. | — |
| [`blink.cmp`](https://github.com/Saghen/blink.cmp) | Completion menu with a Rust fuzzy matcher. Pinned to v1. | ++ctrl+y++ |
| [`friendly-snippets`](https://github.com/rafamadriz/friendly-snippets) | Snippet corpus feeding blink's snippet source. | ++tab++ |
| [`nvim-lint`](https://github.com/mfussenegger/nvim-lint) | Async linters on write, filtered to those actually installed. | ++space++ ++c++ ++l++ |

### Language servers

`lua_ls` · `gopls` · `ts_ls` · `pyright` · `bashls` · `jsonls` · `yamlls` ·
`terraformls` · `dockerls` · `marksman`

!!! tip "`marksman` is what makes this repo's docs navigable"
    It is the markdown server: completion for `[](relative/path)` links and
    `#heading` anchors, `gd` to follow a link to the file it points at, and
    `gO` for a heading outline. With 20 cross-linked files under `docs/`,
    that is the difference between editing markdown and editing a site.

### Linters

Declared in `lua/plugins/lint.lua` but **not** auto-installed. The config filters
to linters present on `$PATH`, so listing one you have not installed is harmless.

| Filetype | Linter | Install |
|---|---|---|
| sh, bash, zsh | `shellcheck` | `brew install shellcheck` |
| dockerfile | `hadolint` | `brew install hadolint` |
| yaml | `yamllint` | `brew install yamllint` |
| markdown | `markdownlint` | installed ✓ — tuned by `.markdownlint.json` |
| go | `golangci-lint` | `brew install golangci-lint` |
| terraform | `tflint` | `brew install tflint` |

## AI

| Plugin | What it does | Key |
|---|---|---|
| [`claudecode.nvim`](https://github.com/coder/claudecode.nvim) | Runs the Claude CLI in a split using the same protocol as the VS Code extension. Sends selections as context; returns edits as reviewable diffs. Uses your subscription — no API key. | ++space++ ++a++ ++c++ |
| [`codecompanion.nvim`](https://github.com/olimorris/codecompanion.nvim) | Native chat buffer and inline assistant against the Anthropic API. Requires `ANTHROPIC_API_KEY`; billed per token. | ++space++ ++n++ ++n++ |

See [AI workflow](ai.md) for how they differ in practice.

## Git and terminal

| Plugin | What it does | Key |
|---|---|---|
| [`gitsigns.nvim`](https://github.com/lewis6991/gitsigns.nvim) | Gutter signs, hunk staging and reset, inline blame, hunk text object. | `]h` ++space++ ++g++ ++b++ |
| [`FTerm.nvim`](https://github.com/numToStr/FTerm.nvim) | Floating terminal. Also hosts lazygit, removing the need for a separate git-UI plugin. | ++ctrl+backslash++ |

## Interface

| Plugin | What it does | Key |
|---|---|---|
| [`catppuccin`](https://github.com/catppuccin/nvim) | Mocha flavour, transparent background so the terminal shows through. | — |
| [`lualine.nvim`](https://github.com/nvim-lualine/lualine.nvim) | Statusline: mode, branch, diagnostics, relative path, attached LSP servers. | — |
| [`barbar.nvim`](https://github.com/romgrk/barbar.nvim) | Buffer tabs with pinning, reordering and jump-by-letter. | ++shift+h++ ++shift+l++ |
| [`which-key.nvim`](https://github.com/folke/which-key.nvim) | Press leader and pause — every binding appears, grouped. | ++space++ |
| [`alpha-nvim`](https://github.com/goolord/alpha-nvim) | Start screen with routes into files, grep, tree, lazygit and Claude. | — |
| [`nvim-colorizer.lua`](https://github.com/catgoose/nvim-colorizer.lua) | Renders hex and rgb values as swatches inline. Maintained fork. | ++space++ ++u++ ++c++ |
| [`nvim-web-devicons`](https://github.com/nvim-tree/nvim-web-devicons) | Filetype glyphs. Requires a Nerd Font. | — |
| [`nvim-autopairs`](https://github.com/windwp/nvim-autopairs) | Closes brackets and quotes, treesitter-aware. | — |
| [`lazy.nvim`](https://github.com/folke/lazy.nvim) | Plugin manager. Owns the lockfile and the deferred-loading model. | ++space++ ++shift+l++ |
| [`plenary.nvim`](https://github.com/nvim-lua/plenary.nvim) | Shared Lua utility library. A dependency, never used directly. | — |

## Markdown

`lua/plugins/markdown.lua`. This repo is markdown-heavy — 20 files, a
mkdocs-material site, the cheatsheets, `README.md` — so the setup is built
around editing a documentation site, not around note-taking.

| Plugin | Role |
|---|---|
| `render-markdown.nvim` | draws headings, code blocks, tables, bullets, checkboxes and links as styled text **in the buffer** |
| `vim-table-mode` | typing <code>&#124;</code> re-aligns the whole table as you go |
| `marksman` (LSP) | link/heading completion, follow links, heading outline |
| `markdownlint` | lint, tuned by `.markdownlint.json` at the repo root |

Rendering only applies in normal mode (`render_modes = { "n", "c", "t" }`),
and anti-conceal un-renders the line under the cursor — so you always edit
real source and only ever *read* the pretty version. It also renders
`codecompanion` chat buffers, which makes AI replies far easier to skim.

### No browser preview, on purpose

`markdown-preview.nvim` and friends render **GitHub** markdown. `docs/` is
mkdocs-material: `!!! tip` admonitions, `=== "Tab"` content tabs, the
Material theme. A browser preview would show those as literal text — wrong
in exactly the places it matters.

So: render in-buffer while editing, and use the real thing for the real
thing. ++space++ ++m++ ++p++ runs `mkdocs serve` from the nearest
`mkdocs.yml` and opens the browser; press it again to stop the server.

### mkdocs-material syntax highlighting

`render-markdown` understands GitHub callouts (`> [!NOTE]`) but has no
concept of Material's `!!!` admonitions or `===` tabs — to treesitter they
are ordinary paragraph text, so they would sit in the buffer looking like
body copy. There are 19 admonitions across `docs/`.

`markdown.lua` adds two `matchadd()` patterns for them, linked to `Special`
and `Identifier` so they follow whichever [theme](../theming.md) is active,
and re-applied on `ColorScheme` because loading a colorscheme clears every
highlight.

!!! warning "One thing this cannot fix"
    Admonition *bodies* are indented four spaces, which CommonMark treats as
    an indented code block. Treesitter therefore highlights them as code,
    and `markdownlint` had to have `MD032`/`MD022`/`MD046` disabled for the
    same reason. Nothing short of a Material-aware parser solves it.

## Deliberately absent

| Not installed | Why |
|---|---|
| `Comment.nvim` | Neovim 0.10+ ships `gc` / `gcc` natively |
| `oil.nvim` | `nvim-tree` covers the explorer role; two is not minimal |
| `trouble.nvim` | `fzf-lua` + quickfix cover diagnostics and references |
| `lazygit.nvim` | FTerm hosts lazygit in a float for free |
| a formatter | **gap** — `<leader>cf` uses LSP formatting, weak for JS/TS/Python |

!!! tip "Closing the formatter gap"
    `conform.nvim` wired to `prettier`, `ruff` and `gofumpt` is the usual answer.
    Not installed yet.

## Version pins

Four plugins are pinned. These are not arbitrary — unpinning them on Neovim
0.11.2 breaks the editor at launch.

| Plugin | Pin | Reason |
|---|---|---|
| `nvim-treesitter` | `branch = "master"` | `main` is a full rewrite requiring Neovim 0.12 |
| `nvim-treesitter-textobjects` | `branch = "master"` | same rewrite |
| `aerial.nvim` | `branch = "nvim-0.11"` | maintained compatibility branch |
| `blink.cmp` | `version = "1.*"` | v2 is still landing breaking changes |

When you move to Neovim 0.12, **migrate** these rather than simply removing the
pins. The treesitter `main` branch has a completely different setup API.
