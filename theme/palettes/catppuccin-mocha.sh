# =========================================================
# Catppuccin Mocha
#
# Warm, soft, lower-contrast than Tokyo Night. Upstream:
# catppuccin/nvim. ANSI values are taken verbatim from Ghostty's
# bundled "Catppuccin Mocha" theme, which follows Catppuccin's
# own ANSI mapping -- note that it maps magenta to *pink*
# (#f5c2e7), not mauve.
#
# THEME_ACCENT therefore uses mauve (#cba6f7) explicitly, so the
# prompt's git branch stays in the purple family across all three
# themes instead of turning pink here.
# =========================================================

THEME_NAME="catppuccin-mocha"
THEME_LABEL="Catppuccin Mocha"
THEME_BLURB="warm, soft, low-contrast"

# --- Tool-specific theme names ---------------------------
THEME_BAT="Catppuccin Mocha"      # bat built-in
THEME_NVIM="catppuccin-mocha"
THEME_LUALINE="catppuccin"

# --- Core ------------------------------------------------
THEME_BG="#1e1e2e"                # base
THEME_FG="#cdd6f4"                # text
THEME_BG_HL="#313244"             # surface0
THEME_SELECTION="#585b70"         # surface2
THEME_CURSOR="#f5e0dc"            # rosewater
THEME_CURSOR_TEXT="#1e1e2e"

# --- Semantic --------------------------------------------
THEME_GREY="#6c7086"              # overlay0
THEME_ORANGE="#fab387"            # peach
THEME_ACCENT="#cba6f7"            # mauve

# --- Prompt segment surfaces -----------------------------
# See the equivalent block in tokyonight.sh for why these are dark.
THEME_SURFACE="#313244"           # surface0 — path segment
THEME_SURFACE_ALT="#45475a"       # surface1 — git segment

# --- ANSI normal -----------------------------------------
THEME_BLACK="#45475a"             # surface1
THEME_RED="#f38ba8"
THEME_GREEN="#a6e3a1"
THEME_YELLOW="#f9e2af"
THEME_BLUE="#89b4fa"
THEME_MAGENTA="#f5c2e7"           # pink, per Catppuccin's ANSI spec
THEME_CYAN="#94e2d5"              # teal
THEME_WHITE="#a6adc8"             # subtext0

# --- ANSI bright -----------------------------------------
THEME_BR_BLACK="#585b70"          # surface2
THEME_BR_RED="#f37799"
THEME_BR_GREEN="#89d88b"
THEME_BR_YELLOW="#ebd391"
THEME_BR_BLUE="#74a8fc"
THEME_BR_MAGENTA="#f2aede"
THEME_BR_CYAN="#6bd7ca"
THEME_BR_WHITE="#bac2de"          # subtext1
