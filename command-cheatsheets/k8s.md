# Kubernetes Commands

k         → kubectl
k9s       → cluster TUI (? lists keys, :q quits) — see k9s below

## Get
kgp       → get pods
kgs       → get services
kgd       → get deployments
kgn       → get nodes
kgi       → get ingress
kgcm      → get configmaps
kgsec     → get secrets

## Describe
kdp       → describe pod
kdd       → describe deployment
kds       → describe service

## Logs
kl        → logs
klf       → follow logs
klp       → previous container logs

## Exec
kex       → exec -it
ksh <pod> → sh in the pod   (ksh <pod> -c <container>)
kbash <pod> → bash in the pod

## Apply / Delete
ka        → apply -f
kdel      → delete

## Context / Namespace
kctx      → use context
kctxs     → list contexts
kctxp     → print current context
kns       → set namespace
knsa      → list namespaces

## Rollouts
kro       → rollout status
kru       → rollout undo

## Metrics
ktp       → top pods
ktn       → top nodes

## k9s
Config: ~/.config/k8s/k9s  (K9S_CONFIG_DIR, set in .zshrc)
k9s info  → confirm which config it actually loaded

:po :svc :ns :cm :ing :no  → jump to a resource (built in)
:dp :sec :jo               → deployments / secrets / jobs
:ro :rb :cr :crb           → roles / rolebindings / clusterroles / -bindings
:np                        → networkpolicies
:ctx                       → switch context
Ctrl-a                     → list every alias
0 … 9                      → switch namespace (0 = all)

/term     → filter   (/!term inverts, /-l app=api by label)
Esc       → back out / clear filter
l         → logs
p         → logs of the previous (crashed) container
s         → shell into the pod
d         → describe
y         → YAML
e         → edit
Ctrl-d    → delete
?         → help for this view
