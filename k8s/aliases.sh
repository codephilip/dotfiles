# Base
alias k='kubectl'

# Get
alias kgp='kubectl get pods'
alias kgs='kubectl get svc'
alias kgd='kubectl get deploy'
alias kgn='kubectl get nodes'
alias kgi='kubectl get ingress'
alias kgcm='kubectl get configmap'
alias kgsec='kubectl get secret'

# Describe
alias kdp='kubectl describe pod'
alias kdd='kubectl describe deploy'
alias kds='kubectl describe svc'

# Logs
alias kl='kubectl logs'
alias klf='kubectl logs -f'
alias klp='kubectl logs -f --previous'

# Exec
alias kex='kubectl exec -it'
alias ksh='kubectl exec -it -- /bin/sh'
alias kbash='kubectl exec -it -- /bin/bash'

# Apply / Delete
alias ka='kubectl apply -f'
alias kdel='kubectl delete'

# Context / Namespace
alias kctx='kubectl config use-context'
alias kctxs='kubectl config get-contexts'
alias kns='kubectl config set-context --current --namespace'
alias knsa='kubectl get ns'

# Rollout
alias kro='kubectl rollout status'
alias kru='kubectl rollout undo'

# Metrics
alias ktp='kubectl top pods'
alias ktn='kubectl top nodes'
