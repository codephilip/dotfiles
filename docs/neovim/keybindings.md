# Key bindings

Leader is ++space++. Bindings are written as a sequence: ++space++ ++f++ ++f++
means press space, then f, then f.

Tables are split into **Ours** (added or changed by this config) and **Stock**
(plain Neovim 0.12, so they work on any machine). Picking a tab switches every
tab on the site.

!!! tip "You rarely need this page"
    Press ++space++ and pause — which-key shows the same information in context,
    grouped and filtered to what is actually available in the current buffer.
    ++space++ ++question++ shows only the current buffer's bindings.

## Quick reference

=== "Ours"

    | Keys | Does |
    |---|---|
    | ++space++ ++space++ | Find files |
    | ++space++ ++slash++ | Live grep the project |
    | ++g++ ++d++ | Go to definition (picker) |
    | ++g++ ++r++ | Find all references (picker) |
    | ++space++ ++o++ | Symbol outline |
    | ++space++ ++c++ ++r++ / ++space++ ++c++ ++a++ | Rename / code action |
    | ++s++ | Jump anywhere visible (flash). Replaces stock `s` |
    | ++shift+h++ / ++shift+l++ | Previous / next buffer. Replace stock `H` / `L` |
    | ++ctrl+h++ ++ctrl+j++ ++ctrl+k++ ++ctrl+l++ | Move between windows |
    | ++space++ ++e++ | File tree |
    | ++space++ ++g++ ++g++ | Lazygit |
    | ++space++ ++a++ ++c++ | Toggle Claude |
    | ++space++ | Show every binding |

=== "Stock"

    | Keys | Does |
    |---|---|
    | `ciw` / `ci"` / `ci(` | Change the word / inside quotes / inside parens |
    | `.` | Repeat the last change |
    | `u` / ++ctrl+r++ | Undo / redo |
    | `*` / `#` | Search the word under the cursor, forward / back |
    | `%` | Jump to the matching bracket |
    | ++ctrl+o++ / ++ctrl+i++ | Back / forward through the jumplist |
    | `gi` | Back to where you last typed, in insert mode |
    | `gv` | Reselect the last visual selection |
    | `qa` … `q`, then `@a` / `@@` | Record a macro into `a`, play it / play again |
    | `gcc` / `gc{motion}` | Toggle comment on a line / a motion |
    | `K` | Hover documentation |
    | `grn` / `gra` | Rename / code action |
    | `]d` / `[d` | Next / previous diagnostic |

## Finding

All ours — fzf-lua pickers.

| Keys | Does |
|---|---|
| ++space++ ++space++ or ++space++ ++f++ ++f++ | Find files |
| ++space++ ++f++ ++g++ | Find git-tracked files |
| ++space++ ++f++ ++r++ | Recent files |
| ++space++ ++f++ ++b++ | Buffers |
| ++space++ ++f++ ++c++ | Find inside the Neovim config |
| ++space++ ++slash++ or ++space++ ++s++ ++g++ | Live grep |
| ++space++ ++s++ ++w++ | Grep word under cursor (or selection, in visual) |
| ++space++ ++s++ ++b++ | Grep the current buffer |
| ++space++ ++s++ ++r++ | Resume the last picker, with its query |
| ++space++ ++s++ ++h++ | Help pages |
| ++space++ ++s++ ++k++ | Keymaps |
| ++space++ ++s++ ++j++ / ++space++ ++s++ ++m++ | Jumplist / marks |
| ++space++ ++s++ ++d++ | Workspace diagnostics |
| ++space++ ++s++ ++q++ | Quickfix list |
| ++space++ ++s++ `:` | Command history |

??? note "Hidden and ignored files"

    | Where | Dotfiles | Gitignored | Toggle |
    |---|---|---|---|
    | Find files (++space++ ++space++) | Shown | Hidden | ++alt+h++ hidden, ++alt+i++ ignored |
    | Live grep (++space++ ++slash++) | Searched | Not searched | ++alt+h++ hidden, ++alt+i++ ignored |
    | Find git files (++space++ ++f++ ++g++) | Shown if tracked | Hidden | — |
    | File tree (++space++ ++e++) | Shown | Shown, dimmed | `H` dotfiles, `I` gitignored |

    `.git/` never appears in a picker. The tree also hides `.git`, `node_modules`
    and `.DS_Store` by name. `U` in the tree toggles that list. Use ++alt+i++ when
    you need to look inside something gitignored, like a vendored dependency or a
    generated file. Use the **left** ++option++ key for ++alt++, as in the terminal.

??? note "Inside a picker"

    | Keys | Does |
    |---|---|
    | ++ctrl+j++ / ++ctrl+k++ | Next / previous result |
    | ++enter++ | Open |
    | ++ctrl+v++ / ++ctrl+s++ / ++ctrl+t++ | Open in a vertical split / horizontal split / new tab |
    | ++tab++ | Mark a result, for opening several at once |
    | ++alt+a++ | Mark / unmark everything |
    | ++ctrl+q++ | Send every match to the quickfix list |
    | ++shift+down++ / ++shift+up++ | Scroll the preview a page |
    | ++f4++ | Hide / show the preview |
    | ++ctrl+u++ | Clear the query |
    | ++ctrl+f++ / ++ctrl+b++ | Half a page down / up the results |
    | ++ctrl+slash++ or ++f1++ | Help: every key the picker accepts |
    | ++escape++ | Close |

    Files, grep, buffers and the LSP pickers preview through `bat`, and there
    ++ctrl+u++ clears the query. ++ctrl+d++ / ++ctrl+u++ scroll only the
    built-in previewer: marks, jumps, keymaps and quickfix. ++shift+down++ /
    ++shift+up++ work in both.

## Understanding code

=== "Ours"

    Picker-backed versions of the stock LSP keys, plus the call hierarchy.

    | Keys | Does |
    |---|---|
    | ++g++ ++d++ | Go to definition |
    | ++g++ ++shift+d++ | Go to declaration |
    | ++g++ ++r++ | References. Stock `grr`, `grn` and friends still work — type them without pausing after `gr` |
    | ++g++ ++shift+i++ | Implementation |
    | ++g++ ++y++ | Type definition |
    | ++g++ ++shift+o++ | Document symbols, as a picker. Replaces stock `gO` |
    | ++space++ ++c++ ++s++ | Workspace symbols (live search) |
    | ++space++ ++c++ ++c++ / ++space++ ++c++ ++shift+c++ | Incoming / outgoing calls |
    | ++space++ ++c++ ++d++ | Line diagnostics |
    | `]d` / `[d` | Next / previous diagnostic, with its message in a float. Stock jumps without the float |
    | ++space++ ++o++ | Symbol outline (sidebar) |
    | ++space++ ++c++ ++shift+o++ | The outline as a floating picker |

=== "Stock"

    Active whenever a language server is attached.

    | Keys | Does |
    |---|---|
    | `K` | Hover documentation |
    | ++ctrl+bracket-right++ | Go to definition (LSP `tagfunc`); ++ctrl+t++ comes back |
    | `grn` | Rename |
    | `gra` | Code action |
    | `grr` | References, in the quickfix list |
    | `gri` / `grt` | Implementation / type definition |
    | `gO` | Document symbols (ours overrides with a picker) |
    | `]d` / `[d` | Next / previous diagnostic |
    | `]D` / `[D` | Last / first diagnostic in the buffer |
    | ++ctrl+w++ `d` | Diagnostic under the cursor, in a float |
    | ++ctrl+s++ (insert) | Signature help |

### Scanning a file

Holding ++j++ is one line per keypress however fast key repeat is, so a
600-line file is always 600 presses. Folding changes how the file feels:
treesitter folds are on wherever a parser exists, and `foldlevel` is 99 so
files open expanded. `zM` collapses every function to its signature — on
`lua/plugins/lsp.lua` that turns 183 lines into 11 screen rows.

=== "Ours"

    | Keys | Does |
    |---|---|
    | ++ctrl+d++ / ++ctrl+u++ | Half a page, cursor re-centred |
    | ++n++ / ++shift+n++ | Next / previous search hit, re-centred |
    | ++space++ ++s++ ++b++ | Fuzzy-search the lines of this buffer only |

=== "Stock"

    | Keys | Does |
    |---|---|
    | `zM` / `zR` | Collapse / expand everything |
    | `za` | Toggle the fold under the cursor |
    | `zo` / `zc` | Open / close the fold under the cursor |
    | `12j` / `8k` | Jump by the number in the gutter — numbers are relative |
    | `M` | Middle of the screen. `H` / `L` are buffer switching here |
    | `zz` / `zt` / `zb` | Scroll the cursor line to middle / top / bottom |
    | `{` / `}` | Previous / next blank line — paragraph hopping |

!!! example "Finding your way around an unfamiliar file"
    `zM` to collapse it, then ++j++ / ++k++ down the list of signatures — now
    one press really is one function — then `za` to open the one you want.
    ++space++ ++o++ does the same job as a sidebar if you prefer it persistent.

### Syntax-aware motion

All ours (treesitter text objects and aerial), except `an` / `in`: Neovim
0.12's stock incremental selection.

| Keys | Does |
|---|---|
| ++ctrl+space++ / ++backspace++ | Grow / shrink selection by one syntax node |
| `vaf` / `vif` | Select a function / its body |
| `vac` / `vic` | Select a class / its body |
| `vaa` / `via` | Select an argument |
| `vab` / `vib` | Select a block |
| `va/` | Select a comment |
| `]f` / `[f`, `]F` / `[F` | Next / previous function start, end |
| `]c` / `[c`, `]C` / `[C` | Next / previous class start, end |
| `[[` / `]]` | Previous / next symbol (aerial) |
| `[x` | Jump up to the enclosing context |
| `an` / `in` (visual) | *Stock:* select the parent / child syntax node |

!!! example "Reading an unfamiliar function"
    Put the cursor in it, press `vaf` to select the whole thing, then
    ++space++ ++a++ ++s++ to hand exactly that to Claude. No copy-paste, no
    guessing at line numbers.

## Changing code

=== "Ours"

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
    | `<` / `>` (visual) | Indent, keeping the selection. Stock drops it |
    | `p` (visual) | Paste over a selection *without* yanking what you replaced |
    | ++alt+e++ (insert) | Right after a bracket or quote: wrap the next word in the pair |

=== "Stock"

    | Keys | Does |
    |---|---|
    | `ciw` / `daw` / `yi"` | Change a word / delete it with its space / yank inside quotes — any operator, any text object |
    | `ci(` `ci{` `cit` | Inside parens / braces / an HTML tag |
    | `.` | Repeat the last change |
    | `qa` … `q`, `@a`, `@@` | Record a macro / play it / play the last one again |
    | `gcc` / `gc{motion}` / `gc` (visual) | Toggle comments |
    | `>>` / `<<` | Indent / outdent a line |
    | `J` | Join the next line onto this one |
    | `~` | Toggle case |
    | ++ctrl+a++ / ++ctrl+x++ | Increment / decrement the number under the cursor |
    | `&` | Repeat the last `:s` on this line |
    | `Y` | Yank to end of line |
    | `"+y` / `"+p` | Yank to / paste from the system clipboard |

## Completion

Ours: blink.cmp, `default` preset. ++tab++ and ++enter++ are deliberately left
alone.

| Keys | Does |
|---|---|
| ++ctrl+y++ | Accept the selected item |
| ++ctrl+n++ / ++ctrl+p++ or ++ctrl+j++ / ++ctrl+k++ | Next / previous item |
| ++ctrl+space++ | Open menu / toggle documentation |
| ++ctrl+e++ | Dismiss |
| ++tab++ / ++shift+tab++ | Jump between snippet fields |
| ++ctrl+s++ | Signature help (stock) |

## Buffers and windows

=== "Ours"

    | Keys | Does |
    |---|---|
    | ++shift+h++ / ++shift+l++ | Previous / next buffer. Replaces stock screen top / bottom |
    | ++space++ ++b++ ++b++ | Switch to the other buffer |
    | ++space++ ++b++ ++d++ / ++space++ ++b++ ++o++ | Close buffer / close all others |
    | ++space++ ++b++ ++s++ | Pick a buffer by letter |
    | ++space++ ++b++ ++p++ / ++space++ ++b++ ++shift+p++ | Pin / close every unpinned buffer |
    | ++space++ ++b++ `<` / `>` | Move this buffer left / right in the bar |
    | ++space++ ++1++ … ++5++ / ++space++ ++9++ | Jump to bar position / the last one |
    | ++ctrl+h++ ++ctrl+j++ ++ctrl+k++ ++ctrl+l++ | Move between windows. ++ctrl+l++ no longer redraws; use ++escape++ to clear highlights |
    | ++space++ ++minus++ / ++space++ ++bar++ | Split below / right |
    | ++ctrl+up++ ++ctrl+down++ ++ctrl+left++ ++ctrl+right++ | Resize the window |

=== "Stock"

    | Keys | Does |
    |---|---|
    | ++ctrl+w++ `s` / ++ctrl+w++ `v` | Split below / right |
    | ++ctrl+w++ `h` `j` `k` `l` | Move between windows |
    | ++ctrl+w++ `w` | Cycle windows |
    | ++ctrl+w++ `o` | Close every other window |
    | ++ctrl+w++ `q` | Close this window |
    | ++ctrl+w++ `=` | Make all windows equal |
    | ++ctrl+w++ `_` / ++ctrl+w++ ++bar++ | Maximise height / width |
    | ++ctrl+6++ | Switch to the alternate buffer |
    | `]b` / `[b` | Next / previous buffer |
    | `:e #` / `:ls` | Alternate file / list buffers |

## Git

All ours.

| Keys | Does |
|---|---|
| ++space++ ++g++ ++g++ | Lazygit, full screen |
| `]h` / `[h` | Next / previous changed hunk |
| ++space++ ++g++ ++h++ | Stage hunk (works on a visual selection) |
| ++space++ ++g++ ++shift+h++ | Reset hunk |
| ++space++ ++g++ ++u++ | Undo stage hunk |
| ++space++ ++g++ ++shift+s++ / ++shift+r++ | Stage / reset the whole buffer |
| ++space++ ++g++ ++s++ | Git status picker (fzf — note the lowercase) |
| ++space++ ++g++ ++p++ | Preview hunk inline |
| ++space++ ++g++ ++b++ / ++shift+b++ | Blame this line / the whole buffer |
| ++space++ ++g++ ++d++ / ++shift+d++ | Diff against the index / the last commit |
| ++space++ ++g++ ++c++ / ++shift+c++ | Repo / this file's commit history |
| `ih` | Hunk text object — `vih` selects the hunk you are in |

## AI

All ours. Full detail in [AI workflow](ai.md).

| Keys | Does |
|---|---|
| ++space++ ++a++ ++c++ / ++space++ ++a++ ++f++ | Toggle / focus the Claude split |
| ++space++ ++a++ ++s++ | Send selection — or, in the tree, add that file |
| ++space++ ++a++ ++b++ | Add the current buffer as context |
| ++space++ ++a++ ++r++ / ++space++ ++a++ ++shift+c++ | Resume a session / continue the last one |
| ++space++ ++a++ ++m++ | Select model |
| ++space++ ++a++ ++a++ / ++space++ ++a++ ++d++ | **Accept** / **deny** the proposed diff |
| ++space++ ++a++ ++q++ | Close all diffs |
| ++space++ ++a++ ++question++ | Connection status — is Claude actually attached? |
| ++space++ ++n++ ++n++ / ++space++ ++n++ ++i++ | CodeCompanion chat / inline |
| ++space++ ++n++ ++a++ | CodeCompanion action palette |
| ++space++ ++n++ ++d++ | Add the selection to the CodeCompanion chat |
| ++space++ ++n++ ++c++ | Generate a `:command` from a description |

## Toggles

All ours, under ++space++ ++u++.

| Keys | Does |
|---|---|
| ++space++ ++u++ ++w++ / ++r++ | Wrap / relative line numbers |
| ++space++ ++u++ ++d++ | Diagnostics |
| ++space++ ++u++ ++c++ | Colour swatches |
| ++space++ ++u++ ++t++ | Treesitter context |
| ++space++ ++u++ ++b++ | Inline git blame |
| ++space++ ++u++ ++h++ | Inlay hints |
| ++space++ ++u++ ++i++ | Inspect highlight under cursor |
| ++space++ ++u++ ++m++ | Markdown rendering |

## Markdown

All ours. Only in `markdown` buffers, except ++space++ ++m++ ++p++, which
works anywhere above an `mkdocs.yml`.

| Keys | Does |
|---|---|
| ++space++ ++m++ ++x++ | Toggle checkbox — also over a visual selection |
| ++space++ ++m++ ++t++ | Toggle table mode (<code>&#124;</code> re-aligns as you type) |
| ++space++ ++m++ ++r++ | Realign the table under the cursor |
| ++space++ ++m++ ++shift+t++ | Tableize a selection (CSV → markdown table) |
| ++space++ ++m++ ++p++ | Start/stop `mkdocs serve` and open the browser |

++space++ ++m++ ++x++ cycles `[ ]` → `[x]` → `[ ]` and promotes a plain list
item to a checkbox. It handles `-`, `*`, `+` and `1.` markers, keeps the
indentation, and anchors to the marker, so a `[x]` later in the prose is
never the one toggled. `gd` on a link follows it and `gO` gives a heading
outline; both come from `marksman`.

## Everything else

=== "Ours"

    | Keys | Does |
    |---|---|
    | ++ctrl+backslash++ | Floating terminal |
    | ++space++ ++w++ / ++space++ ++q++ / ++space++ ++shift+q++ | Write / quit / quit **all** |
    | ++escape++ | Clear search highlight |
    | ++s++ / ++shift+s++ | Flash jump / flash treesitter. ++s++ no longer substitutes a character; use `cl` |
    | `r` after an operator | Remote flash: `yr`, jump, then a motion (`iw`) yanks that word and leaves the cursor where it was |
    | ++space++ ++x++ ++q++ | Open the quickfix window |
    | ++ctrl+slash++ (terminal) | Leave terminal mode |
    | ++ctrl+h++ ++ctrl+j++ ++ctrl+k++ ++ctrl+l++ (terminal) | Move straight out to another window |
    | ++space++ ++shift+l++ | Lazy (plugin manager) |
    | ++space++ ++question++ | Bindings for this buffer |
    | ++q++ | Close help, man, quickfix, checkhealth and git-blame windows |

=== "Stock"

    | Keys | Does |
    |---|---|
    | `gx` | Open the URL or file under the cursor |
    | `]q` / `[q` | Next / previous quickfix item (`]l` / `[l` for the location list) |
    | `]<Space>` / `[<Space>` | Add a blank line below / above |
    | ++ctrl+backslash++ ++ctrl+n++ (terminal) | Leave terminal mode |
    | `:noh` | Clear search highlight |
    | `:checkhealth` | Diagnose the setup |
    | `ZZ` / `ZQ` | Write and quit / quit without writing |

## Inside plugin windows

All ours. These only work while the cursor is in that plugin's window.

??? note "File tree (++space++ ++e++)"

    nvim-tree's defaults, with four changes: `l` / `h` open and close like a
    directory browser, `i` shows file info, and ++ctrl+t++ makes a directory the
    tree's root instead of opening it in a tab.

    | Keys | Does |
    |---|---|
    | `l` / ++enter++ | Open the file, or expand the directory |
    | `h` | Collapse the directory, or jump to its parent |
    | ++ctrl+t++ / `-` | Make this directory the root / move the root up |
    | ++ctrl+v++ / ++ctrl+x++ | Open in a vertical / horizontal split |
    | `a` | Create a file. End the name with `/` for a directory |
    | `r` / `d` | Rename / delete (asks first) |
    | `x` / `c` / `p` | Cut / copy / paste |
    | `y` / `Y` / `gy` | Copy the name / relative path / absolute path |
    | `i` | File info: size, dates, path |
    | `H` / `I` / `U` | Toggle dotfiles / gitignored / the hidden-by-name list |
    | `f` / `F` | Filter the tree / clear the filter |
    | `E` / `W` | Expand / collapse everything |
    | `R` | Refresh |
    | `g?` | Every binding |
    | `q` | Close |

    ++space++ ++a++ ++s++ in the tree adds the file under the cursor to Claude's
    context.

??? note "Symbol outline (++space++ ++o++)"

    | Keys | Does |
    |---|---|
    | ++enter++ / `o` | Jump to the symbol |
    | `{` / `}` | Previous / next symbol |
    | `za` | Expand / collapse the symbol under the cursor |
    | `q` / `?` | Close / every binding |

??? note "CodeCompanion chat (++space++ ++n++ ++n++)"

    | Keys | Does |
    |---|---|
    | ++enter++ (normal) / ++ctrl+s++ (insert) | Send the message |
    | `q` (normal) / ++ctrl+c++ (insert) | Close the chat |
    | `?` | Every binding |
