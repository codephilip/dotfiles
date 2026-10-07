# Docker and Kubernetes

Shell shortcuts for `docker` and `kubectl`, plus [k9s](https://k9scli.io)
for Kubernetes. The aliases live in `~/.config/docker/aliases.sh` and
`~/.config/k8s/aliases.sh`, and `.zshrc` sources both.

Aliases expand into the start of a command, so anything you type after one
is appended: `dlf api` runs `docker logs -f api`, and `kgp -n web -w` runs
`kubectl get pods -n web -w`.

!!! tip "In the terminal"
    `docker-commands` and `k8s-commands` print short versions of these
    tables with `bat`. `alias | grep docker` shows exactly what is defined
    in the current shell.

## Docker

### Containers and images

| Alias | Runs | Example |
|---|---|---|
| `d` | `docker` | `d volume ls` |
| `dps` | `docker ps` | |
| `dpa` | `docker ps -a` | includes stopped containers |
| `dst` | `docker stats` | live CPU / memory per container |
| `di` | `docker images` | |
| `dl` | `docker logs` | `dl api` |
| `dlf` | `docker logs -f` | `dlf api` |
| `dex` | `docker exec -it` | `dex api sh` |
| `db` | `docker build` | `db -t app .` |
| `dr` | `docker run` | `dr --rm -it alpine` |
| `drm` | `docker rm` | |
| `drmi` | `docker rmi` | |

### Compose

| Alias | Runs |
|---|---|
| `dc` | `docker compose` |
| `dcu` | `docker compose up` |
| `dcud` | `docker compose up -d` |
| `dcd` | `docker compose down` |
| `dcb` | `docker compose build` |
| `dcl` | `docker compose logs` |
| `dclf` | `docker compose logs -f` |

### Cleanup

Three levels, each deleting more than the last:

| Command | Runs | Removes |
|---|---|---|
| `dclean` | `docker system prune` | Stopped containers, unused networks, dangling images, build cache. Asks first |
| `dcleanf` | `docker system prune -af` | All of the above plus **every image not used by a running container**. Does not ask |
| `dkclean` | `docker system prune -af --volumes` | All of the above plus **unused volumes**, which is where databases keep their data. Does not ask |

!!! danger "`dkclean` deletes data"
    A Postgres container that is stopped when you run it loses its volume,
    and everything in that database with it. Use `dclean` unless you mean it.

## kubectl

| Alias | Runs |
|---|---|
| `k` | `kubectl` |

### Read

| Alias | Runs |
|---|---|
| `kgp` | `kubectl get pods` |
| `kgs` | `kubectl get svc` |
| `kgd` | `kubectl get deploy` |
| `kgn` | `kubectl get nodes` |
| `kgi` | `kubectl get ingress` |
| `kgcm` | `kubectl get configmap` |
| `kgsec` | `kubectl get secret` |
| `kdp` | `kubectl describe pod` |
| `kdd` | `kubectl describe deploy` |
| `kds` | `kubectl describe svc` |
| `ktp` | `kubectl top pods` |
| `ktn` | `kubectl top nodes` |

`ktp` and `ktn` need metrics-server in the cluster.

### Logs and shells

| Command | Runs | Example |
|---|---|---|
| `kl` | `kubectl logs` | `kl api-7d9f -c sidecar` |
| `klf` | `kubectl logs -f` | `klf deploy/api` |
| `klp` | `kubectl logs -f --previous` | the crashed container's last run |
| `kex` | `kubectl exec -it` | `kex api-7d9f -- env` |
| `ksh` | `kubectl exec -it <args> -- /bin/sh` | `ksh api-7d9f -c sidecar` |
| `kbash` | `kubectl exec -it <args> -- /bin/bash` | `kbash api-7d9f` |

`ksh` and `kbash` are functions, not aliases, so the pod name and any flags
go *before* the `--`. Use `ksh` on distroless or Alpine images, which have no
bash.

### Change things

| Alias | Runs | Example |
|---|---|---|
| `ka` | `kubectl apply -f` | `ka deploy.yaml` |
| `kdel` | `kubectl delete` | `kdel pod api-7d9f` |
| `kro` | `kubectl rollout status` | `kro deploy/api` |
| `kru` | `kubectl rollout undo` | `kru deploy/api` |

### Context and namespace

| Command | Runs | Example |
|---|---|---|
| `kctxs` | `kubectl config get-contexts` | the `*` marks the current one |
| `kctxp` | `kubectl config current-context` | prints just the name |
| `kctx` | `kubectl config use-context` | `kctx staging` |
| `knsa` | `kubectl get ns` | list namespaces |
| `kns` | `kubectl config set-context --current --namespace` | `kns web` |

!!! warning "The prompt does not show the cluster"
    starship's kubernetes module is disabled (see [Shell](shell/index.md#the-prompt)),
    so nothing on screen says which cluster `kdel` is about to hit. Run
    `kctxp` first when it matters.

## k9s

A terminal UI for Kubernetes. Its config lives in `~/.config/k9s` because
`.zshrc` exports `K9S_CONFIG_DIR`. Without that, k9s on macOS reads
`~/Library/Application Support/k9s`. `k9s info` shows which directory it is
using.

What this config changes from the default:

- **Mouse off**, so selecting text in the terminal to copy a pod name works.
- **Logs** tail the last 500 lines (default 100) and **wrap** long lines.
- **No logo**, and no check for a newer release at startup.
- **Colours** come from the active [theme](theming.md). Restart k9s after
  `theme <name>`.

### Custom aliases

From `k9s/aliases.yaml`. Type them after `:`, like any resource name:

| Alias | Resource |
|---|---|
| `:dp` | deployments |
| `:sec` | secrets |
| `:jo` | jobs |
| `:ro` / `:rb` | roles / rolebindings |
| `:cr` / `:crb` | clusterroles / clusterrolebindings |
| `:np` | networkpolicies |

The usual short names (`:po`, `:svc`, `:ns`, `:cm`, `:ing`, `:no`) are
built in. ++ctrl+a++ lists every alias, built-in and custom.

### Keys

These are k9s's own bindings; none are remapped. ++question++ in any view
shows the exact list for that view, and it changes with the resource.

| Keys | Does |
|---|---|
| `:` | Command mode: type a resource or alias (`:po`, `:dp`), `:ctx`, `:ns` |
| `/` | Filter the current list. `/!term` inverts the filter, `/-l app=api` filters by label |
| ++escape++ | Back out of a view, or clear the filter |
| ++question++ | Help for the current view |
| ++ctrl+a++ | List all resource aliases |
| `0` … `9` | Switch namespace. `0` is all namespaces |
| ++enter++ | Drill in: deployment → pods → containers |
| `d` | Describe |
| `y` | YAML |
| `e` | Edit in `$EDITOR` (nvim) |
| ++ctrl+d++ | Delete (asks first) |
| ++ctrl+k++ | Kill: delete with no confirmation |
| ++space++ | Mark a row; actions then apply to every marked row |
| ++ctrl+w++ | Toggle wide columns |
| ++ctrl+z++ | Show only rows in an error state |
| ++shift+n++ / ++shift+a++ | Sort by name / age |
| ++ctrl+c++ or `:q` | Quit |

On pods:

| Keys | Does |
|---|---|
| `l` | Logs |
| `p` | Logs of the previous container: why it crashed |
| `s` | Shell into the container |
| `a` | Attach |
| ++shift+f++ | Port-forward |
| `o` | Jump to the pod's node |
| ++shift+c++ / ++shift+m++ | Sort by CPU / memory |

On deployments and stateful sets: `s` scales and `r` restarts. On secrets,
`x` shows the decoded values.

In the log view:

| Keys | Does |
|---|---|
| `s` | Toggle autoscroll |
| `w` | Toggle wrap (starts on) |
| `t` | Toggle timestamps |
| `f` | Fullscreen |
| `0` … `6` | Time range: tail, head, 1m, 5m, 15m, 30m, 1h |
| `/` | Filter lines |
| ++ctrl+s++ | Save the logs to a file |
