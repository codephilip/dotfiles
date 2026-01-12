# =========================================================
# ZSHRC — clean, fast, senior-friendly
# =========================================================

# -------------------------
# Performance first
# -------------------------
# Skip slow compaudit on startup
ZSH_DISABLE_COMPFIX=true

# Faster globbing
setopt NO_CASE_GLOB
setopt EXTENDED_GLOB

# History behavior
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# -------------------------
# Paths
# -------------------------
export PATH="$HOME/bin:/usr/local/bin:/opt/homebrew/bin:$PATH"

# -------------------------
# History config
# -------------------------
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=50000
export SAVEHIST=50000

# -------------------------
# Editor
# -------------------------
export EDITOR="nvim"
export VISUAL="nvim"

# -------------------------
# Less (better paging)
# -------------------------
export LESS="-R --mouse --wheel-lines=3"
export LESSOPEN="| bat --paging=never --style=plain %s"

# =========================================================
# Prompt (git-aware, minimal, fast)
# =========================================================

# Built-in git integration (no plugins)
autoload -Uz vcs_info

# Run before each prompt
precmd() {
  vcs_info
}

# Enable git only
zstyle ':vcs_info:*' enable git

# Branch format: (main)
zstyle ':vcs_info:git:*' formats '(%b)'

# Allow variable expansion in prompt
setopt PROMPT_SUBST

# Prompt layout:
# user@host path (git-branch)
# ➜
PROMPT='%F{cyan}%n@%m%f %F{yellow}%1~%f %F{magenta}${vcs_info_msg_0_}%f
%F{green}➜%f '

# -------------------------
# Completion system
# -------------------------
autoload -Uz compinit
compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${LS_COLORS}"

# -------------------------
# Aliases (core)
# -------------------------
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias cl='clear'

# Safer defaults
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# -------------------------
# Editor aliases (muscle memory)
# -------------------------
alias vi='nvim'
alias vim='nvim'

# -------------------------
# Git / Docker / K8s aliases
# -------------------------
[ -f ~/.config/k8s/aliases.sh ] && source ~/.config/k8s/aliases.sh
[ -f ~/.config/docker/aliases.sh ] && source ~/.config/docker/aliases.sh
[ -f ~/.config/git/aliases.sh ] && source ~/.config/git/aliases.sh

# -------------------------
# Command cheatsheets (bat)
# -------------------------
alias git-commands='bat ~/.config/command-cheatsheets/git.md'
alias k8s-commands='bat ~/.config/command-cheatsheets/k8s.md'
alias docker-commands='bat ~/.config/command-cheatsheets/docker.md'
alias tmux-commands='bat ~/.config/command-cheatsheets/tmux.md'
alias zsh-commands='bat ~/.config/command-cheatsheets/zsh.md'
alias nvim-commands='bat ~/.config/command-cheatsheets/nvim.md'
# -------------------------
# Smart functions (beginner-safe, senior-useful)
# -------------------------

# mkdir + cd
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Jump to git repo root
cdr() {
  local root
  root=$(git rev-parse --show-toplevel 2>/dev/null) && cd "$root" || echo "Not in a git repo"
}

# Show active listening ports
ports() {
  lsof -iTCP -sTCP:LISTEN -P
}

# Kill process by port
killport() {
  lsof -ti tcp:"$1" | xargs kill -9
}

# -------------------------
# Docker / K8s helpers
# -------------------------
dkclean() {
  docker system prune -af --volumes
}

kctxp() {
  kubectl config current-context
}

# -------------------------
# tmux auto-attach (remote-friendly)
# -------------------------
if command -v tmux &>/dev/null; then
  if [[ -z "$TMUX" && -n "$SSH_CONNECTION" ]]; then
    tmux attach || tmux new
  fi
fi

# -------------------------
# OS niceties (macOS)
# -------------------------
# Enable key repeat (disable press-and-hold)
defaults write -g ApplePressAndHoldEnabled -bool false

# -------------------------
# Local overrides (never commit)
# -------------------------
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
