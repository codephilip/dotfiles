# Neovim config

A minimal Lua config built for **reading and exploring code**, with Claude wired in.

Leader is `<Space>`. Press `<Space>` and wait — which-key lists everything.

## Requirements

| Thing | Why | Status |
|---|---|---|
| Neovim >= 0.11 | native `vim.lsp.config` / `vim.lsp.enable` | ✅ 0.12.5 — see [Pinned versions](#pinned-versions--do-not-unpin-casually) |
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
lua/config/     options, keymaps, autocmds, lazy bootstrap (+ :Doctor),
                theme resolution, review mode
lua/plugins/    one file per concern
  ui.lua          colorschemes, devicons, lualine, barbar, alpha, colorizer, which-key
  explore.lua     nvim-tree, aerial, autopairs
  treesitter.lua  treesitter + textobjects + context
  fzf-lua.lua     every picker
  lsp.lua         mason + lspconfig + blink.cmp
  lint.lua        nvim-lint
  git.lua         gitsigns
  terminal.lua    FTerm (floating shell + lazygit)
  ai.lua          claudecode.nvim + CodeCompanion
  markdown.lua    in-buffer rendering, tables, mkdocs
  review.lua      diffview + octo (PR review)
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

## Maintenance

Neovim doesn't maintain itself. Plugins and language servers update upstream,
and Neovim itself moves on. Do the routine below **once a month**, and the health
check **whenever something acts strange**. Each takes a few minutes.

### Commands

| Command | Does |
|---|---|
| `:Doctor` | **health check** for the parts this config uses (lazy, LSP, Mason, treesitter). Read the ❌ ERROR lines. ⚠️ warnings about languages you don't use (PHP, Java, Julia…) are noise |
| `:checkhealth` | the full check across every plugin, for when `:Doctor` is clean but something still misbehaves |
| `:checkhealth vim.lsp` | which language servers attached to this buffer, and why not |
| `:messages` | errors that flashed past at startup |
| `:Lazy` (`<leader>L`) | plugin manager. Opening it **installs nothing**, it only shows status |
| `:Lazy check` | fetch and list available updates without applying them |
| `:Lazy log` | the commits each pending update would pull in |
| `:Lazy update` | apply the updates (rewrites `lazy-lock.json`) |
| `:Lazy restore` | **roll back** every plugin to the commits in `lazy-lock.json` |
| `:Mason` (`<leader>cm`) / `:MasonUpdate` | see and update the LSP servers and linters Mason installed |

### Monthly routine

1. **Start clean.** `cd ~/.config && git status`. Commit or stash anything
   pending, so that afterwards the lockfile diff shows only the update.
2. **Health check first.** Open `nvim` and run `:Doctor`. Fix any errors before
   updating, or you won't know whether the update caused them.
3. **See what's coming.** Run `:Lazy check`, then `:Lazy log`.
4. **Vet it** using the checklist below. This step is your malware protection.
5. **Update.** Run `:Lazy update`, then `:MasonUpdate`.
6. **Check again.** Restart nvim, run `:Doctor`, and open a few real files (TS,
   Lua, Markdown) to confirm highlighting, LSP and completion still work.
7. **Keep it or undo it.**
   - Works: `git -C ~/.config commit -am "nvim: update plugins"`. This
     commits the new `lazy-lock.json`.
   - Broken: `:Lazy restore` puts every plugin back on the committed lockfile.
     If the lockfile was already overwritten, first run
     `git -C ~/.config checkout nvim/lazy-lock.json` and then `:Lazy restore`.

`lazy-lock.json` is the safety net. It records the exact commit of every plugin,
so as long as it's committed after each good update, any bad update can be
undone in one step.

## Keeping plugins safe (supply-chain hygiene)

**The risk.** A plugin is ordinary Lua that runs with your full user
permissions. It can read `~/.ssh`, your env vars and API keys, and run any shell
command. An update pulls whatever the author last pushed to GitHub, and nothing
signs or reviews it. If a maintainer's account or repo is compromised, the next
`:Lazy update` runs the attacker's code.

**What's safe.** The "updates available" count in `:Lazy` is harmless. The
background checker only runs `git fetch`. New code runs only after you press
`U`/`S` or run `:Lazy update`.

### Before every update: vet the log

In `:Lazy log`, look at each plugin that's about to move.

- **Normal:** commit messages like `fix(hunks): …` or `feat: …`, small and
  in line with what the plugin does.
- **Look closer if you see** a huge diff from a plugin that rarely changes, a
  new or different author, vague messages ("update", "misc"), or a plugin that
  suddenly gets a burst of activity after a long silence.

To read the actual code before applying it, put the cursor on the plugin in
`:Lazy` and press **`d`**. That shows the full diff the update would apply,
including for pinned plugins.

To search a big diff for red flags, use the shell. Every plugin is a git checkout:

```sh
cd ~/.local/share/nvim/lazy/<plugin>
git log -p HEAD..origin/HEAD | grep -nE 'vim\.fn\.system|io\.popen|os\.execute|jobstart|curl|wget|base64|loadstring|\.ssh|getenv'
```

(`origin/HEAD` is the plugin's default branch, which is right for unpinned plugins.
For a branch-pinned one, use that branch instead, e.g. `origin/nvim-0.11` for aerial.)

Those calls are the red flags: running shell commands, network access,
decoding hidden strings, and reading secrets. Some plugins use them
legitimately. Lazygit's terminal runs a command, for example. So a hit means
"read it," not "it's malware." What matters is a new one appearing in a plugin
that has no reason for it.

### Habits that reduce the risk

- **Don't update on reflex.** Update on the monthly routine, or when you want a
  specific fix. Don't update because a counter says so.
- **Update a little late.** Bad releases usually get noticed and reverted within
  days. Waiting a week costs you nothing.
- **Pin what you depend on.** A `version = "1.*"` or `branch = …` pin (see
  below) means you only get releases, not every commit pushed to main.
- **Keep the plugin count low.** Each plugin is someone else's code you
  trust. Before adding one, check that Neovim doesn't already do it (see Notes),
  that it's actively maintained by someone with a track record, and that it's
  widely used.
- **Remove what you don't use.** Delete the spec, then run `:Lazy clean`.
- **Mason binaries** (LSP servers, linters) download from each language
  project's own releases. That's the same trust as `brew install`, and
  `:MasonUpdate` is covered by the same "update late" habit.

### If you think you pulled something bad

1. Quit nvim. Don't keep running it.
2. `git -C ~/.config checkout nvim/lazy-lock.json`, then start nvim and run
   `:Lazy restore` to get back to the last committed commits.
3. Delete the suspect plugin's checkout (`rm -rf ~/.local/share/nvim/lazy/<plugin>`)
   so it's re-cloned clean.
4. Treat anything nvim could reach as exposed. Rotate API keys in your env
   (`ANTHROPIC_API_KEY`, `GEMINI_API_KEY`, …) and any tokens in dotfiles, and
   check `~/.ssh` and your shell rc files for changes you didn't make.

## Pinned versions — do not unpin casually

Three plugins are pinned because their default branches now require **Neovim 0.12**:

- `nvim-treesitter` → `branch = "master"` (main is a full rewrite with a different API)
- `nvim-treesitter-textobjects` → `branch = "master"`
- `aerial.nvim` → `branch = "nvim-0.11"`

`blink.cmp` is pinned to `version = "1.*"` (v2 is still making breaking changes).

Neovim is now **0.12**, so these pins are holding plugins on old branches. **Migrate**
them (each has a 0.12 upgrade path) rather than just removing the pins. That's
the outstanding maintenance job.

## Notes

- **Comment.nvim was intentionally left out** — Neovim 0.10+ ships `gc`/`gcc`
  commenting natively, so it would be dead weight.
- Formatters/linters are **not** auto-installed. `nvim-lint` is wired to skip any
  linter whose binary isn't on `$PATH`, so the list in `lint.lua` is safe even if
  you've installed none of them. Add the ones you want via `:Mason` (`<leader>cm`).
- LSP servers live in the `SERVERS` list at the top of `lua/plugins/lsp.lua`. Add a
  name there (not just via `:Mason`) — the enable list is an explicit allow-list so
  that mason formatters can't get started as language servers.
