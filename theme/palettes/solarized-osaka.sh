# =========================================================
# Solarized Osaka (Night)
#
# Deep teal-black with classic Solarized accents. This is the
# colorscheme in Takuya Matsuyama's (devaslife) screenshots.
# Upstream: craftzdog/solarized-osaka.nvim.
#
# ---------------------------------------------------------
# Why these values are not copied from Ghostty
#
# Ghostty 1.3.1 ships a theme called "Solarized Osaka Night",
# but it is a byte-for-byte duplicate of "TokyoNight Night" --
# a broken entry in their theme pack. Using it would make two
# of the three themes here visually identical.
#
# So these are converted from the upstream plugin's own
# definition, which stores colours as HSL and derives hex at
# runtime (lua/solarized-osaka/colors.lua). Equivalents:
#
#   bg        base04      hsl(192, 100,  5)
#   fg        base0       hsl(186,   8, 65)
#   grey      base01      hsl(194,  14, 40)
#   selection base02      hsl(192,  81, 14)
#
# Accents use the 500 weight for normal and 400 for bright,
# which is what reads legibly against a 5%-lightness ground.
# =========================================================

THEME_NAME="solarized-osaka"
THEME_LABEL="Solarized Osaka"
THEME_BLURB="deep teal-black, Solarized accents (devaslife)"

# --- Tool-specific theme names ---------------------------
# No Osaka-specific bat theme exists upstream; "Solarized (dark)"
# is a bat built-in in the same accent family and the closest match.
THEME_BAT="Solarized (dark)"
THEME_NVIM="solarized-osaka-night"
THEME_LUALINE="auto"        # plugin ships no lualine theme; auto reads highlights

# --- Core ------------------------------------------------
THEME_BG="#00141a"
THEME_FG="#9fabad"
THEME_BG_HL="#073541"
THEME_SELECTION="#073541"
THEME_CURSOR="#9fabad"
THEME_CURSOR_TEXT="#00141a"

# --- Semantic --------------------------------------------
THEME_GREY="#586e74"
THEME_ORANGE="#ca4c16"
THEME_ACCENT="#d33682"      # solarized magenta; violet is too dim to read here

# --- Prompt segment surfaces -----------------------------
# See the equivalent block in tokyonight.sh for why these are dark.
# base03 and base02 — the two surfaces above this theme's base04 ground.
THEME_SURFACE="#002d38"     # path segment
THEME_SURFACE_ALT="#073541" # git segment

# --- ANSI normal -----------------------------------------
THEME_BLACK="#073541"
THEME_RED="#dc312e"
THEME_GREEN="#a3cc00"
THEME_YELLOW="#dba400"
THEME_BLUE="#278bd3"
THEME_MAGENTA="#d33682"
THEME_CYAN="#2aa298"
THEME_WHITE="#adb8b8"

# --- ANSI bright -----------------------------------------
THEME_BR_BLACK="#586e74"
THEME_BR_RED="#ea413e"
THEME_BR_GREEN="#b7fa00"
THEME_BR_YELLOW="#ffbf00"
THEME_BR_BLUE="#309ce8"
THEME_BR_MAGENTA="#e44491"
THEME_BR_CYAN="#22d3c4"
THEME_BR_WHITE="#fdf6e2"
