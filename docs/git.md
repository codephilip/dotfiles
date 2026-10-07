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

## Aliases

Defined in `~/.config/git/aliases.sh`, which `.zshrc` sources. Anything typed
after an alias is appended: `gcm "fix typo"` runs `git commit -m "fix typo"`.

### Status and history

| Alias | Runs |
|---|---|
| `gs` | `git status -sb`: short, with the branch line |
| `gss` | `git status` |
| `gl` | `git log --oneline --decorate` |
| `glg` | The same, as a graph of **all** branches |
| `gla` | A graph with relative commit dates |
| `gd` | `git diff`: unstaged changes |
| `gds` | `git diff --staged`: what is about to be committed |

### Branches

| Alias | Runs |
|---|---|
| `gb` | `git branch` |
| `gbv` | `git branch -vv`: shows each branch's upstream and ahead/behind |
| `gbd` | `git branch -d` |
| `gsw` / `gswc` | `git switch` / `git switch -c` |
| `gco` / `gcob` | `git checkout` / `git checkout -b` |
| `gm` | `git merge` |

### Commit

| Alias | Runs |
|---|---|
| `ga` | `git add .`: the current directory down |
| `gaa` | `git add -A`: the whole repo, deletions included |
| `gc` | `git commit` |
| `gcm` | `git commit -m` |
| `gca` | `git commit --amend` |
| `gcan` | `git commit --amend --no-edit`: fold staged changes into the last commit |

### Sync

| Alias | Runs |
|---|---|
| `gf` | `git fetch` |
| `gfa` / `gprune` | `git fetch --all --prune` / `git fetch --prune` |
| `gp` | `git pull` (a rebase, because of `pull.rebase`) |
| `gpo` | `git push origin HEAD`: push the current branch |
| `gpm` | `git push origin main` |

!!! warning "`gp` is pull, not push"
    Push is `gpo`. And `gpm` pushes to `main` directly, whatever branch you are
    on.

### TUI

| Alias | Runs |
|---|---|
| `lg` | `lazygit`. The same tool as ++space++ ++g++ ++g++ in Neovim |

### Rebase and stash

| Alias | Runs |
|---|---|
| `grb` / `grbi` | `git rebase` / `git rebase -i` |
| `grbc` / `grba` | `git rebase --continue` / `--abort` |
| `gsh` | `git stash` |
| `gshp` | `git stash pop` |
| `gshl` | `git stash list` |
