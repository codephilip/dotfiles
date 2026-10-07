# Kubernetes Commands

k         → kubectl

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
