# Plugins

All 37, one at a time: what each is for, where it is configured, and the keys
that drive it. Versions are pinned in `nvim/lazy-lock.json`.

For the same bindings sorted by *task* rather than by plugin, see
[Key bindings](keybindings.md). For how the review plugins fit together, see
[PR review](review.md).

## At a glance

| Area | Plugins | Spec file |
|---|---|---|
| Finding and navigating | fzf-lua, nvim-tree, oil, aerial | `fzf-lua.lua`, `explore.lua` |
| Syntax | nvim-treesitter, -textobjects, -context | `treesitter.lua` |
| Code intelligence | nvim-lspconfig, mason, mason-lspconfig, blink.cmp, friendly-snippets, nvim-lint, conform | `lsp.lua`, `lint.lua`, `format.lua` |
| Git | gitsigns, gitlinker, FTerm (hosts lazygit) | `git.lua`, `terminal.lua` |
| PR review and diffs | codediff, diffview, octo | `review.lua` (+ `config/review.lua`) |
| AI | claudecode, codecompanion, copilot (+ the context helpers) | `ai.lua` (+ `config/context.lua`) |
| Markdown | render-markdown, vim-table-mode | `markdown.lua` |
| Interface | tokyonight, solarized-osaka, catppuccin, lualine, barbar, alpha, which-key, nvim-colorizer, nvim-web-devicons | `ui.lua` |
| Editing | nvim-autopairs | `explore.lua` |
| Plumbing | lazy.nvim, plenary | `config/lazy.lua` |

All spec files live in `nvim/lua/plugins/` unless prefixed `config/`.

!!! tip "Leader and localleader are both ++space++"
    That is why some plugin-window keys below look like they collide with
    global ones. Plugin buffers (octo, diffview, nvim-tree) set *buffer-local*
    maps, and buffer-local always wins. The collisions that actually bite are
    listed in [Known clashes](#known-clashes).

---

## Finding and navigating

### fzf-lua

[`ibhagwan/fzf-lua`](https://github.com/ibhagwan/fzf-lua) handles every picker
in the config: files, grep, buffers, git, and all LSP result lists. It also
takes over `vim.ui.select`, so code actions open in fzf too. Previews go
through `bat`.

| Keys | Does |
|---|---|
| ++space++ ++space++ / ++space++ ++f++ ++f++ | Find files (hidden included, `.git` excluded) |
| ++space++ ++f++ ++g++ | Git-tracked files |
| ++space++ ++f++ ++r++ | Recent files |
| ++space++ ++f++ ++b++ | Buffers |
| ++space++ ++f++ ++c++ | Files in the nvim config |
| ++space++ ++slash++ / ++space++ ++s++ ++g++ | Live grep |
| ++space++ ++s++ ++w++ | Grep word under cursor (visual: the selection) |
| ++space++ ++s++ ++b++ | Grep current buffer |
| ++space++ ++s++ ++h++ / ++k++ / ++m++ / ++j++ | Help / keymaps / marks / jumplist |
| ++space++ ++s++ ++q++ | Quickfix list |
| ++space++ ++s++ ++d++ | Workspace diagnostics |
| ++space++ ++s++ `:` | Command history |
| ++space++ ++s++ ++r++ | Resume the last picker, with its query |
| ++space++ ++g++ ++c++ / ++shift+c++ | Commits: repo / this buffer |
| ++space++ ++g++ ++s++ | Git status |

Inside a picker: ++ctrl+j++ / ++ctrl+k++ move, ++tab++ marks, ++ctrl+q++
sends everything to quickfix, ++shift+down++ / ++shift+up++ scroll the
preview, ++ctrl+slash++ shows help.

### nvim-tree.lua

[`nvim-tree/nvim-tree.lua`](https://github.com/nvim-tree/nvim-tree.lua) is the
project sidebar, with git status and diagnostics on each file. It loads at
startup so `nvim some/dir` opens the tree. With [review mode](review.md#review-mode)
on, it also marks every file the branch changed against `main`.

Git status is a single letter at the right edge, and the filename takes the same
colour. An open folder doesn't repeat the markers of the files inside it.

| Marker | Means |
|---|---|
| `M` | Modified, not staged |
| `S` | Staged |
| `U` | Untracked (new) |
| `R` / `D` | Renamed / deleted |
| `!` | Merge conflict |
| *(dimmed name)* | Gitignored |

| Keys | Does |
|---|---|
| ++space++ ++e++ | Toggle the tree |
| ++space++ ++shift+e++ | Reveal the current file in the tree |

In the tree, these change the defaults: `l` opens, `h` closes / goes to parent,
`i` shows file info, ++ctrl+t++ makes a directory the root.
++space++ ++a++ ++s++ adds the file under the cursor to Claude. `g?` lists
everything else.

### oil.nvim

[`stevearc/oil.nvim`](https://github.com/stevearc/oil.nvim) opens a directory as
an ordinary buffer: rename a line to rename the file, delete a line to delete it,
add a line to create one, then `:w` applies everything (after a confirmation).
Renames go through the language server, so imports follow a moved file. It opens
as a float with a preview of the file under the cursor. nvim-tree stays the
sidebar and keeps `nvim some/dir`.

| Keys | Does |
|---|---|
| `-` | Open this file's directory in oil. Replaces stock `-` (line up) |
| `h` / `-` (in oil) | Parent directory |
| ++enter++ (in oil) | Open the file / enter the directory |
| `q` (in oil) | Close |
| `g.` (in oil) | Toggle dotfiles |
| `g?` (in oil) | Every oil key |

### aerial.nvim

[`stevearc/aerial.nvim`](https://github.com/stevearc/aerial.nvim) shows a symbol
outline of the current file, from LSP, treesitter, markdown headings or man
sections.

| Keys | Does |
|---|---|
| ++space++ ++o++ | Outline sidebar |
| ++space++ ++c++ ++shift+o++ | Outline as a floating nav window |
| `[[` / `]]` | Previous / next symbol |

In the outline: ++enter++ or `o` jumps, `q` closes.

---

## Syntax

### nvim-treesitter

[`nvim-treesitter/nvim-treesitter`](https://github.com/nvim-treesitter/nvim-treesitter)
on the **`main`** branch. On `main` the plugin only installs parsers. Highlighting,
folding and indent are Neovim 0.12 built-ins, which `treesitter.lua` switches on
in a `FileType` autocmd. It installs 34 parsers up front and fetches more the
first time you open a new filetype. You need the `tree-sitter` CLI to build them.

| Keys | Does |
|---|---|
| ++ctrl+space++ | Start / grow selection by syntax node |
| ++backspace++ (visual) | Shrink it |

Folding is treesitter-driven everywhere a parser exists: `zM` collapses a file
to its signatures, `zR` opens it back up.

### nvim-treesitter-textobjects

[`nvim-treesitter/nvim-treesitter-textobjects`](https://github.com/nvim-treesitter/nvim-treesitter-textobjects),
also on `main`, which has no keymap tables, so every map is written out in
`treesitter.lua`.

| Keys | Does |
|---|---|
| `af` / `if` | Function, outer / inner |
| `ac` / `ic` | Class |
| `aa` / `ia` | Parameter |
| `ab` / `ib` | Block |
| `a/` | Comment |
| `]f` `[f` / `]F` `[F` | Next / prev function start / end |
| `]c` `[c` / `]C` `[C` | Next / prev class start / end. **Shadows diff-mode `]c`**, see [Known clashes](#known-clashes) |
| ++space++ ++c++ ++p++ / ++shift+p++ | Swap parameter with next / previous |

Moves set the jumplist, so ++ctrl+o++ brings you back.

### nvim-treesitter-context

[`nvim-treesitter/nvim-treesitter-context`](https://github.com/nvim-treesitter/nvim-treesitter-context)
pins the enclosing function, class or `if` to the top of the window, up to four
lines.

| Keys | Does |
|---|---|
| `[x` | Jump up to the context line |
| ++space++ ++u++ ++t++ | Toggle it |

---

## Code intelligence

### nvim-lspconfig, mason, mason-lspconfig

[`neovim/nvim-lspconfig`](https://github.com/neovim/nvim-lspconfig) supplies the
server definitions that Neovim's native `vim.lsp.config` / `vim.lsp.enable` use.
[`mason.nvim`](https://github.com/mason-org/mason.nvim) installs them, and
[`mason-lspconfig.nvim`](https://github.com/mason-org/mason-lspconfig.nvim)
installs and enables **exactly** the `SERVERS` list in `lsp.lua`:

`lua_ls` · `gopls` · `vtsls` · `basedpyright` · `bashls` · `jsonls` · `yamlls` ·
`terraformls` · `dockerls` · `marksman`

`vtsls` is the TypeScript server (the same tsserver as `ts_ls`, plus "go to
source definition"). `basedpyright` is a pyright fork that adds inlay hints, set
to pyright's `standard` checking. Mason also installs the formatters and
Copilot's server from the `TOOLS` list.

The keys below are set on `LspAttach`, so they exist only in buffers with a
running server. Most results open in fzf-lua.

| Keys | Does |
|---|---|
| `gd` / `gD` | Definition / declaration |
| `gr` | References. Stock `grr` `grn` `gra` `gri` still work if you type them without pausing |
| `gI` | Go to the code that runs. TypeScript: the source definition, so a library call lands in its `.js`, not the `.d.ts` that `gd` shows. Other languages: the implementations (Go interfaces, Python abstract methods), or the definition when there are none |
| `gy` | Type definition |
| `gO` | Document symbols (picker) |
| ++space++ ++c++ ++s++ | Workspace symbols, live |
| ++space++ ++c++ ++c++ / ++shift+c++ | Incoming / outgoing calls |
| ++space++ ++c++ ++r++ | Rename |
| ++space++ ++c++ ++a++ | Code action (n / v) |
| ++space++ ++c++ ++i++ / `K` | Hover |
| ++space++ ++u++ ++h++ | Toggle inlay hints. On by default for vtsls, basedpyright, gopls and lua_ls |
| ++space++ ++c++ ++m++ | Open Mason |

It also highlights other references to the symbol under the cursor on `CursorHold`.

### blink.cmp + friendly-snippets

[`saghen/blink.cmp`](https://github.com/Saghen/blink.cmp) is the completion
engine, pinned to `1.*` so it uses the prebuilt Rust matcher.
[`friendly-snippets`](https://github.com/rafamadriz/friendly-snippets) supplies
the snippets. Sources: LSP, path, snippets, buffer.

| Keys (insert) | Does |
|---|---|
| ++ctrl+y++ | Accept |
| ++ctrl+n++ ++ctrl+p++ / ++ctrl+j++ ++ctrl+k++ | Next / previous |
| ++ctrl+space++ | Open menu / docs |
| ++ctrl+e++ | Dismiss |
| ++tab++ / ++shift+tab++ | Next / previous snippet field |

++tab++ and ++enter++ never accept a completion, on purpose.

### nvim-lint

[`mfussenegger/nvim-lint`](https://github.com/mfussenegger/nvim-lint) runs on
read, write and `InsertLeave`. It only runs linters that are actually on `$PATH`,
so a missing one is skipped quietly.

| Filetype | Linter |
|---|---|
| sh, bash, zsh | `shellcheck` |
| dockerfile | `hadolint` |
| yaml | `yamllint` |
| markdown | `markdownlint` (tuned by `.markdownlint.json`) |
| go | `golangci-lint` |
| terraform | `tflint` |

| Keys | Does |
|---|---|
| ++space++ ++c++ ++l++ | Lint now |

### conform.nvim

[`stevearc/conform.nvim`](https://github.com/stevearc/conform.nvim) formats on
save. Filetypes without a formatter below fall back to their language server
(gopls, terraformls).

| Filetype | Formatter |
|---|---|
| JS, TS, JSX, TSX, JSON, CSS, SCSS, HTML, YAML, GraphQL | `oxfmt` if the project has an oxfmt or Vite+ config, else `prettierd`, else `prettier` |
| Python | `ruff` (organise imports, then format) |
| Lua | `stylua`, using `nvim/.stylua.toml` (2-space) here |
| sh, bash | `shfmt -i 2 -ci`, **on demand only** |
| Markdown | none |

Shell is skipped on save because shfmt would re-indent hand-aligned scripts.
Markdown has no formatter at all: prettier mangles mkdocs `!!!` and `===` blocks.

| Keys | Does |
|---|---|
| ++space++ ++c++ ++f++ | Format the buffer, or the selection |
| ++space++ ++u++ ++f++ / `:ToggleFormatter` | Format on save off / on for this buffer |
| `:ConformInfo` | Which formatters apply here, and the log |

---

## Git

### gitsigns.nvim

[`lewis6991/gitsigns.nvim`](https://github.com/lewis6991/gitsigns.nvim) handles
gutter signs (line numbers are tinted too), hunk staging, blame, and the
[review mode](review.md#review-mode) base switch. All keys are buffer-local, so
they only exist in files inside a git repo.

| Keys | Does |
|---|---|
| `]h` / `[h` | Next / previous hunk (in diff mode: stock `]c` / `[c`) |
| `ih` | Hunk text object, e.g. `vih` |
| ++space++ ++g++ ++h++ / ++shift+h++ | Stage / reset hunk (n / v) |
| ++space++ ++g++ ++u++ | Undo stage hunk |
| ++space++ ++g++ ++shift+s++ / ++shift+r++ | Stage / reset buffer |
| ++space++ ++g++ ++p++ | Preview hunk inline |
| ++space++ ++g++ ++b++ / ++shift+b++ | Blame line (full) / blame buffer |
| ++space++ ++g++ ++d++ / ++shift+d++ | Diff against index / last commit |
| ++space++ ++u++ ++b++ | Toggle inline blame |
| ++space++ ++g++ ++r++ | **Review mode**: diff the gutter and tree against the merge-base with `main` |
| ++space++ ++g++ ++l++ | Toggle full-line highlight of changed lines |

### gitlinker.nvim

[`linrongbin16/gitlinker.nvim`](https://github.com/linrongbin16/gitlinker.nvim)
builds a GitHub permalink for the cursor line or the visual selection, pinned to
a commit that exists on the remote.

| Keys | Does |
|---|---|
| ++space++ ++g++ ++y++ | Copy the link (n / v) |
| ++space++ ++g++ ++shift+y++ | Open the link in the browser (n / v) |
| `:GitLink blame` | Copy the blame-page link instead |

### FTerm.nvim

[`numToStr/FTerm.nvim`](https://github.com/numToStr/FTerm.nvim) provides
floating terminals. One is a general shell and one is a dedicated lazygit float.
When lazygit exits, gitsigns refreshes so the gutter is current.

| Keys | Does |
|---|---|
| ++ctrl+backslash++ | Toggle floating shell (also from terminal mode) |
| ++space++ ++g++ ++g++ | Lazygit |

---

## PR review

### codediff.nvim

[`esmuellert/codediff.nvim`](https://github.com/esmuellert/codediff.nvim) is a
VS Code-style diff: a file tree with per-file line counts on the left and a
side-by-side diff on the right, showing only the changes plus 8 lines of context.
It is the quick look at what changed. diffview (below) stays for the gh-dash
flow and merge conflicts. On first use it downloads a prebuilt diff library from
its GitHub releases (`:CodeDiff install!` reinstalls it).

| Keys | Does |
|---|---|
| ++space++ ++d++ ++v++ | Toggle the diff of the working tree (closes it if open) |
| ++space++ ++d++ ++h++ | History of this file |
| ++space++ ++d++ ++shift+h++ | History of the repo |
| `:CodeDiff main` / `:CodeDiff HEAD~3` | Diff against a revision |
| `:CodeDiff pr 512` | Diff a GitHub PR |

The two below, plus gitsigns' review mode, turn nvim into the review client for
[gh-dash](review.md#from-gh-dash). [PR review](review.md) walks through the
workflow. This section is the reference.

### diffview.nvim

[`sindrets/diffview.nvim`](https://github.com/sindrets/diffview.nvim) gives a
tabbed diff of any revision range: a file panel on the left and a side-by-side
diff on the right. It also does file history and a 3-way merge tool
(`diff3_mixed` layout).

The base is `origin/$REVIEW_BASE` when gh-dash launched nvim. Otherwise it is
origin's default branch.

| Keys | Does |
|---|---|
| ++space++ ++g++ ++v++ | Whole branch vs base (`base...HEAD`) |
| ++space++ ++g++ ++m++ | Branch commit by commit (file history over `base..HEAD`) |
| ++space++ ++g++ ++f++ | History of the current file |
| ++space++ ++g++ ++x++ / `q` | Close diffview (`q` works in every diffview panel) |

Inside diffview (plugin defaults):

| Keys | Does |
|---|---|
| ++tab++ / ++shift+tab++ | Next / previous file |
| `[F` / `]F` | First / last file |
| `gf` | Open the file in the previous tab |
| ++space++ ++e++ / ++space++ ++b++ | Focus / toggle the file panel |
| `g<C-x>` | Cycle diff layouts |
| `j` `k` ++enter++ `o` `l` | File panel: move / open |
| `-` / `s`, `S`, `U` | File panel: stage-toggle entry, stage all, unstage all |
| `X` | Restore entry to the left-hand state |
| `L` | Commit log panel / commit details |
| `y` | File history: copy commit hash |
| `[x` / `]x` | Merge tool: previous / next conflict |
| ++space++ ++c++ ++o++ / ++t++ / ++b++ / ++a++ | Merge tool: choose ours / theirs / base / all (capitals: whole file) |
| `dx` / `dX` | Delete conflict region / for whole file |
| `g?` | Help |

### octo.nvim

[`pwntester/octo.nvim`](https://github.com/pwntester/octo.nvim) brings GitHub
PRs and issues into buffers. You can read the description and threads, leave
inline review comments and suggestions, and submit the review. It uses fzf-lua
as its picker and needs `gh` to be authenticated.

| Keys | Does |
|---|---|
| ++space++ ++r++ ++l++ | List open PRs |
| ++space++ ++r++ ++o++ | Open this checkout's PR (uses `$REVIEW_PR`, else `gh pr view`) |
| ++space++ ++r++ ++s++ | Start a review |
| ++space++ ++r++ ++r++ | Resume a pending review |
| ++space++ ++r++ ++c++ | Review a single commit |
| ++space++ ++r++ ++b++ | Open the PR in the browser |

Inside octo buffers (plugin defaults; `<localleader>` is ++space++):

=== "PR buffer"

    | Keys | Does |
    |---|---|
    | ++space++ ++v++ ++s++ / ++space++ ++v++ ++r++ | Start / resume a review |
    | ++space++ ++c++ ++a++ / ++space++ ++c++ ++r++ | Add comment / reply |
    | ++space++ ++c++ ++d++ | Delete comment |
    | `]c` / `[c` | Next / previous comment |
    | ++space++ ++r++ ++t++ / ++space++ ++r++ ++shift+t++ | Resolve / unresolve thread |
    | ++space++ ++p++ ++c++ / ++space++ ++p++ ++f++ / ++space++ ++p++ ++d++ | List commits / changed files / show diff |
    | ++space++ ++p++ ++o++ | Check the PR out |
    | ++space++ ++p++ ++m++ / ++space++ `psm` / ++space++ `prm` | Merge / squash / rebase |
    | ++space++ ++v++ ++a++ / ++space++ ++v++ ++d++ | Add / remove reviewer |
    | ++space++ ++g++ ++c++ / ++space++ ++t++ ++c++ | Open CI check / fold checks list |
    | ++space++ ++r++ + `p` `h` `e` `+` `-` `r` `l` `c` | React 🎉 ❤️ 👀 👍 👎 🚀 😄 😕 |
    | ++ctrl+r++ / ++ctrl+b++ / ++ctrl+y++ | Reload / browser / copy URL |
    | ++enter++ | PR options menu |

=== "Review diff"

    | Keys | Does |
    |---|---|
    | ++space++ ++c++ ++a++ | Add a review comment (visual: on a range) |
    | ++space++ ++s++ ++a++ | Add a suggestion (visual: on a range) |
    | `]t` / `[t` | Next / previous thread |
    | `]q` / `[q`, `[Q` / `]Q` | Next / previous file, first / last |
    | `]u` / `[u` | Next / previous **unviewed** file |
    | ++space++ ++space++ | Toggle "viewed" on this file |
    | ++space++ ++e++ / ++space++ ++b++ | Focus / toggle the changed-files panel |
    | ++space++ ++v++ ++s++ | Submit the review |
    | ++space++ ++v++ ++d++ | Discard the review |
    | ++space++ ++shift+c++ | Review PR commits |
    | ++ctrl+c++ | Close the review tab |

=== "Submit window"

    | Keys | Does |
    |---|---|
    | ++ctrl+a++ | Approve |
    | ++ctrl+m++ | Comment |
    | ++ctrl+r++ | Request changes |
    | ++ctrl+c++ | Close |

---

## AI

See [AI workflow](ai.md) for when to use which.

### claudecode.nvim

[`coder/claudecode.nvim`](https://github.com/coder/claudecode.nvim) runs the
`claude` CLI in a right-hand split (40%), using the same protocol as the VS Code
extension. Claude can see your selection, and its edits arrive as real Neovim
diffs. It uses your subscription, so you don't need an API key.

| Keys | Does |
|---|---|
| ++space++ ++a++ ++c++ / ++space++ ++a++ ++f++ | Toggle / focus Claude |
| ++space++ ++a++ ++r++ / ++space++ ++a++ ++shift+c++ | Resume a session / continue the last |
| ++space++ ++a++ ++m++ | Select model |
| ++space++ ++a++ ++b++ | Add current buffer as context |
| ++space++ ++a++ ++s++ | Send selection (visual), or add file under cursor (nvim-tree) |
| ++space++ ++a++ ++a++ / ++space++ ++a++ ++d++ | Accept / deny the proposed diff |
| ++space++ ++a++ ++q++ | Close all diffs |
| ++space++ ++a++ ++question++ | Connection status |

### codecompanion.nvim

[`olimorris/codecompanion.nvim`](https://github.com/olimorris/codecompanion.nvim)
is a chat buffer and inline assistant that talks to the Anthropic API directly.
It needs **`ANTHROPIC_API_KEY`** and is billed per token. If the key is missing,
it warns once when the chat opens.

| Keys | Does |
|---|---|
| ++space++ ++n++ ++n++ | Toggle chat (n / v) |
| ++space++ ++n++ ++a++ | Action palette (n / v) |
| ++space++ ++n++ ++i++ | Inline assistant (n / v) |
| ++space++ ++n++ ++d++ | Add selection to chat (v) |
| ++space++ ++n++ ++c++ | Generate a `:command` |

In the chat: ++enter++ (normal) or ++ctrl+s++ (insert) sends; `q` / ++ctrl+c++
closes.

### copilot.lua

[`zbirenbaum/copilot.lua`](https://github.com/zbirenbaum/copilot.lua) shows
Copilot's suggestions inline as you type, Markdown and help buffers included. It
runs Mason's `copilot-language-server`. Run `:Copilot auth` once per machine; the
login lands in `~/.config/github-copilot/`, which is gitignored.

| Keys (insert) | Does |
|---|---|
| ++ctrl+l++ | Accept the suggestion |
| ++alt+l++ / ++alt+shift+l++ | Accept one word / one line |
| ++alt+bracket-right++ / ++alt+bracket-left++ | Next / previous suggestion |
| ++ctrl+bracket-right++ | Dismiss (with nothing showing: stock abbreviation expand) |

The ++alt++ keys need the left ++option++ key sent as Alt, as the terminal is set up.

### Context helpers

`config/context.lua`, no plugin. For pasting context into an agent outside
Neovim, such as Claude Code in another tmux pane, a web chat, or a PR comment.

| Keys | Does |
|---|---|
| ++space++ ++y++ ++f++ | Copy `path/from/cwd#L42` |
| ++space++ ++y++ ++p++ | Copy `/absolute/path#L42` |
| ++space++ ++y++ ++c++ (visual) | Copy the selection as a fenced code block tagged `filename="…" line=…`, the path from the project root |
| ++space++ ++j++ | The project's `package.json` in a float (`q` closes) |

---

## Markdown

`markdown.lua` is built for editing this repo's mkdocs site, not for taking notes.
There is deliberately no browser preview. A GitHub-flavoured preview would get
`!!!` admonitions and `===` tabs wrong, so ++space++ ++m++ ++p++ runs the real
`mkdocs serve` instead.

### render-markdown.nvim

[`MeanderingProgrammer/render-markdown.nvim`](https://github.com/MeanderingProgrammer/render-markdown.nvim)
renders headings, code blocks, tables, checkboxes and links in the buffer. Only
in normal / command / terminal mode, and the cursor line stays raw. It also
renders CodeCompanion chat buffers. `markdown.lua` adds highlighting for
Material's `!!!` and `===` syntax on top.

| Keys | Does |
|---|---|
| ++space++ ++u++ ++m++ | Toggle rendering |

### vim-table-mode

[`dhruvasagar/vim-table-mode`](https://github.com/dhruvasagar/vim-table-mode)
re-aligns the table as you type `|`. Its own mappings are switched off, and these
markdown-only ones are used instead:

| Keys | Does |
|---|---|
| ++space++ ++m++ ++t++ | Toggle table mode |
| ++space++ ++m++ ++r++ | Realign table |
| ++space++ ++m++ ++shift+t++ | Tableize selection (CSV → table) |

Two more keys live in `markdown.lua` itself, with no plugin behind them:

| Keys | Does |
|---|---|
| ++space++ ++m++ ++x++ | Toggle checkbox `[ ]` ↔ `[x]`, promoting a plain list item (n / v) |
| ++space++ ++m++ ++p++ | Start / stop `mkdocs serve` and open the browser |

---

## Interface

### Colourschemes: tokyonight, solarized-osaka, catppuccin

[`folke/tokyonight.nvim`](https://github.com/folke/tokyonight.nvim),
[`craftzdog/solarized-osaka.nvim`](https://github.com/craftzdog/solarized-osaka.nvim)
and [`catppuccin/nvim`](https://github.com/catppuccin/nvim) are all installed,
but only the one named in `~/.config/theme/current` loads, through
`config/theme.lua`. All three are transparent so Ghostty's blur shows through.
solarized-osaka loads its `-vivid` variant, the look from craftzdog's own config:
the same palette with brighter text.
To switch, run `theme <name>` in the shell, then restart nvim. See
[Theming](../theming.md).

### lualine.nvim

[`nvim-lualine/lualine.nvim`](https://github.com/nvim-lualine/lualine.nvim) is a
single global statusline showing mode, branch, diagnostics, relative path, the
diff count, attached LSP servers (on wide terminals) and position. No keys.

### barbar.nvim

[`romgrk/barbar.nvim`](https://github.com/romgrk/barbar.nvim) shows buffer tabs
along the top with gitsigns counts. Tabs move aside for the tree and the outline.

| Keys | Does |
|---|---|
| ++shift+h++ / ++shift+l++ | Previous / next buffer |
| ++space++ ++b++ ++s++ | Pick a buffer by letter |
| ++space++ ++1++ … ++5++ / ++space++ ++9++ | Go to position / last |
| ++space++ ++b++ `<` / `>` | Move buffer left / right |
| ++space++ ++b++ ++p++ | Pin / unpin |
| ++space++ ++b++ ++d++ | Close buffer |
| ++space++ ++b++ ++o++ / ++shift+p++ | Close all but current+pinned / all unpinned |
| ++space++ ++b++ ++b++ | Alternate buffer (core keymap, not barbar) |

### alpha-nvim

[`goolord/alpha-nvim`](https://github.com/goolord/alpha-nvim) is the start
screen. Its footer shows the startup time.

| Key | Button |
|---|---|
| `f` `/` `r` | Find file / grep / recent |
| `e` `g` `a` | Tree / lazygit / Claude |
| `c` `l` `q` | Config / Lazy / quit |

### which-key.nvim

[`folke/which-key.nvim`](https://github.com/folke/which-key.nvim) (helix preset):
press ++space++ and wait to see every binding, grouped.

| Keys | Does |
|---|---|
| ++space++ (pause) | All leader bindings |
| ++space++ ++question++ | Only this buffer's bindings |

Groups: `a` ai · `b` buffer · `c` code · `f` find · `g` git · `m` markdown ·
`n` ai chat · `r` review · `s` search · `u` toggles · `x` quickfix.

### nvim-colorizer.lua

[`catgoose/nvim-colorizer.lua`](https://github.com/catgoose/nvim-colorizer.lua),
the maintained fork, shows a `■` swatch after hex, rgb, CSS and Tailwind colours.
Colour *names* are off, so "red" in prose stays plain.

| Keys | Does |
|---|---|
| ++space++ ++u++ ++c++ | Toggle swatches |

### nvim-web-devicons

[`nvim-tree/nvim-web-devicons`](https://github.com/nvim-tree/nvim-web-devicons)
provides filetype glyphs everywhere. Your terminal needs a Nerd Font.

---

## Editing

### nvim-autopairs

[`windwp/nvim-autopairs`](https://github.com/windwp/nvim-autopairs) closes
brackets and quotes, aware of treesitter context.

| Keys (insert) | Does |
|---|---|
| ++alt+e++ | Fast-wrap: wrap the next object in the pair you just typed |

---

## Plumbing

### lazy.nvim

[`folke/lazy.nvim`](https://github.com/folke/lazy.nvim) is the plugin manager.
Everything is lazy by default. It checks for updates quietly and never notifies.

| Keys | Does |
|---|---|
| ++space++ ++shift+l++ | Open Lazy |

### plenary.nvim

[`nvim-lua/plenary.nvim`](https://github.com/nvim-lua/plenary.nvim) is a shared
Lua library that codecompanion and octo depend on. `markdown.lua` also uses it as
a dummy spec to hang its local keys on.

---

## Known clashes

These came from loading the config and reading the installed plugins' default
maps, not from guessing.

| Where | Key | What happens | Workaround |
|---|---|---|---|
| Any diff window (diffview, `:Gitsigns diffthis`, `nvim -d`) | `]c` / `[c` | treesitter-textobjects' global "next class" wins over Vim's "next change" | `]h` / `[h` in buffers gitsigns is attached to; otherwise ++tab++ between files in diffview |
| octo PR buffer | ++space++ ++r++ ++r++ / ++c++ / ++l++ | octo's buffer-local reactions (🚀 😕 😄) beat the global review keys | Use those from a normal buffer, or ++space++ ++v++ ++r++ (octo's own resume) |
| diffview / octo review | ++space++ ++e++ / ++space++ ++b++ | Focus / toggle *their* file panel instead of nvim-tree / buffer keys | Intended. Leave the view to get the global ones back |
| diffview merge tool | ++space++ ++c++ ++o++ etc. | Conflict choices shadow ++space++ ++c++ ++shift+o++ (aerial nav) and friends | Intended |

## Version pins

| Plugin | Pin | Why |
|---|---|---|
| `nvim-treesitter` | `branch = "main"` | The rewrite for Neovim 0.12; `master` is frozen and breaks on 0.12 |
| `nvim-treesitter-textobjects` | `branch = "main"` | Must match the above |
| `aerial.nvim` | `branch = "nvim-0.11"` | Compatibility branch. **Now stale:** this machine runs 0.12.5 and the spec comment says to drop the pin on 0.12 |
| `blink.cmp` | `version = "1.*"` | Prebuilt binary; v2 is still breaking |

## Deliberately absent

| Not installed | Why |
|---|---|
| `Comment.nvim` | `gc` / `gcc` are built in |
| `trouble.nvim` | fzf-lua + quickfix cover it |
| `lazygit.nvim` | FTerm hosts lazygit for free |
| `vim-fugitive` / `neogit` | lazygit for writing history, diffview for reading it |
