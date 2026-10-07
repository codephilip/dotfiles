# Neovim

A 27-plugin Lua configuration for Neovim 0.11.2, built around one question: how
fast can you understand code you did not write?

## At a glance

| | |
|---|---|
| Plugins | 27 — 5 loaded at startup, 22 deferred |
| Language servers | 9, installed through Mason |
| Treesitter parsers | 37 |
| Leader | ++space++ |
| Colourscheme | Catppuccin Mocha, transparent background |
| Config root | `~/.config/nvim` |

## The design goal

Most editor configs optimise for writing. This one optimises for *reading* —
landing in an unfamiliar repository and building a mental model quickly. Three
plugins carry most of that weight:

- **`nvim-treesitter-context`** pins the enclosing function signature to the top
  of the window, so you never lose track of where you are in a long function.
- **`aerial.nvim`** gives a symbol outline of the current file — the fastest way
  to see a file's shape before reading any of it.
- **`fzf-lua`** powers both file search and every LSP result list, so "who calls
  this?" and "where is this defined?" are the same muscle memory.

## Sections

- [Architecture](architecture.md) — how the config loads, and why 27 plugins start instantly
- [Plugins](plugins.md) — the full inventory, grouped by role
- [Key bindings](keybindings.md) — everything, in tables
- [AI workflow](ai.md) — the Claude review loop

## First run

The config bootstraps itself. On first launch `lazy.nvim` clones itself, installs
every plugin, and Mason downloads the language servers.

```bash
nvim
```

To do it without opening the UI:

```bash
nvim --headless "+Lazy! sync" +qa
nvim --headless "+TSUpdateSync" +qa
```

!!! warning "Icons need a Nerd Font"
    Every glyph in the statusline, file tree and completion menu comes from a
    Nerd Font configured in your **terminal**, not in Neovim. If you see blank
    boxes, see [Terminal](../terminal.md).

## Health check

```bash
nvim --headless -c 'checkhealth' -c 'silent write! /tmp/health.txt' +qa!
```

Expected warnings: the node, perl, python3 and ruby providers are deliberately
disabled in `lua/config/options.lua` — nothing here uses them, and leaving them
on costs startup time.
