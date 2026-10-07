# =========================================================
# Tokyo Night (Night)
#
# Cool blue-violet on near-black. Upstream: folke/tokyonight.nvim.
# ANSI values are taken verbatim from Ghostty's bundled
# "TokyoNight Night" theme so the terminal and everything that
# derives from this file agree exactly.
#
# These values reproduce the pre-switcher hardcoded palette
# exactly, so selecting this theme is a visual no-op against
# the old config.
# =========================================================

THEME_NAME="tokyonight"
THEME_LABEL="Tokyo Night"
THEME_BLURB="cool blue-violet on near-black"

# --- Tool-specific theme names ---------------------------
# bat/delta share a theme registry. tokyonight_night is NOT a bat
# built-in; `theme` installs the .tmTheme into ~/.config/bat/themes
# and runs `bat cache --build`. See scripts/theme.
THEME_BAT="tokyonight_night"
THEME_NVIM="tokyonight-night"
THEME_LUALINE="tokyonight"

# --- Core ------------------------------------------------
THEME_BG="#1a1b26"
THEME_FG="#c0caf5"
THEME_BG_HL="#283457"       # fzf bg+, subtle row highlight
THEME_SELECTION="#283457"
THEME_CURSOR="#c0caf5"
THEME_CURSOR_TEXT="#1a1b26"

# --- Semantic --------------------------------------------
THEME_GREY="#565f89"        # comments, autosuggestions, dim UI
THEME_ORANGE="#ff9e64"      # prompt command timer
THEME_ACCENT="#bb9af7"      # prompt git branch

# --- Prompt segment surfaces -----------------------------
# Backgrounds for the powerline segments in zsh/prompt.zsh. Adjacent
# segments must differ or the separator between them is invisible.
#
# Both are real theme surfaces (bg_highlight and bg_visual) rather than
# invented colours, and both are deliberately dark: a powerline segment
# is an opaque cell, so it punches a solid strip through Ghostty's blur.
# Keeping them close to THEME_BG makes that strip read as a slightly
# raised surface instead of a bright bar across the glass.
THEME_SURFACE="#292e42"     # path segment
THEME_SURFACE_ALT="#3b4261" # git segment

# --- ANSI normal -----------------------------------------
THEME_BLACK="#15161e"
THEME_RED="#f7768e"
THEME_GREEN="#9ece6a"
THEME_YELLOW="#e0af68"
THEME_BLUE="#7aa2f7"
THEME_MAGENTA="#bb9af7"
THEME_CYAN="#7dcfff"
THEME_WHITE="#a9b1d6"

# --- ANSI bright -----------------------------------------
THEME_BR_BLACK="#414868"
THEME_BR_RED="#f7768e"
THEME_BR_GREEN="#9ece6a"
THEME_BR_YELLOW="#e0af68"
THEME_BR_BLUE="#7aa2f7"
THEME_BR_MAGENTA="#bb9af7"
THEME_BR_CYAN="#7dcfff"
THEME_BR_WHITE="#c0caf5"
