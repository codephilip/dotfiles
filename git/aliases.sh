#!/usr/bin/env sh

# ---- Status ----
alias gs="git status -sb"
alias gss="git status"

# ---- Logs ----
alias gl="git log --oneline --decorate"
alias glg="git log --oneline --decorate --graph --all"
alias gla="git log --graph --pretty=format:'%C(auto)%h%d %s %C(black)%C(bold)%cr'"

# ---- Branch ----
alias gb="git branch"
alias gbv="git branch -vv"
alias gbd="git branch -d"

# ---- Checkout / Switch ----
alias gco="git checkout"
alias gcob="git checkout -b"
alias gsw="git switch"
alias gswc="git switch -c"

# ---- Add / Commit ----
alias ga="git add ."
alias gaa="git add -A"
alias gc="git commit"
alias gcm="git commit -m"
alias gca="git commit --amend"
alias gcan="git commit --amend --no-edit"

# ---- Fetch / Pull / Push ----
alias gf="git fetch"
alias gfa="git fetch --all --prune"
alias gp="git pull"
alias gpo="git push origin HEAD"
alias gpm="git push origin main"

# ---- Rebase ----
alias grb="git rebase"
alias grbi="git rebase -i"
alias grbc="git rebase --continue"
alias grba="git rebase --abort"
alias gm="git merge"
# ---- Diff ----
alias gd="git diff"
alias gds="git diff --staged"

# ---- Stash ----
alias gsh="git stash"
alias gshp="git stash pop"
alias gshl="git stash list"

# ---- Cleanup ----
alias gprune="git fetch --prune"
