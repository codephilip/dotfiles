# CI and deploys

What happens after the review: checks on the PR, the CI run after the merge, the
deploy it triggers, and the server it lands on. All of it from the terminal,
with `gh`, `curl` and `ssh`. The examples use QuizOS, run from its checkout.

| Question | Command |
|---|---|
| Are the PR's checks green? | `gh pr checks <n> --watch`, or ++space++ ++g++ ++c++ in octo |
| What is running right now? | `gh run list` |
| Follow a run live | `gh run watch <id> --exit-status` |
| Why did it fail? | `gh run view <id> --log-failed` |
| Is the site up? | `curl -s https://api.quizos.io/healthz` |
| What is it doing on the server? | `ssh root@<server>`, then `docker compose ps` / `logs -f` |
| Put an older commit back | `gh workflow run Deploy --ref main -f ref=<sha> -f environment=dev` |

## The QuizOS pipeline

```text
push to dev   → CI (tests, lint, images to GHCR) → Deploy, environment dev        → dev-api.quizos.io
push to main  → CI                               → Deploy, environment Production → api.quizos.io, quizos.io
```

CI and Deploy are **two separate runs**. Deploy starts only when CI finishes
green on a push, so a merge shows up as CI first and Deploy a few minutes later.
Pull-request CI runs never deploy.

!!! warning "Deploy runs say `main` even when they deploy `dev`"
    Deploy is triggered by `workflow_run`, and GitHub runs those from the
    default branch. So `gh run list` shows `main` as the branch for *every*
    automatic deploy, and `--branch dev` finds only the ones you started by hand.
    The commit actually deployed is in the log: `deploy.sh` prints
    `pull ghcr.io/quantdesigns/quizos:<sha>`.

## Before merging: PR checks

```bash
gh pr checks 55                    # one line per check, pass/fail/pending
gh pr checks 55 --watch --fail-fast  # wait; exit on the first failure
gh pr checks --watch               # the PR for the branch you're on
```

In octo's PR buffer, ++space++ ++g++ ++c++ opens a check and ++space++ ++t++
++c++ folds the list. See [Plugins → PR review](plugins.md#pr-review). gh-dash's
preview pane shows the same checks next to the diff.

## After merging: follow the run

```bash
gh run list --limit 5              # every workflow, newest first
gh run list --workflow CI --limit 5
gh run list --workflow Deploy --limit 5
gh run watch                       # pick a running run from a list
gh run watch <id> --exit-status --compact  # only the step that matters; non-zero on failure
```

To watch CI for the commit you just pushed, without looking up an id:

```bash
gh run watch --exit-status "$(gh run list --commit "$(git rev-parse HEAD)" \
  --workflow CI --json databaseId -q '.[0].databaseId')"
```

`--commit` wants the **full** SHA, which is why it goes through
`git rev-parse`. A short one returns nothing.

!!! tip "Let it tell you"
    Run the watch in a tmux split and get on with something else. Chain a
    notification on the end so you hear about it either way:

    ```bash
    gh run watch <id> --exit-status \
      && osascript -e 'display notification "green" with title "CI"' \
      || osascript -e 'display notification "FAILED" with title "CI"'
    ```

## When it fails: logs and reruns

```bash
gh run view <id>                   # jobs and steps, with ✓ / X
gh run view <id> --log-failed      # only the failing steps' output
gh run view <id> --log | less -R   # everything
gh run view <id> --web             # give up and open the browser

gh run rerun <id> --failed         # rerun only the failed jobs (a flaky test)
gh run rerun <id> --failed --debug # same, with runner debug logging
```

`--log-failed` is the one to reach for. It cuts a 2,000-line log down to the
step that broke.

## Is it live?

The last step of Deploy polls each URL for up to 2.5 minutes, so a green Deploy
already means they answered 200. To check yourself:

```bash
curl -s https://api.quizos.io/healthz          # {"ok":true,...}
curl -s https://dev-api.quizos.io/healthz
curl -s -o /dev/null -w '%{http_code} %{time_total}s\n' https://quizos.io/

# Wait for it to come back
until curl -sf https://api.quizos.io/healthz >/dev/null; do sleep 5; done; echo up
```

`/healthz` says the API is up, not which commit it is running. For that, look
at the deploy log or the server (below).

## On the server

Production is `quizos-prod-1` (`5.78.215.99`), dev is `quizos-dev`
(`167.233.58.60`). Everything lives in `/opt/quizos`, run by Docker Compose.

```bash
ssh root@5.78.215.99
cd /opt/quizos/deploy

docker compose ps                         # every container, its state and health
docker compose logs -f --tail=100 api     # follow one service
docker compose logs --since=10m           # everything from the last 10 minutes
docker image ls 'ghcr.io/quantdesigns/*'  # pulled images; the tag is the commit
```

Or one-off, without a shell on the box:

```bash
ssh root@5.78.215.99 'cd /opt/quizos/deploy && docker compose ps'
```

!!! warning "Look, don't fix"
    The server is rebuilt from the repo on every deploy. A change made by hand
    under `/opt/quizos/deploy` is gone on the next one. The exception is
    `/opt/quizos/.env`, which is copied by hand and drifts if you forget.

## Redeploying and rolling back

Deploy can be started by hand with any commit CI has built (on `main` or `dev`,
so its images exist):

```bash
gh workflow run Deploy --ref main -f ref=<sha> -f environment=dev
gh workflow run Deploy --ref main -f ref=<sha> -f environment=Production
gh run list --workflow Deploy --limit 1   # then watch it as above
```

Find the commit to go back to with `git log --oneline origin/main`, or take it
from the previous Deploy's log.

!!! warning "Leave `release_email_from` empty on a rollback"
    Deploy has a release-email input for Production. Empty means no email, and
    the dry-run flag defaults to on. A plain rollback should never set either.

## Putting it together

```text
gh dash → review (PR review page) → approve
  └─ gh pr checks <n> --watch       green? merge (<space>pm in octo)
       └─ gh run watch              CI on the merge commit
            └─ gh run watch         Deploy, a few minutes later
                 ├─ green  → curl …/healthz to see it yourself
                 └─ red    → gh run view <id> --log-failed
                              ├─ flaky → gh run rerun <id> --failed
                              └─ real  → ssh, docker compose logs, fix, push
```
