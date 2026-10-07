# =========================================================
# ZSHRC
# Lives at ~/.config/zsh/.zshrc, symlinked from ~/.zshrc
#
# Load order matters in the plugin section at the bottom —
# read the comments there before rearranging.
# =========================================================

# -------------------------
# Performance first
# -------------------------
ZSH_DISABLE_COMPFIX=true

setopt NO_CASE_GLOB
setopt EXTENDED_GLOB

# History behaviour
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE      # a leading space keeps a command out of history
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY            # expand !! and confirm before running
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# Directory navigation
setopt AUTO_CD                # `nvim/` instead of `cd nvim/`
setopt AUTO_PUSHD             # every cd pushes onto the dir stack
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

setopt INTERACTIVE_COMMENTS   # allow # comments when typing commands

# Emacs-style line editing. Selected here, before any plugin binds a
# key, because zsh starts in vi mode when $EDITOR contains "vi" -- and
# EDITOR=nvim does. Selected at the bottom instead, every earlier
# plain `bindkey` (autosuggestions' Ctrl-Space) lands in the viins
# keymap and silently vanishes when this switches to emacs.
bindkey -e

# -------------------------
# Paths
#
# Built as a zsh array rather than a string so that:
#   typeset -U path   drops duplicates, keeping the FIRST occurrence —
#                     which is what preserves the precedence below across
#                     repeated `exec zsh` / sourcing of this file.
#   $^path(N-/)       drops entries that aren't existing directories.
#                     N = no-match-is-empty, - = follow symlinks, / = dirs.
#
# Order is precedence: these are prepended, so Homebrew's tools win over
# the macOS system copies in /usr/bin.
# -------------------------
export SCRIPTS="$HOME/.config/scripts"

# Homebrew lives at a different prefix depending on the machine:
# /opt/homebrew on Apple Silicon, /usr/local on Intel,
# /home/linuxbrew/.linuxbrew on Linux. Hardcoding one means the other
# silently gets nothing -- no error, just a shell quietly missing its
# completions and plugins.
#
# Probed rather than asking `brew --prefix`, which spawns a subprocess
# on every single shell start. `brew shellenv` exports HOMEBREW_PREFIX,
# so a login profile that already ran it wins.
if [[ -z ${HOMEBREW_PREFIX:-} ]]; then
  for _p in /opt/homebrew /usr/local /home/linuxbrew/.linuxbrew; do
    if [[ -x $_p/bin/brew ]]; then
      export HOMEBREW_PREFIX=$_p
      break
    fi
  done
  unset _p
fi

path=(
  $HOME/bin
  # Claude Code's native installer drops its binary here, as do uv, pipx
  # and `cargo install --root ~/.local`. Without this, `claude` is
  # installed and still "command not found" -- which is exactly what
  # happened on mac-mini-1.
  $HOME/.local/bin
  $SCRIPTS
  ${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/bin}
  ${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/sbin}
  /usr/local/bin
  $path
)

typeset -U path
path=($^path(N-/))
export PATH

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

# k9s ignores XDG on macOS and uses ~/Library/Application Support/k9s,
# which would leave its config outside this repo -- unversioned, and
# missing the generated skin. Point it back at ~/.config/k9s.
# Verify with `k9s info`, which prints the paths it resolved.
export K9S_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/k9s"

# =========================================================
# Theme
#
# One palette drives zsh, nvim, ghostty, alacritty, bat and delta.
# theme/palettes/<name>.sh holds the THEME_* values; theme/current
# names the active one. Switch with `theme <name>` -- the wrapper
# function near the bottom of this file re-execs the shell so the
# change lands immediately.
#
# This must be sourced BEFORE the bat and fzf sections below, which
# read THEME_* to build BAT_THEME and FZF_DEFAULT_OPTS.
# =========================================================
export THEME_CONFIG="$HOME/.config/theme"

_load_theme() {
  local name=''
  if [[ -r "$THEME_CONFIG/current" ]]; then
    name=${"$(<"$THEME_CONFIG/current")"//[[:space:]]/}
  fi
  [[ -z $name ]] && name='tokyonight'

  local palette="$THEME_CONFIG/palettes/$name.sh"
  # Fall back rather than leaving every THEME_* unset, which would
  # silently produce an uncoloured prompt and empty fzf --color flags.
  [[ -r $palette ]] || palette="$THEME_CONFIG/palettes/tokyonight.sh"
  [[ -r $palette ]] && source "$palette"
}
_load_theme

# -------------------------
# Less / bat paging
# -------------------------
export LESS="-R --mouse --wheel-lines=3"
export LESSOPEN="| bat --paging=never --style=plain %s"
# Set from the active palette. Note that tokyonight_night is not a bat
# built-in -- `theme` installs the .tmTheme and runs `bat cache
# --build`. Before that existed this variable named a theme bat did not
# have, so it was silently falling back to bat's default.
export BAT_THEME="${THEME_BAT:-ansi}"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"   # syntax-highlighted man pages
export MANROFFOPT="-c"

# =========================================================
# Completion system
# =========================================================
autoload -Uz compinit

# Rebuild the completion cache at most once a day; otherwise load it as-is.
# This is the single biggest zsh startup win.
_zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
if [[ -n $_zcompdump(#qN.mh+24) ]]; then
  compinit -d "$_zcompdump"
else
  compinit -C -d "$_zcompdump"
fi
unset _zcompdump

zstyle ':completion:*' menu no                      # fzf-tab replaces the menu
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'   # case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '[%d]'

# Preview the directory you're about to cd into, and files you're completing.
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons $realpath'
zstyle ':fzf-tab:complete:z:*' fzf-preview 'eza -1 --color=always --icons $realpath'
zstyle ':fzf-tab:complete:*:*' fzf-preview \
  '[[ -d $realpath ]] && eza -1 --color=always --icons $realpath || bat --color=always --style=plain --line-range=:50 $realpath 2>/dev/null'
zstyle ':fzf-tab:*' fzf-flags --height=60% --layout=reverse --border=rounded
zstyle ':fzf-tab:*' switch-group ',' '.'

# =========================================================
# Aliases
# =========================================================

# --- eza: ls with icons, colour and git status ---
if command -v eza &>/dev/null; then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -lah --icons --group-directories-first --git --time-style=relative'
  alias la='eza -a  --icons --group-directories-first'
  alias l='eza -1   --icons --group-directories-first'
  alias lt='eza --tree --level=2 --icons --group-directories-first'
  alias ltt='eza --tree --level=3 --icons --group-directories-first'
  alias lg='eza -lah --icons --git --git-ignore --group-directories-first'
else
  alias ls='ls -G'
  alias ll='ls -lahG'
  alias la='ls -AG'
  alias l='ls -CFG'
fi

alias cl='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Safer defaults
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Editor muscle memory
alias vi='nvim'
alias vim='nvim'
alias v='nvim'

# Config shortcuts
alias zshrc='nvim ~/.config/zsh/.zshrc'
alias zreload='exec zsh'
alias nvimrc='nvim ~/.config/nvim/init.lua'

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

# =========================================================
# Functions
# =========================================================

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

# Fuzzy-find a file and open it in nvim
fv() {
  local file
  file=$(fzf --preview 'bat --color=always --style=numbers {}' --height=80% --layout=reverse --border=rounded) \
    && [ -n "$file" ] && nvim "$file"
}

# Fuzzy-switch git branch
fbr() {
  local branch
  branch=$(git branch --all | grep -v HEAD | sed 's/^[* ] //;s#remotes/origin/##' | sort -u \
    | fzf --height=40% --layout=reverse --border=rounded) \
    && [ -n "$branch" ] && git checkout "$branch"
}

# -------------------------
# theme — wrapper around scripts/theme
#
# The script rewrites the generated config fragments, but BAT_THEME,
# FZF_DEFAULT_OPTS and the prompt's colours were all expanded into
# this shell's environment at startup. Re-exec so they are rebuilt;
# read-only subcommands skip that.
#
# Other already-open shells need `exec zsh` themselves. Ghostty needs
# ⌘⇧, and nvim needs a restart — it has no CLI config reload.
# -------------------------
theme() {
  command theme "$@" || return $?

  case "${1:-}" in
    ''|current|list|ls|show|swatch|regen|-h|--help|help) return 0 ;;
  esac

  exec zsh
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

# =========================================================
# Plugins & integrations
#
# ORDER IS LOAD-BEARING:
#   1. fzf            — defines the widgets fzf-tab builds on
#   2. fzf-tab        — must come after compinit, before autosuggestions
#   3. autosuggestions
#   4. syntax-highlighting — MUST BE LAST, it wraps every preceding widget
# =========================================================

# --- 1. fzf: Ctrl-R history, Ctrl-T files, Alt-C cd ---
if command -v fzf &>/dev/null; then
  # Derived from the active palette rather than hardcoded. The old
  # values mixed two themes -- #719cd6 and #9d7cd8 are nordfox, on a
  # tokyonight #c0caf5 foreground.
  #
  # bg:-1 and gutter:-1 mean "terminal default", i.e. keep fzf's own
  # background transparent so Ghostty's blur shows through it instead
  # of fzf painting an opaque panel over the glass.
  export FZF_DEFAULT_OPTS="
    --height=60% --layout=reverse --border=rounded --info=inline
    --color=bg:-1,gutter:-1,bg+:$THEME_BG_HL
    --color=fg:$THEME_FG,fg+:$THEME_BR_WHITE
    --color=hl:$THEME_BR_BLUE,hl+:$THEME_BR_BLUE
    --color=pointer:$THEME_BR_BLUE,spinner:$THEME_BR_BLUE,header:$THEME_BR_BLUE
    --color=info:$THEME_ACCENT,prompt:$THEME_ACCENT
    --color=marker:$THEME_BR_GREEN,border:$THEME_GREY"

  if command -v fd &>/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  fi
  export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:200 {}'"
  export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --color=always --icons {}'"
  export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window=down:3:hidden:wrap --bind '?:toggle-preview'"

  # fzf >= 0.48 ships `fzf --zsh`; fall back to the shipped scripts.
  #
  # NB: sourcing this under `zsh -ic` with no tty prints "can't change
  # option: zle" twice. That is an artifact of there being no terminal
  # to attach a line editor to -- it does not happen in a real shell,
  # and is not worth guarding. Confirmed with `script -q /dev/null
  # zsh -lic ...`, which is silent.
  if fzf --zsh &>/dev/null; then
    source <(fzf --zsh)
  else
    # Candidate layouts, in order: brew (either prefix, via
    # HOMEBREW_PREFIX), a Debian/Ubuntu package, and the git-clone
    # install that fzf's own install script produces.
    for _d in ${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/opt/fzf/shell} \
              /usr/share/doc/fzf/examples \
              $HOME/.fzf/shell; do
      if [ -f "$_d/key-bindings.zsh" ]; then
        source "$_d/key-bindings.zsh"
        [ -f "$_d/completion.zsh" ] && source "$_d/completion.zsh"
        break
      fi
    done
    unset _d
  fi
fi

# --- 2. fzf-tab: fuzzy tab completion with previews ---
[ -f ~/.config/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh ] \
  && source ~/.config/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh

# Source the first candidate that exists, so a plugin installed any of
# the usual ways is found instead of only the one layout. Returns
# non-zero if none matched, which lets the caller skip its config.
_source_first() {
  local f
  for f in "$@"; do
    if [ -n "$f" ] && [ -f "$f" ]; then
      source "$f"
      return 0
    fi
  done
  return 1
}

# --- 3. autosuggestions: ghost text from history, -> to accept ---
# brew (either prefix) / distro package / a clone under zsh/plugins,
# which is how fzf-tab is vendored here.
if _source_first \
     ${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh} \
     /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
     ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
then
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=${THEME_GREY:-#565f89}"
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  bindkey '^ ' autosuggest-accept        # Ctrl-Space accepts the whole suggestion
fi

# --- 4. zoxide: `z <partial>` jumps to frecent dirs ---
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

# --- 5. prompt: starship ---
# Bracketed-segment style with Nerd Font icons — see starship.toml, which
# is generated (icons are Private Use Area codepoints; the generator
# emits them as \uXXXX escapes so the file stays ASCII and diffable).
#
# STARSHIP_CONFIG points at the GENERATED copy, not starship.toml itself:
# `theme <name>` writes starship-current.toml with the palette line
# swapped, so switching themes never dirties the tracked file.
#
# Styles are foreground-only, no backgrounds — a styled background is an
# opaque cell and would punch a solid strip through Ghostty's blur.
#
# Cost: ~17ms per prompt in a git repo (~5ms outside one) plus ~5ms init,
# against ~9ms for the hand-rolled zsh/prompt.zsh. Per `starship timings`
# that is almost entirely git_status + git_branch; the language chips are
# under 1ms each. To go back to the fast prompt, comment out this block
# and uncomment the prompt.zsh line below.
if command -v starship &>/dev/null; then
  export STARSHIP_CONFIG="$HOME/.config/starship-current.toml"
  # Fall back to the tracked config if `theme regen` has not run yet.
  [ -r "$STARSHIP_CONFIG" ] || export STARSHIP_CONFIG="$HOME/.config/starship.toml"
  eval "$(starship init zsh)"
else
  # starship missing — use the native prompt rather than zsh's default.
  [ -f ~/.config/zsh/prompt.zsh ] && source ~/.config/zsh/prompt.zsh
fi

# The fast fallback: a hand-rolled powerline prompt in pure zsh, one git
# subprocess per prompt. Kept working and tested; swap the block above
# for this line if starship's 17ms ever starts to show.
# [ -f ~/.config/zsh/prompt.zsh ] && source ~/.config/zsh/prompt.zsh

# --- 6. syntax highlighting: MUST be the last plugin sourced ---
_source_first \
  ${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh} \
  /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# -------------------------
# Key bindings (emacs mode is selected near the top)
# -------------------------
bindkey '^[[A' history-search-backward      # Up  = prefix search, not plain history
bindkey '^[[B' history-search-forward       # Down
bindkey '^[[1;5C' forward-word              # Ctrl-Right
bindkey '^[[1;5D' backward-word             # Ctrl-Left

# -------------------------
# Local overrides (never commit)
# -------------------------
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
