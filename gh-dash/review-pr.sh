#!/usr/bin/env bash
# Open a PR for review from gh-dash.
#   review-pr.sh <repo-path> <pr-number> <base-branch> <diff|octo|lazygit>
#
# Checks the PR out *detached* in <repo-path> (a dedicated review worktree),
# so it never fights with a branch you have checked out elsewhere — e.g. a
# dev -> main PR while your main clone sits on dev. Inside tmux it opens a
# new window named after the PR; outside tmux it takes over the terminal and
# quitting the tool drops you back in gh-dash.
set -euo pipefail

repo=$1 pr=$2 base=$3 tool=$4

if [[ -n "${TMUX:-}" && -z "${REVIEW_IN_WINDOW:-}" ]]; then
  exec tmux new-window -n "PR $pr" -c "$repo" \
    "REVIEW_IN_WINDOW=1 '$0' '$repo' '$pr' '$base' '$tool' || read -rp 'press enter to close'"
fi

cd "$repo"
git fetch --quiet origin "$base"
gh pr checkout "$pr" --detach

# nvim's review keys (<leader>gv, <leader>gm, <leader>ro) read these.
export REVIEW_PR=$pr REVIEW_BASE=$base

case $tool in
  diff)    exec nvim -c "DiffviewOpen origin/$base...HEAD" ;;
  octo)    exec nvim -c "Octo pr edit $pr" ;;
  lazygit) exec lazygit ;;
  *)       echo "unknown tool: $tool" >&2; exit 2 ;;
esac
