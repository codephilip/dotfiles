# Troubleshooting

Failure modes that have actually happened in this setup, with the fix for each.

## Icons render as blank boxes

**Cause:** the terminal emulator is not using a Nerd Font.

This is almost always a case of configuring the wrong terminal. Check which one
you are actually in:

```bash
echo $TERM_PROGRAM
```

Then set the font for *that* emulator — see [Terminal](terminal.md#fonts).
Warp's default font is `Hack`, which has no Nerd Font glyphs at all.

## The prompt shows `…/.config` instead of `~/.config`

**Cause:** `truncate_to_repo = true` in `starship.toml` collapses the path to the
repository root, which hides where you actually are.

```toml
[directory]
truncate_to_repo = false
truncation_length = 4
```

## A language server crashes on every launch

```text
Client stylua quit with exit code 2 and signal 0
```

**Cause:** `mason-lspconfig` was enabling a Mason **formatter** as if it were a
language server. Mason holds formatters and linters alongside servers, and some
share a name with an `nvim-lspconfig` entry.

**Fix:** the enable list is an explicit allow-list, not `true`:

```lua
automatic_enable = SERVERS   -- not `true`
```

If you install a server with `:Mason`, add its name to `SERVERS` in
`lua/plugins/lsp.lua` too.

## nvim-lint errors about a missing binary

```text
Error running golangci-lint: ENOENT: no such file or directory
```

**Cause:** `nvim-lint` raises an error for a linter whose binary is absent — it
does not skip silently.

**Fix:** already handled. `lua/plugins/lint.lua` resolves each linter's command
and runs only those present on `$PATH`. Listing a linter you have not installed
is harmless.

## Treesitter or aerial break after an update

**Cause:** their default branches now require Neovim 0.12. This config targets
0.11.2.

```lua
{ "nvim-treesitter/nvim-treesitter", branch = "master" }
{ "stevearc/aerial.nvim", branch = "nvim-0.11" }
```

Check your version with `nvim --version`. When you move to 0.12, **migrate**
these rather than removing the pins — the treesitter `main` branch has a
completely different setup API.

## Your edits get overwritten after Claude runs

**Cause:** Claude and lazygit write to disk, not to your buffer. Editing a stale
buffer and saving clobbers their work.

**Fix:** already handled by the `checktime` autocommand in
`lua/config/autocmds.lua`. You will see *"File changed on disk — buffer
reloaded"*. If you are not seeing it, confirm `vim.opt.autoread` is on.

## `:Mason` is not a command

**Cause:** Mason loads lazily with `nvim-lspconfig` on `BufReadPre`. On the
dashboard, no buffer exists yet.

**Fix:** already handled — Mason has its own `cmd` trigger, and
++space++ ++c++ ++m++ works anywhere.

## Shell feels slow to start

Measure it:

```bash
for i in 1 2 3 4 5; do /usr/bin/time -p zsh -i -c exit; done
```

Expect ~50 ms. If it is much worse, the usual causes are a `compinit` running in
full on every start (this config caches it for 24 hours), or something slow
added to `~/.zshrc.local`.

## Syntax highlighting or autosuggestions stopped working

**Cause:** plugin load order. `zsh-syntax-highlighting` wraps every zle widget
defined before it, so it must be sourced **last**.

See [Shell → load order](shell/index.md#load-order-is-load-bearing).

## CodeCompanion requests fail

**Cause:** `ANTHROPIC_API_KEY` is not set. The chat warns once on first open.

Claude Code (++space++ ++a++ ++c++) needs no key and covers most of the same
ground — see [AI workflow](neovim/ai.md#which-to-use).

## Useful diagnostics

```bash
# Neovim health
nvim --headless -c 'checkhealth' -c 'silent write! /tmp/health.txt' +qa!

# What loaded, and how long it took
nvim  # then :Lazy, profile tab

# Reinstall everything
nvim --headless "+Lazy! sync" +qa
nvim --headless "+TSUpdateSync" +qa

# Which zsh plugins are active
zsh -i -c 'echo $functions[_zsh_highlight] $functions[_zsh_autosuggest_start]'
```
