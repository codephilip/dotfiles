# Git Commands

g         → git  (so g st = git status, and any git command works: g push, g stash)
lg        → lazygit (TUI: ? lists keys, q quits)
Ctrl-G    → lazygit, straight from the prompt

## Status
g st      → status
g s       → short status (status -sb)

## Logs
g l       → oneline log
g lg      → graph log, all branches
g la      → pretty graph log (relative dates)

## Branch
g br      → list branches
g brv     → branches with upstream
g br -d   → delete branch

## Checkout / Switch
g co      → checkout
g cob     → checkout new branch
g sw      → switch
g swc     → switch new branch

## Add / Commit
g a .     → add current dir
g aa      → add everything (add -A)
g ci      → commit
g cm "x"  → commit -m
g ca      → amend
g can     → amend, keep message

## Fetch / Pull / Push
g f       → fetch
g fa      → fetch all + prune
g pl      → pull
g po      → push origin HEAD
g pm      → push origin main

## Rebase / Merge
g rb      → rebase
g rbi     → interactive rebase
g rbc     → rebase continue
g rba     → rebase abort
g m       → merge

## Diff
g d       → diff
g ds      → diff staged

## Stash
g stash   → stash
g sp      → stash pop
g sl      → stash list
