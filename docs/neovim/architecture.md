# Architecture

## Startup path

Four plain Lua modules run in a fixed order, then `lazy.nvim` imports one file per
concern from `lua/plugins/`.

<div class="dg">
  <div class="dg-cap">init.lua to first keystroke</div>
  <div class="dg-flow">
    <div class="dg-node"><b>options</b><span>Leader, UI, folding, diagnostics</span></div>
    <div class="dg-arrow">→</div>
    <div class="dg-node"><b>keymaps</b><span>Bindings needing no plugin</span></div>
    <div class="dg-arrow">→</div>
    <div class="dg-node"><b>autocmds</b><span>Yank highlight, cursor restore, disk reload</span></div>
    <div class="dg-arrow">→</div>
    <div class="dg-node"><b>lazy</b><span>Bootstrap, then import plugins/</span></div>
  </div>
</div>

The order is not cosmetic. `options.lua` sets `vim.g.mapleader` before anything
else, because every mapping defined later bakes the leader key in at definition
time — set it late and half your bindings land on the wrong key.

## File layout

```text
~/.config/nvim
├── init.lua                4 requires, nothing else
├── lazy-lock.json          pinned commits — commit this
├── README.md
└── lua/
    ├── config/
    │   ├── options.lua     leader, UI, folding, diagnostics, providers
    │   ├── keymaps.lua     bindings that need no plugin
    │   ├── autocmds.lua    yank highlight, cursor restore, disk reload
    │   └── lazy.lua        bootstrap + plugin import
    └── plugins/
        ├── ui.lua          theme, statusline, tabs, dashboard, which-key
        ├── explore.lua     file tree, outline, motion, pairs
        ├── treesitter.lua  syntax, textobjects, sticky context
        ├── fzf-lua.lua     every picker
        ├── lsp.lua         mason + lspconfig + blink.cmp
        ├── lint.lua        nvim-lint
        ├── git.lua         gitsigns
        ├── terminal.lua    FTerm float + lazygit
        └── ai.lua          claudecode + codecompanion
```

Each file in `plugins/` returns a table of plugin specs. Adding a plugin means
adding to the right file — there is no central registry to update.

## The load model

Only **five** plugins load when Neovim opens:

| Plugin | Why eager |
|---|---|
| `lazy.nvim` | the manager itself |
| `catppuccin` | a colourscheme applied late causes a visible flash |
| `nvim-treesitter` | does not support lazy-loading |
| `nvim-tree.lua` | so `nvim some/dir/` opens the tree |
| `nvim-web-devicons` | needed by whatever draws first |

The other 22 wait for a trigger:

=== "keys"

    A mapping is registered as a stub. Press it once and the real plugin loads,
    then the key fires. This is how `fzf-lua`, `aerial`, `flash` and both AI
    tools stay out of startup entirely.

    ```lua
    keys = {
      { "<leader>o", "<cmd>AerialToggle<cr>", desc = "Symbol outline" },
    }
    ```

=== "cmd"

    A command name is reserved. Typing `:Mason` pulls the plugin in on first use.

    ```lua
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    ```

=== "event"

    `BufReadPre` for LSP and gitsigns, `InsertEnter` for completion and
    autopairs — nothing loads before a real buffer exists.

    ```lua
    event = { "BufReadPre", "BufNewFile" },
    ```

=== "VeryLazy"

    Fires after the first screen is painted. Statusline, bufferline and
    which-key appear a few milliseconds late and nobody notices.

    ```lua
    event = "VeryLazy",
    ```

Check what actually loaded with `:Lazy` — the profile tab shows load time per
plugin.

## Code intelligence

Four systems are frequently confused. They solve different problems and run
independently: treesitter works with no language server attached, and the
language server works with no parser installed.

<div class="dg">
  <div class="dg-cap">Four systems, one buffer</div>
  <div class="dg-stack">
    <div class="dg-layer" style="--nc:var(--tn-green)">
      <b>Treesitter</b>
      <span>Structure of <em>this file</em>. Highlighting, folding, sticky context,
      and the <code>vaf</code> / <code>]f</code> syntax motions. Instant, local, no network.</span>
    </div>
    <div class="dg-layer" style="--nc:var(--md-primary-fg-color)">
      <b>LSP</b>
      <span>Meaning <em>across the project</em>. Definitions, references, rename,
      diagnostics, call hierarchy — anything needing knowledge of other files.</span>
    </div>
    <div class="dg-layer" style="--nc:var(--tn-magenta)">
      <b>blink.cmp</b>
      <span>Presentation only. Merges LSP, snippets, buffer words and paths into
      one ranked menu. Owns no knowledge of its own.</span>
    </div>
    <div class="dg-layer" style="--nc:var(--tn-yellow)">
      <b>nvim-lint</b>
      <span>Opinions the server does not hold. Standalone linters on write,
      skipped silently when the binary is absent.</span>
    </div>
  </div>
</div>

| Layer | Scope | Provides |
|---|---|---|
| Treesitter | this buffer | highlighting, folding, sticky context, syntax motions |
| LSP | whole project | definitions, references, rename, diagnostics, call hierarchy |
| blink.cmp | presentation | merges LSP + snippets + buffer + path into one menu |
| nvim-lint | this buffer | shellcheck, hadolint, golangci-lint on write |

### How servers get enabled

`mason` downloads binaries. `mason-lspconfig` enables them. The enable list is an
explicit allow-list in `lua/plugins/lsp.lua`:

```lua
local SERVERS = {
  "lua_ls", "gopls", "ts_ls", "pyright", "bashls",
  "jsonls", "yamlls", "terraformls", "dockerls",
}
```

!!! danger "Do not set `automatic_enable = true`"
    Mason also holds formatters and linters. Some share a name with an
    `nvim-lspconfig` entry — `stylua` is one — and get started as a language
    server, then crash on every launch. The allow-list prevents this. If you add
    a server with `:Mason`, add its name to `SERVERS` too.

## Adding a plugin

1. Pick the file in `lua/plugins/` that matches its role.
2. Add the spec with a lazy trigger — `keys`, `cmd` or `event`. Avoid `lazy = false`.
3. Give every mapping a `desc`; which-key reads it.
4. Run `:Lazy sync`.
5. Commit `lazy-lock.json`.
