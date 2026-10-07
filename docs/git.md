# Git

git, its pager delta, lazygit and the GitHub CLI. git is configured in
`~/.config/git/gitconfig`, symlinked from `~/.gitconfig`. The aliases live in
`~/.config/git/aliases.sh`, which `.zshrc` sources. lazygit and gh run on
their defaults.

**Ours** is what this repo adds; **Stock** works on any machine with git
installed, such as a server or a colleague's laptop. Pick a tab once and
every page follows.

## Quick reference

=== "Ours"

    | Type | Does |
    |---|---|
    | `gs` | Short status, with the branch line |
    | `gd` / `gds` | Unstaged diff / staged diff |
    | `gaa` then `gcm "msg"` | Stage everything, commit |
    | `gcan` | Fold staged changes into the last commit |
    | `gsw` / `gswc` | Switch branch / create and switch |
    | `fbr` | Fuzzy-switch branch |
    | `gp` | **Pull** (rebases, because of `pull.rebase`) |
    | `gpo` | Push the current branch |
    | `glg` | Graph of all branches |
    | `lg`, or ++ctrl+g++ at any prompt | lazygit |
    | ++space++ ++g++ ++g++ | lazygit inside Neovim |
    | `cdr` | Jump to the repo root |
    | `git-commands` | The cheatsheet, in the terminal |

=== "Stock"

    | Type | Does |
    |---|---|
    | `git status -sb` | Short status |
    | `git diff` / `git diff --staged` | Unstaged / staged changes |
    | `git add -A` then `git commit -m "msg"` | Stage everything, commit |
    | `git commit --amend --no-edit` | Fold staged changes into the last commit |
    | `git switch <branch>` / `git switch -c <new>` | Switch / create and switch |
    | `git switch -` | Back to the previous branch |
    | `git restore <file>` | Throw away unstaged changes to a file |
    | `git restore --staged <file>` | Unstage, keeping the changes |
    | `git reset --soft HEAD~1` | Undo the last commit, keeping its changes staged |
    | `git stash` / `git stash pop` | Shelve changes / bring them back |
    | `git reflog` | Every commit `HEAD` has been on. How you find "lost" work |
    | `git log --oneline --graph --all` | Graph of all branches |
    | `gh pr create --fill` | Open a PR from the current branch |

## git

### Settings

Ours. These change what git *does*, not just how it looks.

| Setting | Effect |
|---|---|
| `pull.rebase = true` | Pulls rebase instead of creating merge commits |
| `push.autoSetupRemote = true` | `git push` on a new branch works without `--set-upstream` |
| `merge.conflictstyle = zdiff3` | Conflict markers include the common ancestor, so you can see what each side changed rather than guessing |
| `rerere.enabled = true` | Git remembers how you resolved a conflict and replays it. Earns its keep during long rebases |
| `diff.colorMoved = default` | Moved code is coloured differently from added or removed code, which makes refactors readable |
| `init.defaultBranch = main` | — |
| `core.excludesfile` | `~/.config/git/ignore`, the global ignore file |

On a machine without this config, the first two are the ones you'll notice:
`git pull` may merge, and the first push of a branch needs
`git push -u origin HEAD`.

### Commands

=== "Ours"

    Defined in `git/aliases.sh`. Anything typed after an alias is appended:
    `gcm "fix typo"` runs `git commit -m "fix typo"`.

    | Alias | Runs |
    |---|---|
    | `gs` / `gss` | `git status -sb` / `git status` |
    | `gl` | `git log --oneline --decorate` |
    | `glg` | The same, as a graph of **all** branches |
    | `gla` | A graph with relative commit dates |
    | `gd` / `gds` | `git diff` / `git diff --staged` |
    | `ga` | `git add .`: the current directory down |
    | `gaa` | `git add -A`: the whole repo, deletions included |
    | `gc` / `gcm` | `git commit` / `git commit -m` |
    | `gca` / `gcan` | `git commit --amend` / `--amend --no-edit` |
    | `gb` / `gbv` / `gbd` | `git branch` / `-vv` (upstream, ahead/behind) / `-d` |
    | `gsw` / `gswc` | `git switch` / `git switch -c` |
    | `gco` / `gcob` | `git checkout` / `git checkout -b` |
    | `gm` | `git merge` |
    | `gf` / `gfa` / `gprune` | `git fetch` / `--all --prune` / `--prune` |
    | `gp` | `git pull` |
    | `gpo` / `gpm` | `git push origin HEAD` / `git push origin main` |
    | `grb` / `grbi` | `git rebase` / `git rebase -i` |
    | `grbc` / `grba` | `git rebase --continue` / `--abort` |
    | `gsh` / `gshp` / `gshl` | `git stash` / `pop` / `list` |

    Functions in `.zshrc`: `fbr` fuzzy-switches branch (local and remote),
    `cdr` jumps to the repo root.

    !!! warning "`gp` is pull, not push"
        Push is `gpo`. And `gpm` pushes to `main` directly, whatever branch
        you are on.

=== "Stock"

    | Command | Does |
    |---|---|
    | `git log -p -- <file>` | Every change to one file, with diffs |
    | `git log -S '<text>'` | Commits that added or removed `<text>` |
    | `git blame -L 10,20 <file>` | Who last touched lines 10–20 |
    | `git show <commit>` | One commit, with its diff |
    | `git cherry-pick <commit>` | Copy a commit onto the current branch |
    | `git commit --fixup <commit>` | A commit marked to fold into `<commit>` … |
    | `git rebase -i --autosquash <base>` | … which this then squashes in place |
    | `git stash push -m "msg" <path>` | Stash just some files, with a label |
    | `git worktree add ../hotfix main` | Check out a second branch in another directory, without stashing |
    | `git worktree list` / `remove <path>` | See / drop worktrees |

    ??? note "Undo and rescue"

        | Situation | Command |
        |---|---|
        | Unstage a file | `git restore --staged <file>` |
        | Discard changes to a file | `git restore <file>` |
        | Undo the last commit, keep the work | `git reset --soft HEAD~1` |
        | A rebase or reset went wrong | `git reflog`, find the entry before it, `git reset --hard HEAD@{n}` |
        | Deleted a branch by mistake | `git reflog`, then `git switch -c <name> <hash>` |
        | Abandon a merge or rebase in progress | `git merge --abort` / `git rebase --abort` |

    ??? note "Finding the commit that broke something: bisect"

        ```bash
        git bisect start
        git bisect bad              # the current commit is broken
        git bisect good v1.4        # this one was fine
        # git checks out a commit halfway; test it, then say:
        git bisect good             # or: git bisect bad
        # repeat until it names the first bad commit
        git bisect reset            # back to where you started
        ```

## delta

All diffs go through [delta](https://github.com/dandavison/delta), both
`git diff` and `git add -p`.

=== "Ours"

    | Setting | Effect |
    |---|---|
    | `core.pager = delta` | Every diff, log and show goes through delta |
    | `interactive.diffFilter = delta --color-only` | `git add -p` is highlighted too |
    | `side-by-side`, `line-numbers` | Two columns, numbered |
    | `navigate = true` | Turns on the ++n++ / ++shift+n++ keys |
    | `hyperlinks = true` | File names are clickable in Ghostty |
    | Colours | Follow the active [theme](theming.md), via the generated `git/theme.gitconfig` |

=== "Stock"

    delta pages through `less`, so the usual `less` keys apply.

    | Keys | Does |
    |---|---|
    | ++n++ / ++shift+n++ | Next / previous file (needs `navigate`) |
    | ++space++ / ++b++ | Page down / up |
    | ++slash++ | Search |
    | ++q++ | Quit |

## lazygit

A terminal UI for everything git does. Use it for staging hunks, interactive
rebases and anything where seeing the graph helps.

=== "Ours"

    No config: lazygit runs on its defaults, so it behaves the same
    everywhere. What's ours is how you open it.

    | Keys | Opens |
    |---|---|
    | `lg` | lazygit, for the repo you're in |
    | ++ctrl+g++ at any prompt | The same, keeping whatever you'd half-typed. Replaces zsh's `send-break`, which ++ctrl+c++ already does |
    | ++space++ ++g++ ++g++ in Neovim | lazygit in a floating terminal. The gutter refreshes when you quit |

=== "Stock"

    ++question++ lists the keys for the panel you're in. That's the only one
    to remember.

    | Keys | Does |
    |---|---|
    | `1` … `5` | Jump to a panel: status, files, branches, commits, stash |
    | ++tab++ / ++left++ ++right++ | Next panel |
    | `[` / `]` | Previous / next tab within a panel |
    | ++space++ | Stage or unstage a file. In branches: check out |
    | ++enter++ | Go into a file to stage single lines or hunks |
    | `a` | Stage or unstage everything |
    | `c` | Commit. `C` writes the message in your editor |
    | `A` | Amend the last commit |
    | `p` / `P` | Pull / push |
    | `n` | New branch |
    | `s` | Files: stash. Commits: squash into the one below |
    | `r` | Commits: reword. Branches: rebase onto it |
    | `e` | Commits: start an interactive rebase from here |
    | `d` | Discard (files) or delete (branches, stash) |
    | `z` / `Z` | Undo / redo, via the reflog |
    | `/` | Search the current panel |
    | `q` | Quit |

## gh

The GitHub CLI. Stock: `gh/config.yml` is gh's own default file, which
already includes the `gh co` alias for `gh pr checkout`. Sign in once per
machine with `gh auth login`; the token goes to the keychain.

| Command | Does |
|---|---|
| `gh pr create --fill` | Open a PR, title and body from the commits. `--draft` for a draft |
| `gh pr status` | Your PRs, and the ones waiting on your review |
| `gh pr list` | Open PRs in this repo |
| `gh pr view --web` | Open the current branch's PR in the browser |
| `gh pr checkout 123`, or `gh co 123` | Check out a PR locally |
| `gh pr checks --watch` | Wait for CI on the current PR |
| `gh pr merge --squash --delete-branch` | Squash-merge and clean up |
| `gh run list` / `gh run watch` | Recent workflow runs / follow one live |
| `gh repo clone owner/name` | Clone |
| `gh browse` | Open the repo in the browser |

## In Neovim

Ours. gitsigns handles hunks inline; lazygit handles everything else.

| Keys | Does |
|---|---|
| ++space++ ++g++ ++g++ | lazygit, in a floating terminal |
| `]h` / `[h` | Next / previous hunk |
| ++space++ ++g++ ++h++ | Stage hunk |
| ++space++ ++g++ ++b++ | Blame line |
| ++space++ ++g++ ++c++ | Commit history |

Full list in [Neovim key bindings](neovim/keybindings.md#git).
