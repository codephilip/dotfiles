# Key bindings

Leader is ++space++. Bindings are written as a sequence: ++space++ ++f++ ++f++
means press space, then f, then f.

!!! tip "You rarely need this page"
    Press ++space++ and pause — which-key shows the same information in context,
    grouped and filtered to what is actually available in the current buffer.
    ++space++ ++question++ shows only the current buffer's bindings.

## The ones that matter

If you memorise nine things, memorise these.

| Keys | Does |
|---|---|
| ++space++ ++space++ | Find files |
| ++space++ ++slash++ | Live grep the project |
| ++g++ ++d++ | Go to definition |
| ++g++ ++r++ | Find all references |
| ++space++ ++o++ | Symbol outline |
| ++s++ | Jump anywhere visible |
| ++space++ ++g++ ++g++ | Lazygit |
| ++space++ ++a++ ++c++ | Toggle Claude |
| ++space++ | Show every binding |

## Finding

| Keys | Does |
|---|---|
| ++space++ ++space++ | Find files |
| ++space++ ++f++ ++f++ | Find files |
| ++space++ ++f++ ++g++ | Find git-tracked files |
| ++space++ ++f++ ++r++ | Recent files |
| ++space++ ++f++ ++b++ | Buffers |
| ++space++ ++f++ ++c++ | Find inside the Neovim config |
| ++space++ ++slash++ | Live grep |
| ++space++ ++s++ ++g++ | Live grep |
| ++space++ ++s++ ++w++ | Grep word under cursor (or selection, in visual) |
| ++space++ ++s++ ++b++ | Grep the current buffer |
| ++space++ ++s++ ++r++ | Resume the last picker, with its query |
| ++space++ ++s++ ++h++ | Help pages |
| ++space++ ++s++ ++k++ | Keymaps |
| ++space++ ++s++ ++j++ | Jumplist |
| ++space++ ++s++ ++m++ | Marks |
| ++space++ ++s++ ++d++ | Workspace diagnostics |
| ++space++ ++s++ ++q++ | Quickfix list |

Inside any picker: ++ctrl+q++ sends all matches to the quickfix list,
++ctrl+slash++ toggles help, ++ctrl+d++ / ++ctrl+u++ scroll the preview.

## Understanding code

| Keys | Does |
|---|---|
| ++g++ ++d++ | Go to definition |
| ++g++ ++shift+d++ | Go to declaration |
| ++g++ ++r++ | References |
| ++g++ ++shift+i++ | Implementation |
| ++g++ ++y++ | Type definition |
| ++g++ ++shift+o++ | Document symbols |
| ++k++ | Hover documentation |
| ++space++ ++c++ ++s++ | Workspace symbols (live search) |
| ++space++ ++c++ ++c++ | Incoming calls — who calls this? |
| ++space++ ++c++ ++shift+c++ | Outgoing calls — what does this call? |
| ++space++ ++c++ ++d++ | Line diagnostics |
| `]d` / `[d` | Next / previous diagnostic |

### Scanning a file

Holding ++j++ is one line per keypress regardless of how fast the key repeat is
set, so a 600-line file is always 600 presses. Folding is the one that changes
how the file feels: treesitter folds are enabled per-buffer wherever a parser
exists, so `zM` collapses every function to its signature. On this repo's
`lua/plugins/lsp.lua` that turns 183 lines into 11 screen rows.

| Keys | Does |
|---|---|
| `zM` | Collapse everything — the file's shape on one screen |
| `zR` | Expand everything again |
| `za` | Toggle the fold under the cursor |
| `zo` / `zc` | Open / close the fold under the cursor |
| ++ctrl+d++ / ++ctrl+u++ | Half a page, cursor re-centred |
| `12j` / `8k` | Jump by the number in the gutter — numbers are relative |
| ++ctrl+o++ / ++ctrl+i++ | Back / forward through the jumplist |
| `H` / `M` / `L` | Top / middle / bottom of the screen |
| ++space++ ++s++ ++b++ | Fuzzy-search the lines of this buffer only |

!!! tip "Files open expanded"
    `foldlevel` is 99, so nothing is folded until you ask. `zM` is the
    deliberate "show me the shape" gesture rather than a state you live in.

!!! example "Finding your way around an unfamiliar file"
    `zM` to collapse it, then ++j++ / ++k++ down the list of signatures — now
    one press really is one function — then `za` to open the one you want.
    ++space++ ++o++ does the same job as a sidebar if you prefer it persistent.

### Syntax-aware motion

These operate on the syntax tree, not on lines.

| Keys | Does |
|---|---|
| ++ctrl+space++ | Grow selection by one syntax node; repeat to widen |
| ++backspace++ | Shrink the selection again |
| `vaf` / `vif` | Select a function / its body |
| `vac` / `vic` | Select a class / its body |
| `vaa` / `via` | Select an argument |
| `vab` / `vib` | Select a block |
| `va/` | Select a comment |
| `]f` / `[f` | Next / previous function |
| `]c` / `[c` | Next / previous class |
| `[[` / `]]` | Previous / next symbol (aerial) |
| `[x` | Jump up to the enclosing context |

!!! example "Reading an unfamiliar function"
    Put the cursor in it, press `vaf` to select the whole thing, then
    ++space++ ++a++ ++s++ to hand exactly that to Claude. No copy-paste, no
    guessing at line numbers.

## Changing code

| Keys | Does |
|---|---|
| ++space++ ++c++ ++r++ | Rename symbol across the project |
| ++space++ ++c++ ++a++ | Code action |
| ++space++ ++c++ ++f++ | Format buffer (LSP) |
| ++space++ ++c++ ++i++ | Hover info |
| ++space++ ++c++ ++l++ | Lint now |
| ++space++ ++c++ ++m++ | Mason — install servers and tools |
| ++space++ ++c++ ++p++ / ++shift+p++ | Swap argument with next / previous |
| ++space++ ++s++ ++shift+r++ | Start a substitution |
| ++space++ ++c++ ++x++ | `chmod +x` the current file |
| ++space++ ++c++ ++shift+r++ | Re-source the current file |

## Completion

blink.cmp, `default` preset. ++tab++ and ++enter++ are deliberately left alone.

| Keys | Does |
|---|---|
| ++ctrl+y++ | Accept the selected item |
| ++ctrl+n++ / ++ctrl+p++ | Next / previous item |
| ++ctrl+j++ / ++ctrl+k++ | Next / previous item |
| ++ctrl+space++ | Open menu / toggle documentation |
| ++ctrl+e++ | Dismiss |
| ++tab++ / ++shift+tab++ | Jump between snippet fields |
| ++ctrl+s++ | Signature help (Neovim built-in) |

## Buffers and windows

| Keys | Does |
|---|---|
| ++shift+h++ / ++shift+l++ | Previous / next buffer |
| ++space++ ++b++ ++b++ | Switch to the other buffer |
| ++space++ ++b++ ++d++ | Close buffer |
| ++space++ ++b++ ++o++ | Close all others |
| ++space++ ++b++ ++s++ | Pick a buffer by letter |
| ++space++ ++b++ ++p++ | Pin / unpin |
| ++space++ ++1++ … ++5++ | Jump to tab position |
| ++ctrl+h++ ++ctrl+j++ ++ctrl+k++ ++ctrl+l++ | Move between windows |
| ++space++ ++minus++ | Split below |
| ++space++ ++bar++ | Split right |

## Git

| Keys | Does |
|---|---|
| ++space++ ++g++ ++g++ | Lazygit, full screen |
| `]h` / `[h` | Next / previous changed hunk |
| ++space++ ++g++ ++h++ | Stage hunk (works on a visual selection) |
| ++space++ ++g++ ++shift+h++ | Reset hunk |
| ++space++ ++g++ ++u++ | Undo stage hunk |
| ++space++ ++g++ ++s++ | Stage buffer / git status picker |
| ++space++ ++g++ ++p++ | Preview hunk inline |
| ++space++ ++g++ ++b++ | Blame this line, full message |
| ++space++ ++g++ ++shift+b++ | Blame the whole buffer |
| ++space++ ++g++ ++d++ | Diff against the index |
| ++space++ ++g++ ++shift+d++ | Diff against the last commit |
| ++space++ ++g++ ++c++ | Repo commit history |
| ++space++ ++g++ ++shift+c++ | This file's commit history |
| `ih` | Hunk text object — `vih` selects the hunk you are in |

## AI

Full detail in [AI workflow](ai.md).

| Keys | Does |
|---|---|
| ++space++ ++a++ ++c++ | Toggle the Claude split |
| ++space++ ++a++ ++f++ | Focus Claude |
| ++space++ ++a++ ++s++ | Send selection — or, in the tree, add that file |
| ++space++ ++a++ ++b++ | Add the current buffer as context |
| ++space++ ++a++ ++r++ | Resume a session |
| ++space++ ++a++ ++shift+c++ | Continue the last session |
| ++space++ ++a++ ++m++ | Select model |
| ++space++ ++a++ ++a++ | **Accept** the proposed diff |
| ++space++ ++a++ ++d++ | **Deny** the proposed diff |
| ++space++ ++a++ ++q++ | Close all diffs |
| ++space++ ++n++ ++n++ | CodeCompanion chat |
| ++space++ ++n++ ++i++ | CodeCompanion inline |
| ++space++ ++n++ ++a++ | CodeCompanion action palette |

## Toggles

| Keys | Does |
|---|---|
| ++space++ ++u++ ++w++ | Wrap |
| ++space++ ++u++ ++r++ | Relative line numbers |
| ++space++ ++u++ ++d++ | Diagnostics |
| ++space++ ++u++ ++c++ | Colour swatches |
| ++space++ ++u++ ++t++ | Treesitter context |
| ++space++ ++u++ ++b++ | Inline git blame |
| ++space++ ++u++ ++h++ | Inlay hints |
| ++space++ ++u++ ++i++ | Inspect highlight under cursor |
| ++space++ ++u++ ++m++ | Markdown rendering |

## Markdown

Only in `markdown` buffers, except ++space++ ++m++ ++p++ which works
anywhere above an `mkdocs.yml`.

| Keys | Does |
|---|---|
| ++space++ ++m++ ++x++ | Toggle checkbox — also works over a visual selection |
| ++space++ ++m++ ++t++ | Toggle table mode (`\|` re-aligns as you type) |
| ++space++ ++m++ ++r++ | Realign the table under the cursor |
| ++space++ ++m++ ++T++ | Tableize a selection (CSV → markdown table) |
| ++space++ ++m++ ++p++ | Start/stop `mkdocs serve` and open the browser |
| ++space++ ++u++ ++m++ | Toggle rendering for this buffer |

++space++ ++m++ ++x++ cycles `[ ]` → `[x]` → `[ ]`, and promotes a plain
list item to a checkbox so you never type the brackets. It handles `-`,
`*`, `+` and ordered (`1.`) markers, preserves indentation, and anchors to
the marker — so a `[x]` appearing later in the prose is never the one that
gets toggled.

`gd` on a link follows it; `gO` gives a heading outline. Both come from
`marksman`.

## Everything else

| Keys | Does |
|---|---|
| ++space++ ++e++ | File tree |
| ++space++ ++shift+e++ | Reveal current file in the tree |
| ++space++ ++o++ | Symbol outline |
| ++ctrl+backslash++ | Floating terminal |
| ++space++ ++w++ / ++space++ ++q++ | Write / quit |
| ++escape++ | Clear search highlight |
| ++g++ ++x++ | Open the URL under the cursor |
| ++space++ ++shift+l++ | Lazy (plugin manager) |
| ++space++ ++question++ | Bindings for this buffer |
| ++s++ / ++shift+s++ | Flash jump / flash treesitter |

!!! warning "++s++ is taken by flash"
    It no longer substitutes a character. Use ++c++ ++l++ for that.
