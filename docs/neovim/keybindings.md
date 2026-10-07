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
| ++space++ ++s++ `:` | Command history |

### Inside a picker

| Keys | Does |
|---|---|
| ++ctrl+j++ / ++ctrl+k++ | Next / previous result |
| ++enter++ | Open |
| ++ctrl+v++ / ++ctrl+s++ / ++ctrl+t++ | Open in a vertical split / horizontal split / new tab |
| ++tab++ | Mark a result, for opening several at once |
| ++ctrl+q++ | Send every match to the quickfix list |
| ++shift+down++ / ++shift+up++ | Scroll the preview a page |
| ++f4++ | Hide / show the preview |
| ++ctrl+u++ | Clear the query |
| ++ctrl+f++ / ++ctrl+b++ | Half a page down / up the results |
| ++alt+a++ | Mark / unmark everything |
| ++ctrl+slash++ or ++f1++ | Help: every key the picker accepts |
| ++escape++ | Close |

!!! info "++ctrl+d++ / ++ctrl+u++ only scroll some previews"
    Files, grep, buffers and the LSP pickers preview through `bat`, and there
    ++ctrl+u++ clears the query instead. ++ctrl+d++ / ++ctrl+u++ scroll only the
    built-in previewer: marks, jumps, keymaps and quickfix. ++shift+down++ /
    ++shift+up++ work in both.

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
| ++space++ ++o++ | Symbol outline (sidebar) |
| ++space++ ++c++ ++shift+o++ | Symbol nav — the outline as a floating picker |

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
| `]f` / `[f` | Next / previous function start |
| `]F` / `[F` | Next / previous function end |
| `]c` / `[c` | Next / previous class start |
| `]C` / `[C` | Next / previous class end |
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
| ++alt+j++ / ++alt+k++ | Move the line — or the selection — down / up |
| `<` / `>` | Indent left / right in visual, keeping the selection |
| `p` | Paste over a selection *without* yanking what you replaced |
| ++alt+e++ | In insert mode, right after typing a bracket or quote: wrap the next word or expression in the pair |

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
| ++space++ ++b++ ++shift+p++ | Close every unpinned buffer |
| ++space++ ++b++ `<` / `>` | Move this buffer left / right in the bar |
| ++space++ ++1++ … ++5++ | Jump to tab position |
| ++space++ ++9++ | Jump to the last buffer in the bar |
| ++ctrl+h++ ++ctrl+j++ ++ctrl+k++ ++ctrl+l++ | Move between windows |
| ++space++ ++minus++ | Split below |
| ++space++ ++bar++ | Split right |
| ++ctrl+up++ / ++ctrl+down++ | Taller / shorter window |
| ++ctrl+left++ / ++ctrl+right++ | Narrower / wider window |

## Git

| Keys | Does |
|---|---|
| ++space++ ++g++ ++g++ | Lazygit, full screen |
| `]h` / `[h` | Next / previous changed hunk |
| ++space++ ++g++ ++h++ | Stage hunk (works on a visual selection) |
| ++space++ ++g++ ++shift+h++ | Reset hunk |
| ++space++ ++g++ ++u++ | Undo stage hunk |
| ++space++ ++g++ ++shift+s++ | Stage the whole buffer |
| ++space++ ++g++ ++shift+r++ | Reset the whole buffer |
| ++space++ ++g++ ++s++ | Git status picker (fzf — note the lowercase) |
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
| ++space++ ++a++ ++question++ | Connection status — is Claude actually attached? |
| ++space++ ++n++ ++n++ | CodeCompanion chat |
| ++space++ ++n++ ++i++ | CodeCompanion inline |
| ++space++ ++n++ ++a++ | CodeCompanion action palette |
| ++space++ ++n++ ++d++ | Add the selection to the CodeCompanion chat |
| ++space++ ++n++ ++c++ | Generate a `:command` from a description |

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
| ++space++ ++shift+q++ | Quit **all** windows |
| ++escape++ | Clear search highlight |
| ++n++ / ++shift+n++ | Next / previous search hit, re-centred |
| ++g++ ++x++ | Open the URL under the cursor |
| ++space++ ++shift+l++ | Lazy (plugin manager) |
| ++space++ ++question++ | Bindings for this buffer |
| ++s++ / ++shift+s++ | Flash jump / flash treesitter |
| `r` after an operator | Remote flash: act on text elsewhere without moving. `yr`, jump, then a motion (`iw`), yanks that word and leaves the cursor where it was |
| ++q++ | Close help, man, quickfix, checkhealth and git-blame windows |

### Quickfix

++space++ ++s++ ++q++ above opens it as a fuzzy picker; these are the plain
list.

| Keys | Does |
|---|---|
| ++space++ ++x++ ++q++ | Open the quickfix window |
| `]q` / `[q` | Next / previous quickfix item |

### Terminal mode

The floating terminal is ++ctrl+backslash++. Once you are inside it, the
normal-mode window bindings would otherwise be swallowed by the shell, so they
are re-bound for terminal mode too.

| Keys | Does |
|---|---|
| ++ctrl+slash++ | Leave terminal mode (back to normal mode) |
| ++ctrl+h++ ++ctrl+j++ ++ctrl+k++ ++ctrl+l++ | Move out to another window directly |

## Inside plugin windows

These only work while the cursor is in that plugin's window.

### File tree (++space++ ++e++)

nvim-tree's defaults, with four changes: `l` / `h` open and close like a
directory browser, `i` shows file info, and ++ctrl+t++ makes a directory the
tree's root instead of opening it in a tab.

| Keys | Does |
|---|---|
| `l` / ++enter++ | Open the file, or expand the directory |
| `h` | Collapse the directory, or jump to its parent |
| ++ctrl+t++ | Make this directory the root of the tree |
| `-` | Move the root up a level |
| ++ctrl+v++ / ++ctrl+x++ | Open in a vertical / horizontal split |
| `a` | Create a file. End the name with `/` for a directory |
| `r` | Rename |
| `d` | Delete (asks first) |
| `x` / `c` / `p` | Cut / copy / paste |
| `y` / `Y` / `gy` | Copy the name / relative path / absolute path |
| `i` | File info: size, dates, path |
| `H` / `I` | Show / hide dotfiles / gitignored files |
| `f` / `F` | Filter the tree / clear the filter |
| `E` / `W` | Expand / collapse everything |
| `R` | Refresh |
| `g?` | Every binding |
| `q` | Close |

++space++ ++a++ ++s++ in the tree adds the file under the cursor to Claude's
context.

### Symbol outline (++space++ ++o++)

| Keys | Does |
|---|---|
| ++enter++ / `o` | Jump to the symbol |
| `{` / `}` | Previous / next symbol |
| `za` | Expand / collapse the symbol under the cursor |
| `q` | Close |
| `?` | Every binding |

### CodeCompanion chat (++space++ ++n++ ++n++)

| Keys | Does |
|---|---|
| ++enter++ (normal) / ++ctrl+s++ (insert) | Send the message |
| `q` (normal) / ++ctrl+c++ (insert) | Close the chat |
| `?` | Every binding |

!!! warning "++s++ is taken by flash"
    It no longer substitutes a character. Use ++c++ ++l++ for that.
