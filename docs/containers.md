# Docker and Kubernetes

Shell shortcuts for `docker` and `kubectl`, plus two TUIs:
[lazydocker](https://github.com/jesseduffield/lazydocker) for Docker and
[k9s](https://k9scli.io) for Kubernetes. The aliases live in `~/.config/docker/aliases.sh` and
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

## lazydocker

A terminal UI for Docker: containers, images, volumes and networks in one
screen, with logs, stats and env for whatever is selected. Run `lazydocker`,
or `ld`. Start it inside a directory with a Compose file and it also shows
that project's services.

Use the aliases above for scripting and one-off commands. Use lazydocker when
you're looking around: what's running, what died, and why.

Its config lives in `~/.config/lazydocker/config.yml`. lazydocker on macOS
would otherwise read `~/Library/Application Support/lazydocker`, so
`lazydocker` is a shell function that points it at the repo copy. `type
lazydocker` should say "shell function"; if it says a file path, the function
isn't loaded and your config is being ignored.

What this config changes from the default:

- **Logs** show the last 500 lines. The default is the last 60 minutes, which
  leaves the pane empty for a container that crashed earlier than that.
- **Colours** aren't set. lazydocker uses ANSI colour names, so it follows the
  terminal's [theme](theming.md) without a generated file.

### Moving around

| Keys | Does |
|---|---|
| `1` … `6` | Jump to a panel: projects, services, containers, images, volumes, networks |
| ++up++ ++down++ | Move through the list |
| ++left++ ++right++ | Previous / next panel |
| `[` / `]` | Previous / next tab on the right: logs, stats, env, config, top |
| ++enter++ | Focus the right-hand panel, to scroll it |
| `/` | Filter the list |
| `+` / `_` | Make the right-hand panel bigger / smaller: normal, half, fullscreen |
| `x` | Every key for the current panel |
| ++escape++ | Back |
| `q` | Quit |

### Containers (`3`)

| Keys | Does |
|---|---|
| `m` | Follow the logs full-screen; ++ctrl+c++ to return |
| `E` | Shell into the container |
| `a` | Attach |
| `s` / `r` | Stop / restart |
| `p` | Pause / unpause |
| `d` | Remove (asks first) |
| `e` | Hide / show stopped containers |
| `w` | Open the first published port in the browser |
| `b` | Bulk commands, such as removing every stopped container |

### Compose services (`2`)

| Keys | Does |
|---|---|
| `u` / `U` | Up this service / up the whole project |
| `S` / `s` | Start / stop |
| `r` / `R` | Restart / restart options: rebuild, recreate |
| `D` | Down the whole project |
| `d` | Remove the service's containers |
| `m` | Follow the logs |
| `E` | Shell into the service's container |

On the images and volumes panels, `d` removes the selected one and `b` offers
bulk commands, including prune.

!!! warning "`b` → down with volumes"
    The services panel's bulk menu includes "down with volumes", which is the
    lazydocker equivalent of `dkclean` for one project. It deletes the
    project's database data.

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
