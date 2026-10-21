# PR review

Reviewing a pull request without leaving the terminal. The pieces are:

| Piece | Role | Config |
|---|---|---|
| **gh-dash** | Inbox: PRs waiting on you, with a delta preview | `gh-dash/config.yml` |
| **`review-pr.sh`** | Checks the PR out and opens the right tool | `gh-dash/review-pr.sh` |
| **diffview.nvim** | Read the change: whole branch, or commit by commit | `nvim/lua/plugins/review.lua` |
| **octo.nvim** | Talk back: inline comments, suggestions, approve | `nvim/lua/plugins/review.lua` |
| **review mode** | Gutter and file tree show the branch, not just the dirty tree | `nvim/lua/config/review.lua` |

Every key is listed in [Plugins → PR review](plugins.md#pr-review). This page
covers how the pieces fit together.

## From gh-dash

`gh dash` opens with three PR sections: *My Pull Requests*, *Needs My Review*
and *Involved*. On a highlighted PR:

| Key | Opens |
|---|---|
| `N` | nvim in **diffview**, branch vs its base |
| `O` | nvim in **octo**, the PR buffer, ready to comment |
| `L` | **lazygit** on the checkout |

All three run `review-pr.sh <repo> <pr> <base> <tool>`, which:

1. Inside tmux, opens a new window called `PR <n>` and re-runs itself there, so
   gh-dash stays put. Outside tmux it takes over the terminal, and quitting drops
   you back into gh-dash.
2. `cd`s into the repo's **review worktree**, not your working clone (see below).
3. Fetches the base and runs `gh pr checkout <n> --detach`.
4. Exports `REVIEW_PR` and `REVIEW_BASE` so nvim's review keys know what they are
   looking at.
5. Runs `nvim -c "DiffviewOpen origin/<base>...HEAD"`, `nvim -c "Octo pr edit <n>"`,
   or `lazygit`.

!!! note "Why a separate worktree, and why detached"
    A PR checkout in your main clone would fight with whatever you have checked
    out there. For example, a `dev → main` PR while you're sitting on `dev`.
    `repoPaths` in `gh-dash/config.yml` points each repo at a dedicated worktree:

    ```bash
    git -C ~/quizos/quizos worktree add --detach ~/quizos/quizos-review origin/main
    ```

    Detached checkout means no local branch is created, so nothing piles up.
    It also means octo can't infer the PR from the branch name, which is why
    `REVIEW_PR` exists.

    Add a line to `repoPaths` for each new repo you review this way.

## Reading the change: diffview

| Keys | View |
|---|---|
| ++space++ ++g++ ++v++ | Everything the branch changed, as one diff (`base...HEAD`) |
| ++space++ ++g++ ++m++ | The branch's commits, one at a time (`base..HEAD`) |
| ++space++ ++g++ ++f++ | Every commit that touched the current file |
| `q` / ++space++ ++g++ ++x++ | Close |

Base resolution: `origin/$REVIEW_BASE` if gh-dash set it, otherwise origin's
default branch (`origin/HEAD`), otherwise `origin/main`.

Inside, ++tab++ / ++shift+tab++ walk the files and `gf` opens the real file.
Use `g?` for the rest.

!!! tip "Whole branch first, then commits"
    ++space++ ++g++ ++v++ to see what the PR *does*. Then switch to
    ++space++ ++g++ ++m++ if the history tells a story worth following, or when
    one commit is a mechanical rename you want to skip.

!!! warning "`]c` doesn't jump to the next change here"
    treesitter-textobjects maps `]c` / `[c` globally to "next class", and that
    wins in diff windows too. Use ++tab++ to move between files. See
    [Known clashes](plugins.md#known-clashes).

## Talking back: octo

You can start from gh-dash with `O`, or from inside any review with
++space++ ++r++ ++o++.

1. **++space++ ++r++ ++s++** starts a review. octo opens its own diff tab with
   the changed-files panel.
2. Walk the files with `]q` / `[q`, or `]u` to jump straight to the next file you
   haven't marked viewed. ++space++ ++space++ marks a file viewed.
3. On a line, or a visual range: **++space++ ++c++ ++a++** for a comment,
   **++space++ ++s++ ++a++** for a GitHub suggestion block. Write it and `:w`.
4. `]t` / `[t` jumps between threads, yours and other reviewers'.
5. **++space++ ++v++ ++s++** opens the submit window. There, ++ctrl+a++ approves,
   ++ctrl+m++ comments, and ++ctrl+r++ requests changes.

Left halfway? ++space++ ++r++ ++r++ (or ++space++ ++v++ ++r++ inside the PR
buffer) resumes the pending review. ++space++ ++r++ ++c++ reviews a single
commit instead of the whole PR.

In the PR buffer itself you can also reply to threads (++space++ ++c++ ++r++),
resolve them (++space++ ++r++ ++t++), check CI (++space++ ++g++ ++c++), and merge
(++space++ ++p++ ++m++).

!!! warning "++space++ ++r++ means two things"
    In octo's PR buffer, `<localleader>r…` is emoji reactions, and localleader
    is ++space++. So ++space++ ++r++ ++r++ there adds a 🚀 rather than resuming
    your review. Use ++space++ ++v++ ++r++ inside octo buffers.

## Review mode

Diffview is a separate tab. Sometimes you want to read the PR in the *normal*
editor instead, with LSP, `gd` and the whole tree, but still see what changed.
gitsigns and nvim-tree both compare against the index by default, so on a
checked-out PR with nothing uncommitted they show **nothing**.

**++space++ ++g++ ++r++** toggles review mode:

- Finds the merge-base of `HEAD` with origin's default branch.
- gitsigns rebases its gutter onto it and turns on word diff. Every line the PR
  touched gets a sign, and `]h` / `[h` walk them.
- nvim-tree marks every file the branch added (`A`), modified (`M`), renamed
  (`R`) or deleted (`D`), and tints its parent folders. Untracked files count as
  added.
- The changed-file set is rescanned on every save.

++space++ ++g++ ++l++ adds full-line highlighting on top, which helps when
skimming. Press ++space++ ++g++ ++r++ again to go back to diffing against the
index.

!!! note "Review mode uses origin's default branch, not `REVIEW_BASE`"
    `config/review.lua` resolves the base on its own and ignores `REVIEW_BASE`.
    For a PR into anything other than the default branch (say `feature → dev`),
    diffview shows the right diff and review mode shows a bigger one.

## Putting it together

```text
gh dash
  └─ N on a PR        → new tmux window, detached checkout, diffview
       ├─ read it whole (already open), then <space>gm for commits
       ├─ q, then <space>gr  → review mode: browse with LSP, gutter shows the PR
       └─ <space>ro → octo PR buffer
            └─ <space>rs → comment with <space>ca / <space>sa → <space>vs → ^A
```

Claude fits in here too. In review mode, `vaf` on a function you don't follow
followed by ++space++ ++a++ ++s++ hands exactly that to Claude. See
[AI workflow](ai.md).
