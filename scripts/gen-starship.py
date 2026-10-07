#!/usr/bin/env python3
"""Generate ~/.config/starship.toml.

Why this is generated rather than hand-written
----------------------------------------------
Every icon is a Private Use Area codepoint. PUA characters get silently
dropped or substituted by editors, clipboards and patch tooling, and a
missing icon is invisible in a diff. Emitting \\uXXXX escapes keeps the
output pure ASCII, so what you read is exactly what starship gets.

Two TOML/starship rules this file exists to get right
-----------------------------------------------------
1. Escapes only work in TOML *basic* strings (double-quoted). A literal
   string ('single quotes') is raw: '\\uF418' is the seven characters
   backslash-u-F-4-1-8, which starship's format parser then rejects with
   "expected escaped_char". So every value below is a basic string.

2. Inside a basic string, a literal backslash must itself be escaped.
   starship needs \\[ to mean "a literal [" (bare [ opens a text group),
   so the TOML has to contain \\\\[ -- written here as BS+BS+"[".

Also: TOML top-level keys must appear before the first [table], or they
are parsed as belonging to that table. `palette` therefore lives in the
header, not at the bottom.
"""
import io

BS = chr(92)


def u(cp: int) -> str:
    """A TOML basic-string escape for one codepoint.

    \\u takes exactly four hex digits, so the Nerd Font v3 icons that live
    in Plane 1 (rust, kubernetes, package) need the eight-digit \\U form.
    """
    return BS + ("u%04X" % cp if cp <= 0xFFFF else "U%08X" % cp)


# starship format metacharacters, spelled for a TOML basic string.
#
# LB/RB and LP/RP are ESCAPED -- they render a literal bracket or paren.
# GL/GR are the bare parens that open and close a starship *conditional
# group*, which renders nothing at all when every variable inside it is
# empty. The distinction matters: using the escaped form for a group is
# what leaves a bare "[]" in the prompt of a clean repo.
LB, RB = BS + BS + "[", BS + BS + "]"
LP, RP = BS + BS + "(", BS + BS + ")"
GL, GR = "(", ")"

# Icons taken verbatim from `starship preset nerd-font-symbols`, each
# verified present in JetBrainsMono Nerd Font before use.
I = {
    "go": 0xE627, "node": 0xE718, "python": 0xE235, "rust": 0xF1617,
    "lua": 0xE620, "terraform": 0xE69A, "docker": 0xF308, "k8s": 0xF10FE,
    "branch": 0xF418, "package": 0xF03D7, "java": 0xE738, "c": 0xE61E,
    "helm": 0xE7FB, "aws": 0xF0EF, "folder": 0xF07B, "clock": 0xF017,
    "lock": 0xF023, "stash": 0xF01C,
    "chev_r": 0x276F, "chev_l": 0x276E, "ellipsis": 0x2026,
    "up": 0x2191, "down": 0x2193, "cross": 0x2717, "raquo": 0x00BB,
}

# Mirrors theme/palettes/*.sh. Add a theme there -> add it here too.
PALETTES = {
    "tokyonight": dict(
        fg="#c0caf5", muted="#565f89", blue="#7aa2f7", cyan="#7dcfff",
        green="#9ece6a", yellow="#e0af68", red="#f7768e", magenta="#bb9af7",
        orange="#ff9e64",
    ),
    "solarized-osaka": dict(
        fg="#9fabad", muted="#586e74", blue="#309ce8", cyan="#22d3c4",
        green="#a3cc00", yellow="#dba400", red="#ea413e", magenta="#d33682",
        orange="#ca4c16",
    ),
    "catppuccin-mocha": dict(
        fg="#cdd6f4", muted="#6c7086", blue="#89b4fa", cyan="#94e2d5",
        green="#a6e3a1", yellow="#f9e2af", red="#f38ba8", magenta="#cba6f7",
        orange="#fab387",
    ),
}

HEADER = '''# =========================================================
# starship.toml  --  prompt configuration
#
# Style: the "bracketed segments" preset with icons from the
# "nerd-font-symbols" preset. Everything after the directory is wrapped
# in brackets, so the prompt reads as discrete chips rather than a
# run-on line:
#
#   <folder> api [<branch> main] [!2+1?3] [<go> v1.24.0] [<clock> 3s]
#   >
#
# (angle brackets stand in for icons -- no literal icon appears anywhere
# in this file, deliberately; see below)
#
# ---------------------------------------------------------
# GENERATED -- do not hand-edit
#
# Regenerate rather than patching. The reason it is generated: every icon
# is a Private Use Area codepoint, and PUA characters get silently
# dropped or substituted by editors, clipboards and diff tooling -- a
# missing icon leaves no trace in a review. Emitting them as \\uXXXX
# escapes keeps this file pure ASCII.
#
# Two rules the generator exists to enforce:
#
#   * Escapes only work in TOML *basic* (double-quoted) strings. In a
#     literal 'single-quoted' string, \\uF418 is seven raw characters and
#     starship rejects it with "expected escaped_char".
#   * starship needs \\[ for a literal bracket, and a basic string needs
#     its backslash doubled, so the file contains \\\\[.
#
# Icons above U+FFFF (rust, kubernetes, package) use the eight-digit \\U
# form, because \\u takes exactly four hex digits.
#
# ---------------------------------------------------------
# Themes
#
# All three palettes are defined at the bottom; `palette` just below
# selects one. scripts/theme rewrites that single line into the generated
# starship-current.toml, so this file is untouched by a theme switch.
#
# It is a top-level key on purpose: TOML assigns a bare key to the most
# recent [table], so a `palette` at the end of the file would silently
# become memory_usage.palette.
#
# ---------------------------------------------------------
# Cost
#
# ~17ms per prompt here against ~9ms for the hand-rolled zsh/prompt.zsh
# it replaced, plus ~5ms of `starship init` per shell start. That is the
# price of the language-version chips, which stat the directory looking
# for marker files. A deliberate trade for the icons -- prompt.zsh is
# kept as the fast fallback.
#
# scan_timeout and command_timeout bound the damage on a slow or network
# filesystem, where those stats are what would hang the prompt.
# =========================================================

"$schema" = 'https://starship.rs/config-schema.json'

palette = 'tokyonight'
add_newline = true
scan_timeout = 30
command_timeout = 500

# Two lines: content, then the prompt character alone. The typing line
# stays clear no matter how many chips the directory earns.
format = """
$username$hostname$directory\\
$git_branch$git_state$git_status\\
$package\\
$golang$nodejs$python$rust$lua$java$c\\
$terraform$kubernetes$docker_context$helm$aws\\
$cmd_duration\\
$line_break\\
$character"""
'''


def chip(body):
    """A bracketed segment: \\[ body \\] plus a trailing space.

    Wrapped in a starship conditional group so the whole chip -- brackets
    included -- disappears when every variable inside it is empty.
    Without the group the brackets are literal text and a clean repo
    renders a bare "[]".
    """
    return GL + LB + body + RB + " " + GR


def bare_chip(body):
    """A bracketed segment with NO conditional group. For git_state only.

    starship suppresses a conditional group whose only variable is
    $state: `($state)` renders as nothing even mid-merge, when $state is
    "MERGING". Verified by bisecting the format string against a fixture
    repo -- `[$state]($style)` prints MERGING, `($state)` prints nothing.
    So chip() here silently hid every rebase, merge and cherry-pick.

    The group is not needed anyway: git_state emits nothing at all
    outside one of those operations, so there is no empty-module case for
    a group to clean up. Checked against a clean repo, a dirty repo and a
    non-repo directory -- no stray brackets in any of them.
    """
    return LB + body + RB + " "


def main():
    out = [HEADER]
    A = out.append

    # --- character -------------------------------------------------
    A('''
# --- Prompt character ------------------------------------
# The only unbracketed module. Green on success, red on failure -- the
# single most useful piece of state in the prompt.
[character]
success_symbol = "[{R}](bold green)"
error_symbol = "[{R}](bold red)"
vicmd_symbol = "[{L}](bold yellow)"
'''.replace("{R}", u(I["chev_r"])).replace("{L}", u(I["chev_l"])))

    # --- directory -------------------------------------------------
    A('''
# --- Directory -------------------------------------------
# Unbracketed and bold, so the thing you most need to read is the thing
# that stands out. truncation_length = 4 matches what zsh/prompt.zsh did.
#
# truncate_to_repo is off on purpose: this repo IS ~/.config, so
# truncating to the repo root would collapse every path to the one
# component that tells you nothing about where you are.
[directory]
format = "[$path]($style)[$read_only]($read_only_style) "
style = "bold blue"
truncation_length = 4
truncate_to_repo = false
truncation_symbol = "{ELL}/"
read_only = " {LOCK}"
read_only_style = "red"

[directory.substitutions]
"~/.config" = "{FOLDER} .config"
'''.replace("{ELL}", u(I["ellipsis"])).replace("{LOCK}", u(I["lock"]))
   .replace("{FOLDER}", u(I["folder"])))

    # --- git -------------------------------------------------------
    A('''
# --- Git -------------------------------------------------
[git_branch]
format = "{CHIP}"
symbol = "{BRANCH} "
style = "bold magenta"
truncation_length = 24
truncation_symbol = "{ELL}"

# A distinct mark per state, each with a count. This replaced a row of
# identically-shaped coloured dots, which failed twice over: the meaning
# lived entirely in hue, so it was unreadable in a screenshot and to a
# colourblind reader, and with no count one stray file looked exactly
# like forty. "!3" says what and how many without a legend.
#
#   =  conflict   ballot-x  deleted     guillemet  renamed
#   !  modified   +         staged      ?          untracked
#   inbox icon    stashed
#
# Colour still rides along as a second channel for whoever has learnt it.
# Each symbol is itself a format string, which is what lets every one
# carry its own colour inside a single module.
#
# Worktree state and divergence are separate chips because they answer
# different questions -- "is my tree clean" versus "am I in sync" -- and
# each disappears on its own when it has nothing to say.
[git_status]
format = "{SCHIP}{ABCHIP}"
conflicted = "[=${count}](bold red)"
up_to_date = ""
untracked = "[?${count}](bold muted)"
stashed = "[{STASH}${count}](bold cyan)"
modified = "[!${count}](bold yellow)"
staged = "[+${count}](bold green)"
renamed = "[{RAQUO}${count}](bold magenta)"
deleted = "[{CROSS}${count}](bold red)"
ahead = "[{UP}${count}](bold cyan)"
behind = "[{DOWN}${count}](bold cyan)"
diverged = "[{UP}${ahead_count}](bold cyan) [{DOWN}${behind_count}](bold cyan)"

[git_state]
format = "{GCHIP}"
style = "bold red"
'''.replace("{CHIP}", chip("[$symbol$branch(:$remote_branch)]($style)"))
   .replace("{SCHIP}", chip("$all_status"))
   .replace("{ABCHIP}", chip("$ahead_behind"))
   .replace("{GCHIP}",
            bare_chip("[$state( $progress_current/$progress_total)]($style)"))
   .replace("{BRANCH}", u(I["branch"])).replace("{ELL}", u(I["ellipsis"]))
   .replace("{CROSS}", u(I["cross"])).replace("{STASH}", u(I["stash"]))
   .replace("{RAQUO}", u(I["raquo"])).replace("{UP}", u(I["up"]))
   .replace("{DOWN}", u(I["down"])))

    # --- duration --------------------------------------------------
    A('''
# --- Command duration ------------------------------------
# Only past 2s -- the same threshold prompt.zsh used, so the prompt stays
# quiet for the hundreds of fast commands.
[cmd_duration]
format = "{CHIP}"
style = "bold orange"
min_time = 2000
'''.replace("{CHIP}", chip("[{CLOCK} $duration]($style)").replace("{CLOCK}", u(I["clock"]))))

    # --- identity --------------------------------------------------
    A('''
# --- Identity --------------------------------------------
# Only over SSH or as root. Locally it is noise you already know.
[username]
format = "{CHIP}"
style_user = "bold green"
style_root = "bold red"
show_always = false

[hostname]
format = "{HCHIP}"
style = "bold green"
ssh_only = true
'''.replace("{CHIP}", chip("[$user]($style)"))
   .replace("{HCHIP}", chip("[$hostname]($style)")))

    # --- toolchains ------------------------------------------------
    A("\n# --- Toolchains ------------------------------------------\n"
      "# Version chips, shown only in a directory that actually uses the\n"
      "# language. Near-free: `starship timings` puts each under 1ms,\n"
      "# because a directory with no marker file short-circuits at once.\n")
    for mod, icon, style in [
        ("golang", "go", "bold cyan"),
        ("nodejs", "node", "bold green"),
        ("python", "python", "bold yellow"),
        ("rust", "rust", "bold orange"),
        ("lua", "lua", "bold blue"),
        ("java", "java", "bold red"),
        ("c", "c", "bold blue"),
        ("terraform", "terraform", "bold magenta"),
        ("helm", "helm", "bold cyan"),
    ]:
        A('[%s]\nformat = "%s"\nsymbol = "%s "\nstyle = "%s"\n\n'
          % (mod, chip("[$symbol($version)]($style)"), u(I[icon]), style))

    A('''[package]
format = "{PCHIP}"
symbol = "{PKG} "
style = "bold yellow"

[docker_context]
format = "{DCHIP}"
symbol = "{DOCKER} "
style = "bold blue"
only_with_files = true

[aws]
format = "{ACHIP}"
symbol = "{AWS} "
style = "bold orange"

[kubernetes]
format = "{KCHIP}"
symbol = "{K8S} "
style = "bold cyan"
# Off by default. It reads ~/.kube/config on every prompt, and quietly
# displaying a cluster you had stopped thinking about is how a command
# ends up running against prod. Turn on when you want it.
disabled = true
'''.replace("{PCHIP}", chip("[$symbol$version]($style)"))
   .replace("{DCHIP}", chip("[$symbol$context]($style)"))
   .replace("{ACHIP}", chip("[$symbol($profile)(" + LP + "$region" + RP + ")]($style)"))
   .replace("{KCHIP}", chip("[$symbol$context( " + LP + "$namespace" + RP + ")]($style)"))
   .replace("{PKG}", u(I["package"])).replace("{DOCKER}", u(I["docker"]))
   .replace("{AWS}", u(I["aws"])).replace("{K8S}", u(I["k8s"])))

    # --- disabled --------------------------------------------------
    A('''
# --- Noise control ---------------------------------------
# Explicitly disabled rather than left alone: starship still probes for a
# module it has not been told to skip.
[battery]
disabled = true

[gcloud]
disabled = true

[nix_shell]
disabled = true

[memory_usage]
disabled = true

[line_break]
disabled = false
''')

    # --- palettes --------------------------------------------------
    A("\n# --- Palettes --------------------------------------------\n"
      "# Mirrors theme/palettes/*.sh. Selected by the top-level `palette`\n"
      "# key in the header, which scripts/theme rewrites.\n")
    for name, colors in PALETTES.items():
        A("\n[palettes.%s]\n" % name)
        for key, value in colors.items():
            A('%s = "%s"\n' % (key, value))

    text = "".join(out)
    assert all(ord(c) < 128 for c in text), "non-ASCII leaked into the output"

    # Ghostty runs with background-opacity 0.86 + blur. A styled
    # background in the prompt is an opaque cell, which punches a solid
    # strip through the glass -- the exact reason the powerline presets
    # were rejected for this setup. Every style here must be
    # foreground-only, so fail the build rather than let one slip in.
    for lineno, line in enumerate(text.splitlines(), 1):
        stripped = line.lstrip()
        if stripped.startswith("#"):
            continue
        assert "bg:" not in line, (
            "line %d sets a background, which would break Ghostty's blur: %s"
            % (lineno, line))
    io.open("/Users/phil/.config/starship.toml", "w", encoding="ascii").write(text)
    print("wrote starship.toml (%d bytes, pure ASCII)" % len(text))


main()
