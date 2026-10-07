# Shell key bindings

## fzf

| Keys | Does |
|---|---|
| ++ctrl+r++ | Fuzzy-search command history |
| ++ctrl+t++ | Insert a file path at the cursor |
| ++alt+c++ | Fuzzy `cd` into a subdirectory |
| ++tab++ | Fuzzy completion with preview (fzf-tab) |

Inside any fzf window:

| Keys | Does |
|---|---|
| ++ctrl+j++ / ++ctrl+k++ | Move down / up |
| ++enter++ | Accept |
| ++escape++ | Cancel |
| ++question++ | Toggle preview (in ++ctrl+r++) |
| ++comma++ / ++period++ | Switch completion group (fzf-tab) |

## Autosuggestions

| Keys | Does |
|---|---|
| ++right++ | Accept the whole suggestion |
| ++ctrl+space++ | Accept the whole suggestion |
| ++alt+right++ | Accept one word |

## History

| Keys | Does |
|---|---|
| ++up++ / ++down++ | Prefix search — type `git` first, then ++up++ |
| ++ctrl+r++ | Full fuzzy search |

Prefix a command with a space to keep it out of history entirely
(`HIST_IGNORE_SPACE`).

## Line editing

Emacs bindings (`bindkey -e`).

| Keys | Does |
|---|---|
| ++ctrl+a++ / ++ctrl+e++ | Start / end of line |
| ++ctrl+w++ | Delete word backwards |
| ++ctrl+u++ | Delete to start of line |
| ++ctrl+k++ | Delete to end of line |
| ++ctrl+left++ / ++ctrl+right++ | Move by word |
| ++ctrl+l++ | Clear screen |

## Navigation

`AUTO_CD` is on, so a bare directory name changes into it.

| Command | Does |
|---|---|
| `nvim/` | cd into it — no `cd` needed |
| `..` `...` `....` | up 1, 2, 3 levels |
| `cd -` | previous directory |
| `z <partial>` | jump to a frecent directory |
| `zi` | pick interactively |
| `cdr` | git repo root |

## delta

Inside a `git diff` or `git show`:

| Keys | Does |
|---|---|
| ++n++ / ++shift+n++ | Next / previous file in the diff |
| ++q++ | Quit the pager |
