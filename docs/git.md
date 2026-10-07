# Git

Configured in `~/.config/git/gitconfig`, symlinked from `~/.gitconfig`.

## delta

All diffs route through [delta](https://github.com/dandavison/delta): side-by-side,
syntax-highlighted, with line numbers.

```ini
[core]
  pager = delta
[interactive]
  diffFilter = delta --color-only
[delta]
  navigate = true
  line-numbers = true
  side-by-side = true
  syntax-theme = tokyonight_night
```

++n++ and ++shift+n++ move between files inside a diff.

## Behavioural settings

These change what git *does*, not just how it looks.

| Setting | Effect |
|---|---|
| `merge.conflictstyle = zdiff3` | Conflict markers include the common ancestor, so you can see what each side changed rather than guessing |
| `diff.colorMoved = default` | Moved code is coloured differently from added/removed — large refactors become readable |
| `push.autoSetupRemote = true` | `git push` on a new branch works without `--set-upstream` |
| `pull.rebase = true` | Pulls rebase instead of creating merge commits |
| `rerere.enabled = true` | Git remembers how you resolved a conflict and replays it |
| `init.defaultBranch = main` | — |

!!! tip "`rerere` earns its keep during long rebases"
    Resolve a conflict once; git replays the resolution every time the same
    conflict reappears.

## Ignore

`~/.config/git/ignore` is the global excludes file.

## In Neovim

gitsigns handles hunks inline; lazygit handles everything else.

| Keys | Does |
|---|---|
| ++space++ ++g++ ++g++ | Lazygit (in a floating terminal) |
| `]h` / `[h` | Next / previous hunk |
| ++space++ ++g++ ++h++ | Stage hunk |
| ++space++ ++g++ ++b++ | Blame line |
| ++space++ ++g++ ++c++ | Commit history |

Full list in [Neovim key bindings](neovim/keybindings.md#git).

## In the shell

| Command | Does |
|---|---|
| `fbr` | fuzzy-switch branch |
| `cdr` | jump to repo root |
| `git-commands` | the cheatsheet |

Aliases live in `~/.config/git/aliases.sh`, sourced from `.zshrc`.
