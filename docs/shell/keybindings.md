# Shell key bindings

zsh runs in emacs mode (`bindkey -e`). **Ours** is what `.zshrc` and its
plugins add or rebind. **Stock** is what any zsh does out of the box, so it
works on a server or a colleague's laptop too. bash shares most of the stock
keys, because both copy Emacs.

## Quick reference

=== "Ours"

    | Keys | Does |
    |---|---|
    | ++ctrl+r++ | Fuzzy-search history (fzf). Replaces stock incremental search |
    | ++ctrl+t++ | Insert a file path at the cursor (fzf). Replaces stock transpose-chars |
    | ++alt+c++ | Fuzzy `cd` into a subdirectory (fzf). Replaces stock capitalize-word |
    | ++tab++ | Fuzzy completion with preview (fzf-tab) |
    | ++up++ / ++down++ | Prefix search: type `git`, then ++up++ |
    | ++right++ or ++ctrl+space++ | Accept the grey autosuggestion |
    | ++ctrl+g++ | lazygit. Replaces stock send-break, which ++ctrl+c++ already does |
    | ++ctrl+o++ | lazydocker. Replaces stock accept-line-and-down-history |
    | ++ctrl+left++ / ++ctrl+right++ | Move by word |

=== "Stock"

    | Keys | Does |
    |---|---|
    | ++ctrl+a++ / ++ctrl+e++ | Start / end of line |
    | ++alt+b++ / ++alt+f++ | Back / forward one word |
    | ++ctrl+w++ | Delete the word before the cursor |
    | ++alt+d++ | Delete the word after the cursor |
    | ++ctrl+u++ | Delete the **whole line** (bash: only up to the cursor) |
    | ++ctrl+k++ | Delete to end of line |
    | ++ctrl+y++ | Paste what the last delete removed |
    | ++ctrl+underscore++ | Undo |
    | ++alt+period++ | Insert the last argument of the previous command; repeat to go further back |
    | ++ctrl+q++ | Park the line, run something else, get it back |
    | ++ctrl+l++ | Clear screen |
    | ++ctrl+c++ / ++ctrl+z++ / ++ctrl+d++ | Cancel / suspend / exit (on an empty line) |

## fzf and completion

All ours. Inside any fzf window:

| Keys | Does |
|---|---|
| ++ctrl+j++ / ++ctrl+k++ | Move down / up |
| ++enter++ / ++escape++ | Accept / cancel |
| ++question++ | Toggle preview (in ++ctrl+r++) |
| ++comma++ / ++period++ | Switch completion group (fzf-tab) |

Without fzf, stock ++ctrl+r++ is an incremental search: type part of a
command, press ++ctrl+r++ again for older matches, ++enter++ to run.

## TUIs

All ours. From any prompt, without typing a command. Whatever is half-typed
on the line is still there when you quit.

| Keys | Does |
|---|---|
| ++ctrl+g++ | lazygit, for the repo you're in (same as `lg`) |
| ++ctrl+o++ | lazydocker (same as `ld`) |

## History

=== "Ours"

    | Keys | Does |
    |---|---|
    | ++up++ / ++down++ | Walk only the history that starts with what's typed. Stock walks all of it |
    | ++ctrl+r++ | fzf search of all history |
    | ++alt+right++ | Accept one word of the autosuggestion |

    Prefix a command with a space to keep it out of history
    (`HIST_IGNORE_SPACE`). `HIST_VERIFY` means `!!` and friends expand onto
    the line first, so you see the command before it runs.

=== "Stock"

    | Typed | Expands to |
    |---|---|
    | `!!` | The previous command. `sudo !!` reruns it with sudo |
    | `!$` | The previous command's last argument |
    | `!*` | All of the previous command's arguments |
    | `^old^new` | The previous command with `old` replaced by `new` |
    | `!git` | The most recent command starting with `git` |

    These work the same in bash.

## Jobs

Stock.

| Keys or command | Does |
|---|---|
| ++ctrl+z++ | Suspend the running command |
| `fg` / `bg` | Resume it in the foreground / background |
| `jobs` | List suspended and background jobs |
| `fg %2` | Resume job 2 |
| `cmd &` | Start in the background |

## Navigation

`AUTO_CD`, `..` and `z` are ours; `cd -` is stock. The full list is on
[Aliases and functions](aliases.md#moving-around).

## delta

Ours. Inside a `git diff` or `git show`:

| Keys | Does |
|---|---|
| ++n++ / ++shift+n++ | Next / previous file in the diff |
| ++q++ | Quit the pager |
