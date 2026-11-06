# Neovim config

A Lua config built for **reading and exploring code**, with Claude wired in. Writing
gets format on save, Copilot suggestions and inlay hints. Docs site:
`docs/neovim/` (`make serve`).

Leader is `<Space>`. Press `<Space>` and wait — which-key lists everything.

## Requirements

| Thing | Why | Status |
|---|---|---|
| Neovim >= 0.12 | native `vim.lsp.config` / `vim.lsp.enable`; nvim-treesitter `main` needs 0.12 | ✅ 0.12.5 |
| `tree-sitter` CLI | builds the parsers (nvim-treesitter `main`) | ✅ |
| `node` | most Mason servers and formatters, Copilot's server | ✅ |
| `ripgrep` | live grep | ✅ |
| `fd` | fast file finding | ✅ |
| `fzf` | picker backend | ✅ |
| `bat` | picker previews | ✅ |
| `lazygit` | git UI (`<leader>gg`) | ✅ |
| `claude` CLI | Claude Code integration | ✅ |
| JetBrainsMono Nerd Font | icons | ✅ (alacritty.toml updated) |
| `ANTHROPIC_API_KEY` | **CodeCompanion only** | ❌ not set — see below |
| `:Copilot auth` | Copilot, once per machine | run it once |

## Layout

```
init.lua
lua/config/     options, keymaps, autocmds, lazy bootstrap (+ :Doctor),
                theme resolution, review mode, context (copy helpers for AI)
lua/plugins/    one file per concern
  ui.lua          colorschemes, devicons, lualine, barbar, alpha, colorizer, which-key
  explore.lua     nvim-tree, oil, aerial, autopairs
  treesitter.lua  treesitter + textobjects + context
  fzf-lua.lua     every picker
  lsp.lua         mason + lspconfig + blink.cmp
  lint.lua        nvim-lint
  format.lua      conform (format on save)
  git.lua         gitsigns, gitlinker
  terminal.lua    FTerm (floating shell + lazygit)
  ai.lua          claudecode.nvim, CodeCompanion, copilot.lua
  markdown.lua    in-buffer rendering, tables, mkdocs
  review.lua      codediff, diffview + octo (PR review)
```

## Reading code — the parts that matter

| Key | Does |
|---|---|
| `<leader><leader>` / `<leader>ff` | find files |
| `<leader>/` | live grep the project |
| `<leader>sw` | grep word under cursor |
| `gd` `gr` `gy` | definition / references / type definition |
| `gI` | **the code that runs**: in TypeScript the source definition (the library's `.js`, not the `.d.ts`); elsewhere the implementations, or the definition when there are none |
| `<leader>cc` `<leader>cC` | incoming / outgoing call hierarchy |
| `<leader>o` | **symbol outline** (aerial) — get oriented in a big file |
| `gO` / `<leader>cs` | document / workspace symbols |
| `<C-space>` | grow selection by syntax node (repeat to widen) |
| `]f` `[f` `]c` `[c` | jump between functions / classes |
| `vaf` `vif` `vac` `vaa` | select a function / its body / a class / an argument |
| sticky header | treesitter-context shows the enclosing function as you scroll |
| `<leader>gb` | blame the current line (full commit) |
| `<leader>gC` | this file's commit history |
| `<leader>dv` | side-by-side diff of the working tree (codediff); again to close |
| `<leader>dh` / `<leader>dH` | diff history of this file / the repo |

`<leader>e` toggles the file tree. `-` opens the current file's directory in **oil**:
rename, delete or add lines, then `:w` applies them (renames update imports).

## Writing code

| What | How |
|---|---|
| **Format on save** | conform: oxfmt (if the project has an oxfmt / Vite+ config) or prettier for JS/TS/web, ruff for Python, stylua for Lua, the LSP for Go and Terraform. Shell only on demand, Markdown never — see `lua/plugins/format.lua` |
| Format now | `<leader>cf` (also a visual selection) |
| Format on save off for a buffer | `<leader>uf` or `:ToggleFormatter` |
| **Inlay hints** | on by default for TypeScript (vtsls), Python (basedpyright), Go and Lua. `<leader>uh` hides them |
| **Copilot** (insert) | `<C-l>` accept, `<M-l>` / `<M-L>` one word / line, `<M-]>` / `<M-[>` cycle, `<C-]>` dismiss |
| GitHub link | `<leader>gy` copies the permalink to the line / selection, `<leader>gY` opens it |

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

**`<leader>y…` — copy context** for an agent outside Neovim (another tmux pane,
a web chat): `<leader>yf` / `<leader>yp` copy the relative / absolute path with
`#L<line>`, `<leader>yc` (visual) copies the selection as a code block tagged
`filename="…" line=…`. `<leader>j` opens the project's `package.json` in a float.

**Copilot** suggests inline as you type; `<C-l>` accepts (see Writing code).

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
| `:GitLink blame` | copy the GitHub blame-page link |
| `:CodeDiff main` / `:CodeDiff pr 512` | diff against a revision / a GitHub PR |
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
| `:Mason` (`<leader>cm`) / `:MasonUpdate` | see and update the LSP servers, formatters and linters Mason installed |
| `:ConformInfo` | which formatters apply to this buffer, and their log |
| `:Copilot status` | is Copilot signed in and attached |

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

- `nvim-treesitter` and `nvim-treesitter-textobjects` → `branch = "main"`, the
  rewrite for Neovim 0.12 (`master` is frozen and breaks on 0.12).
- `blink.cmp` → `version = "1.*"` (prebuilt binary; v2 is still making breaking changes).
- `aerial.nvim` → `branch = "nvim-0.11"`. **Stale:** this machine runs 0.12, so the
  pin can go. That's the outstanding maintenance job.

codediff downloads a prebuilt diff library from its GitHub releases on first use
and after updates. Vet its updates like any plugin's.

## Notes

- **Comment.nvim was intentionally left out** — Neovim 0.10+ ships `gc`/`gcc`
  commenting natively, so it would be dead weight.
- **Formatters are auto-installed** (the `TOOLS` list in `lua/plugins/lsp.lua`,
  with Copilot's server); **linters are not**. `nvim-lint` is wired to skip any
  linter whose binary isn't on `$PATH`, so the list in `lint.lua` is safe even if
  you've installed none of them. Add the ones you want via `:Mason` (`<leader>cm`).
- TypeScript runs **vtsls** (not ts_ls) for go-to-source-definition, and Python runs
  **basedpyright** (not pyright) because pyright has no inlay hints. It is set
  to pyright's `standard` checking, so it shows no more warnings than pyright did.
- `nvim-craftzdog/` (gitignored) is the parked vim.pack rebuild that format on save,
  Copilot, codediff, gitlinker, oil and the context helpers were ported from. Run
  it with `NVIM_APPNAME=nvim-craftzdog nvim`.
- LSP servers live in the `SERVERS` list at the top of `lua/plugins/lsp.lua`. Add a
  name there (not just via `:Mason`) — the enable list is an explicit allow-list so
  that mason formatters can't get started as language servers.
