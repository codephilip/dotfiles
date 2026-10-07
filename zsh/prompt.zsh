# =========================================================
# PROMPT — native zsh, no framework, powerline segments
#
# Sourced from .zshrc. Replaces starship.
#
#    ~/Repos/api   main ○ ● ? ↑2 ↓1   1.4s
#   ❯
#
# Line 1: a powerline strip — path, branch, worktree state, divergence,
#         slow-command timer. Backgrounds come from THEME_SURFACE* so the
#         strip re-themes with everything else.
# Line 2: just the ❯ — green normally, red (with the exit code) if the
#         last command failed.
#
# Markers, in display order:
#   ○  yellow   unstaged changes to tracked files
#   ●  green    staged changes
#   ✗  red      merge conflict
#   ?  grey     untracked files present
#   ↑N cyan     N commits ahead of upstream
#   ↓N cyan     N commits behind upstream
#
# Outline vs filled is the staging distinction: ○ not staged, ● staged.
#
# Deliberately NOT shown — this is what starship was shelling out for, and
# what made it busy: language versions, kubectl context, terraform
# workspace, docker context.
#
# ---------------------------------------------------------
# Why line 2 has no background
#
# A segment background is an opaque terminal cell, so it punches a solid
# strip through Ghostty's blur (see ghostty/config). Confining the
# segments to line 1 means the line you actually type on stays glass, and
# the surfaces in the palette files are deliberately near-THEME_BG so even
# line 1 reads as a raised surface rather than a bright bar.
#
# ---------------------------------------------------------
# Why these glyphs and not prettier ones
#
# Every glyph here is verified present in JetBrainsMono Nerd Font. That
# matters more than usual for a powerline prompt: a glyph the font lacks
# gets substituted by CoreText from another family, which brings its own
# advance width, and one mismatched width shifts every separator after it
# out of alignment.
#
# The previous version of this file used ✚ (U+271A), ⇡ (U+21E1),
# ⇣ (U+21E3) and ✖ (U+2716), none of which are in the Nerd Font — they
# were rendering via macOS font fallback. Replaced with ○ ● ✗ ↑ ↓, which
# are all in-font. Re-check before adding a glyph:
#
#   python3 -c 'from fontTools.ttLib import TTFont; import os
#   f=TTFont(os.path.expanduser("~/Library/Fonts/JetBrainsMonoNerdFont-Regular.ttf"))
#   c=set().union(*[set(t.cmap) for t in f["cmap"].tables])
#   print(0x25CB in c)'
#
# Separators are U+E0B0/U+E0B4 from the Powerline block, which every Nerd
# Font patch includes. On a bare TTY set _P_POWERLINE=0 below to fall back
# to a plain, background-free prompt.
#
# ---------------------------------------------------------
# Why this doesn't use vcs_info
#
# It did at first, and vcs_info was measured at ~50ms per prompt in this
# repo — over 3x slower than the starship it replaced. check-for-changes
# runs `git diff` twice, and the ahead/behind and untracked markers need
# a hook each, so every prompt paid for four sequential git processes plus
# vcs_info's own dispatch.
#
# `git status --porcelain=v2 --branch` answers all four questions in ONE
# call (6.4ms here vs 21ms for the four it replaces), so the whole git
# section below is a single subprocess and some pure-zsh parsing. The
# second call in _p_git_action only runs when you're mid-rebase.
#
# Re-measure with:
#   zsh -f -c 'source ~/.config/zsh/prompt.zsh
#     typeset -F SECONDS; s=$SECONDS; repeat 20 { _p_git }
#     printf "%.1f ms\n" $(( (SECONDS-s)*1000/20 ))'
# =========================================================

autoload -Uz add-zsh-hook
zmodload -F zsh/datetime p:EPOCHREALTIME

setopt PROMPT_SUBST          # required: PROMPT contains ${...} to expand

# --- Palette ---------------------------------------------
# Taken from the active theme, which .zshrc sources before this file.
# The bright ANSI slots are used rather than the normal ones because
# the normal weights are tuned to sit *in* body text, and the prompt
# needs to read against it.
#
# The :- fallbacks are the old hardcoded Tokyo Night values, so this
# file still works standalone — which matters because the measurement
# recipe at the bottom of this comment block runs it under `zsh -f`,
# with no .zshrc and therefore no THEME_* set.
typeset -g _P_BLUE="${THEME_BR_BLUE:-#7aa2f7}"
typeset -g _P_MAGENTA="${THEME_ACCENT:-#bb9af7}"
typeset -g _P_YELLOW="${THEME_BR_YELLOW:-#e0af68}"
typeset -g _P_CYAN="${THEME_BR_CYAN:-#7dcfff}"
typeset -g _P_GREEN="${THEME_BR_GREEN:-#9ece6a}"
typeset -g _P_RED="${THEME_BR_RED:-#f7768e}"
typeset -g _P_GREY="${THEME_GREY:-#565f89}"
typeset -g _P_ORANGE="${THEME_ORANGE:-#ff9e64}"

# Segment backgrounds. Adjacent segments must differ or the separator
# between them is invisible.
typeset -g _P_SURFACE="${THEME_SURFACE:-#292e42}"
typeset -g _P_SURFACE_ALT="${THEME_SURFACE_ALT:-#3b4261}"

# --- Glyphs ----------------------------------------------
# All verified present in JetBrainsMono Nerd Font — see the header.
#
# Written as $'\uXXXX' rather than as literal characters on purpose.
# These live in the Unicode Private Use Area, which is exactly the range
# that editors, clipboards and patch tooling silently drop or mangle —
# and a dropped separator is invisible in a diff but removes the whole
# powerline effect. The escape survives any transport and names the
# codepoint, so it can be checked against the font without a hex dump.
typeset -g _P_BRANCH_GLYPH=$'\ue0a0'
typeset -g _P_DIR_GLYPH=$'\uf07b'
typeset -g _P_CLOCK_GLYPH=$'\uf017'
typeset -g _P_SEP=$'\ue0b0'       # segment -> segment
typeset -g _P_SEP_END=$'\ue0b0'   # last segment -> terminal bg

typeset -g _P_M_UNSTAGED='○'       # U+25CB
typeset -g _P_M_STAGED='●'         # U+25CF
typeset -g _P_M_CONFLICT='✗'       # U+2717
typeset -g _P_M_UNTRACKED='?'
typeset -g _P_M_AHEAD='↑'          # U+2191
typeset -g _P_M_BEHIND='↓'         # U+2193

# Set to 0 for a bare TTY / no-Nerd-Font terminal: drops every background
# and separator and falls back to the plain two-line prompt.
typeset -g _P_POWERLINE=${_P_POWERLINE:-1}

if (( ! _P_POWERLINE )); then
  _P_BRANCH_GLYPH=''
  _P_DIR_GLYPH=''
  _P_CLOCK_GLYPH=''
  _P_SEP=''
  _P_SEP_END=''
  _P_M_UNSTAGED='+'
  _P_M_STAGED='*'
  _P_M_CONFLICT='x'
  _P_M_AHEAD='^'
  _P_M_BEHIND='v'
fi

# --- Segment builder -------------------------------------
# Powerline's rule: the separator between two segments is drawn in the
# PREVIOUS segment's colour on the NEXT segment's background, which is
# what makes the arrow look like it belongs to the block behind it. The
# final separator is drawn on the default background so the strip ends
# against the terminal (and, here, against the blur).
#
# Pure string building — no subprocesses, so this adds nothing measurable
# to the ~8.6ms the git call costs.
typeset -g _p_seg_out='' _p_seg_prev=''

_p_seg() {   # _p_seg <bg> <fg> <text>
  local bg=$1 fg=$2 text=$3

  if (( ! _P_POWERLINE )); then
    _p_seg_out+="%F{$fg}${text}%f"
    return
  fi

  if [[ -n $_p_seg_prev ]]; then
    _p_seg_out+="%K{$bg}%F{$_p_seg_prev}${_P_SEP}%f"
  fi
  _p_seg_out+="%K{$bg}%F{$fg}${text}%f"
  _p_seg_prev=$bg
}

_p_seg_reset() { _p_seg_out=''; _p_seg_prev=''; }

_p_seg_close() {
  (( _P_POWERLINE )) || return 0
  [[ -n $_p_seg_prev ]] || return 0
  # %k first: the closing arrow sits on the terminal background.
  _p_seg_out+="%k%F{$_p_seg_prev}${_P_SEP_END}%f"
}

# --- Git -------------------------------------------------
# Only called when HEAD is detached, which is the rebase/merge/bisect
# case. Costs one extra subprocess, but not on the common path.
_p_git_action() {
  local gd
  gd=$(git rev-parse --git-dir 2>/dev/null) || return 0

  if [[ -d $gd/rebase-merge ]]; then
    _p_action='rebase-i'
    # head-name is the branch being rebased, e.g. refs/heads/main
    [[ -r $gd/rebase-merge/head-name ]] \
      && _p_branch=${"$(<$gd/rebase-merge/head-name)"#refs/heads/}
  elif [[ -d $gd/rebase-apply ]]; then
    _p_action='rebase'
  elif [[ -f $gd/MERGE_HEAD ]]; then
    _p_action='merge'
  elif [[ -f $gd/CHERRY_PICK_HEAD ]]; then
    _p_action='cherry-pick'
  elif [[ -f $gd/BISECT_LOG ]]; then
    _p_action='bisect'
  fi
  return 0
}

_p_git() {
  # _p_git_text is the segment body (branch + markers), empty outside a
  # repo so the assembly can simply omit the segment. The single git call
  # and all the parsing below are unchanged from the pre-powerline
  # version — only the final string assembly differs.
  _p_git_text=''

  local out
  # One call for branch, divergence, staged, unstaged, conflicts and
  # untracked. Non-zero rc means "not a repo" — leave _p_git_text empty.
  out=$(git status --porcelain=v2 --branch 2>/dev/null) || return 0

  local _p_branch='' _p_action='' oid='' line
  local -i staged=0 unstaged=0 untracked=0 conflicted=0 ahead=0 behind=0

  # ${(f)out} splits on newlines in-process — no extra fork for the loop.
  for line in ${(f)out}; do
    case $line in
      '# branch.head '*) _p_branch=${line#\# branch.head } ;;
      '# branch.oid '*)  oid=${line#\# branch.oid } ;;
      '# branch.ab '*)
        # Format is exactly "+<ahead> -<behind>".
        local -a ab=( ${=${line#\# branch.ab }} )
        ahead=${ab[1]#+}
        behind=${ab[2]#-}
        ;;
      # Ordinary (1) and renamed/copied (2) entries. Field 2 is the XY
      # status pair: X = index/staged, Y = worktree. '.' means unchanged.
      ('1 '*|'2 '*)
        local xy=${${=line}[2]}
        [[ ${xy[1]} != '.' ]] && staged=1
        [[ ${xy[2]} != '.' ]] && unstaged=1
        ;;
      'u '*) conflicted=1 ;;   # unmerged
      '? '*) untracked=1 ;;    # delete this line to drop the ? marker
    esac
  done

  [[ -z $_p_branch ]] && return 0

  if [[ $_p_branch == '(detached)' ]]; then
    _p_git_action
    # No rebase/merge in progress — genuinely detached, so show the sha.
    # It comes from branch.oid above, so this costs no extra process.
    [[ -z $_p_action ]] && _p_branch="@${oid[1,7]}"
  fi

  # PROMPT_SUBST expands $_p_line1 before zsh processes prompt escapes, so
  # a literal % in a branch name would be read as the start of one. Double
  # it, which is how a literal % is spelled in a prompt string.
  _p_branch=${_p_branch//\%/%%}

  # Foreground-only escapes: %F/%f do not disturb the %K background the
  # segment builder wraps this in, so the markers keep their own colours
  # inside the block.
  local info="%F{$_P_MAGENTA}${_P_BRANCH_GLYPH}${_p_branch}%f"
  [[ -n $_p_action ]] && info+=" %F{$_P_RED}(${_p_action})%f"

  (( unstaged ))   && info+=" %F{$_P_YELLOW}${_P_M_UNSTAGED}%f"
  (( staged ))     && info+=" %F{$_P_GREEN}${_P_M_STAGED}%f"
  (( conflicted )) && info+=" %F{$_P_RED}${_P_M_CONFLICT}%f"
  (( untracked ))  && info+=" %F{$_P_GREY}${_P_M_UNTRACKED}%f"

  # Counts are kept on divergence (unlike the worktree flags) because
  # 13 vs 1 decides whether you pull before you push.
  (( ahead ))  && info+=" %F{$_P_CYAN}${_P_M_AHEAD}${ahead}%f"
  (( behind )) && info+=" %F{$_P_CYAN}${_P_M_BEHIND}${behind}%f"

  _p_git_text=$info
  return 0
}

# --- Command timer ---------------------------------------
# Only commands slower than this get a timer, so the prompt stays quiet
# for the hundreds of fast ones.
typeset -g _P_SLOW_SECONDS=2

_p_fmt_duration() {
  local t=$1
  local -i ti=$(( t ))
  if   (( ti < 60 ));   then printf '%.1fs' "$t"
  elif (( ti < 3600 )); then printf '%dm%02ds' $(( ti / 60 ))   $(( ti % 60 ))
  else                       printf '%dh%02dm' $(( ti / 3600 )) $(( (ti % 3600) / 60 ))
  fi
}

_p_preexec() { _p_started=$EPOCHREALTIME }

_p_precmd() {
  if [[ -n ${_p_started:-} ]]; then
    local elapsed=$(( EPOCHREALTIME - _p_started ))
    unset _p_started
    if (( elapsed >= _P_SLOW_SECONDS )); then
      # Text only — the assembly wraps it in its own segment.
      _p_duration_text="${_P_CLOCK_GLYPH:+$_P_CLOCK_GLYPH }$(_p_fmt_duration $elapsed)"
    else
      _p_duration_text=''
    fi
  else
    # No preexec ran — a bare Enter, or the shell's first prompt.
    _p_duration_text=''
  fi

  _p_git
  _p_build
}

# --- Line 1 ----------------------------------------------
# Rebuilt once per prompt in precmd rather than expanded from PROMPT on
# every redraw, because the segment builder is imperative (each separator
# depends on the previous segment's background) and that does not fit in a
# PROMPT_SUBST expression.
_p_build() {
  _p_seg_reset

  # Host, only over SSH — locally it's noise you already know.
  [[ -n $_p_host_text ]] \
    && _p_seg "$_P_SURFACE_ALT" "$_P_GREEN" " $_p_host_text "

  # Path. %(5~|…/%4~|%~) — last 4 components once deeper than that, full
  # path from ~ otherwise. Matches the old starship truncation_length=4,
  # and like that config it deliberately does NOT truncate to the repo
  # root: in a dotfiles monorepo "…/.config" hides the one thing you
  # needed to know, which is where you actually are.
  #
  # The %(...) is left unexpanded here; PROMPT is still PROMPT_SUBST'd,
  # so zsh expands it when the prompt is drawn.
  _p_seg "$_P_SURFACE" "$_P_BLUE" " ${_P_DIR_GLYPH:+$_P_DIR_GLYPH }%B%(5~|…/%4~|%~)%b "

  [[ -n $_p_git_text ]] \
    && _p_seg "$_P_SURFACE_ALT" "$_P_MAGENTA" " $_p_git_text "

  [[ -n $_p_duration_text ]] \
    && _p_seg "$_P_SURFACE" "$_P_ORANGE" " $_p_duration_text "

  _p_seg_close
  _p_line1=$_p_seg_out
}

# -d first so re-sourcing .zshrc doesn't register the hooks twice.
add-zsh-hook -d preexec _p_preexec 2>/dev/null
add-zsh-hook -d precmd  _p_precmd  2>/dev/null
add-zsh-hook    preexec _p_preexec
add-zsh-hook    precmd  _p_precmd

# --- Assembly --------------------------------------------
# user@host only over SSH — locally it's noise you already know.
# Computed once: $SSH_CONNECTION can't change within a shell.
if [[ -n ${SSH_CONNECTION:-} ]]; then
  typeset -g _p_host_text='%n@%m'
else
  typeset -g _p_host_text=''
fi

typeset -g _p_line1='' _p_git_text='' _p_duration_text=''

# Build once up front so the very first prompt — drawn before any precmd
# has run — is not a bare arrow on an empty line.
_p_git
_p_build

# Line 2 carries no background on purpose (see the header): it is the line
# you type on, so it stays transparent over Ghostty's blur.
#
# %(?..) picks the colour; the exit code itself only appears on failure,
# where %? expands to it. A bare red arrow told you something broke but
# not what, and 1 vs 127 vs 130 are three different problems.
PROMPT='
${_p_line1}
%(?.%F{'$_P_GREEN'}%B❯%b%f.%F{'$_P_RED'}%B✗ %? ❯%b%f) '

# Nothing on the right: the two-line layout already leaves the command
# line clear, and an RPROMPT would only add something to misalign —
# doubly so now that line 1 ends in a separator whose width must stay
# predictable.
RPROMPT=''
