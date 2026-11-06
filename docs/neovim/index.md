# Neovim

A 37-plugin Lua configuration for Neovim 0.12, built around one question: how
fast can you understand code you did not write? That now includes code someone
wants merged: it doubles as a [PR review](review.md) client.

## At a glance

| | |
|---|---|
| Plugins | 37, lazy-loaded by default |
| Language servers | 10, installed through Mason |
| Treesitter parsers | 34 up front, more on first use |
| Leader | ++space++ (localleader too) |
| Colourscheme | Whatever `~/.config/theme/current` names: tokyonight, solarized-osaka (its vivid variant) or catppuccin-mocha. Transparent |
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

Writing gets the basics without ceremony: format on save (`conform`), Copilot
suggestions inline, inlay hints for TypeScript, Python, Go and Lua, and `oil`
for renaming files as text.

## Sections

- [Architecture](architecture.md) — how the config loads, and why it starts instantly
- [Plugins](plugins.md) — every plugin and its keys, grouped by role
- [Key bindings](keybindings.md) — everything, by task
- [PR review](review.md) — gh-dash → diffview → octo, and review mode
- [CI and deploys](ci.md) — checks, runs, logs, the server, and rollbacks with `gh`
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
