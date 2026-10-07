# Base
alias d='docker'
alias dc='docker compose'

# Containers
alias dps='docker ps'
alias dpa='docker ps -a'
alias dst='docker stats'

# Images
alias di='docker images'

# Logs / Exec
alias dl='docker logs'
alias dlf='docker logs -f'
alias dex='docker exec -it'

# Build / Run
alias db='docker build'
alias dr='docker run'
alias drm='docker rm'
alias drmi='docker rmi'

# Compose
alias dcu='docker compose up'
alias dcud='docker compose up -d'
alias dcd='docker compose down'
alias dcb='docker compose build'
alias dcl='docker compose logs'
alias dclf='docker compose logs -f'

# Cleanup (explicit)
alias dclean='docker system prune'
alias dcleanf='docker system prune -af'

# TUI
# lazydocker ignores XDG on macOS, and its override is an env var called
# plain CONFIG_DIR -- too generic to export globally, so it is set for
# this one command. See lazydocker/config.yml.
lazydocker() {
  CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/lazydocker" command lazydocker "$@"
}
# Shadows the linker, but only when typed: aliases never apply inside
# scripts or to the ld that compilers invoke. `command ld` reaches it.
alias ld='lazydocker'
