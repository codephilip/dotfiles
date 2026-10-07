# Theming

One palette drives the terminal, shell prompt, fzf, Neovim, `bat` and
`delta`. Switching it is one command:

```console
$ theme list
  catppuccin-mocha   warm, soft, low-contrast
  solarized-osaka    deep teal-black, Solarized accents (devaslife)
● tokyonight         cool blue-violet on near-black

$ theme solarized-osaka
✓ switched to Solarized Osaka
ghostty: ⌘⇧, to reload   nvim: restart   zsh: exec zsh
```

| Command | Does |
| --- | --- |
| `theme` | print the active theme name |
| `theme list` | all themes, active one marked |
| `theme show` | the active palette as colour swatches |
| `theme <name>` | switch |
| `theme next` | cycle to the next one |
| `theme regen` | re-emit the generated files without switching |

## The look

The thing that makes this feel like glass is not the colour scheme — it is
**blur plus padding plus transparency all the way down the stack**. Any one
of them alone looks unfinished.

- `background-opacity = 0.86` with `background-blur = macos-glass-regular`
  in `ghostty/config`
- 14pt / 12pt window padding, and `macos-titlebar-style = hidden`
- every Neovim colorscheme set `transparent`, including `sidebars` and
  `floats`
- fzf's `bg:-1` and `gutter:-1`, so it does not paint an opaque panel
- tmux's `bg=default` on every style, so the status line has no bar

Miss the last three and you get a blurred window with opaque rectangles
floating on it.

!!! warning "Alacritty cannot do this"
    Alacritty has `window.opacity` but **no background blur on macOS** — it
    composites the raw desktop behind your text rather than a frosted
    material. That is why Ghostty is the daily driver and Alacritty's
    opacity is set higher (`0.92`), where it still reads cleanly. Both
    track the same palette, so moving between them is not a visual jump.

## How it fits together

`theme/palettes/<name>.sh` is the single source of truth: a sourceable file
of `THEME_*` variables. Everything else either reads it or is generated
from it.

```text
theme/
  current              ← the active theme's name (tracked in git)
  palettes/
    tokyonight.sh      ← source of truth
    solarized-osaka.sh
    catppuccin-mocha.sh
```

**Generated** by `scripts/theme` — gitignored, never hand-edit:

| File | Consumed by |
| --- | --- |
| `ghostty/theme.conf` | `config-file = ?theme.conf` in `ghostty/config` |
| `alacritty/theme-current.toml` | `[general] import` in `alacritty.toml` |
| `git/theme.gitconfig` | `[include]` at the bottom of `git/gitconfig` |
| `starship-current.toml` | `$STARSHIP_CONFIG`, set in `.zshrc` |

**Read at startup** by the tool itself:

| Tool | Reads | Picks up a switch |
| --- | --- | --- |
| zsh | sources `current` + the palette; derives `BAT_THEME`, `FZF_DEFAULT_OPTS` | the `theme` shell function re-execs; other open shells need `exec zsh` |
| starship | `starship-current.toml`, whose `palette` line names the theme | next prompt, automatically |
| Neovim | `lua/config/theme.lua` reads `current` | restart |
| Ghostty | the generated `theme.conf` | ⌘⇧, (no CLI reload exists) |
| git / bat | the generated `theme.gitconfig` | next invocation |

### Why Neovim does not use the hex values

The palette has sixteen ANSI slots. Each colorscheme plugin ships far more
detail than that — treesitter captures, LSP semantic tokens, diagnostic
underlines. Re-deriving those from sixteen colours would be strictly worse,
so for Neovim the shared file only decides *which plugin* is in charge.

All three plugins are installed; `lazy` is set from the active name, so
exactly one loads at startup and the other two sit on disk unloaded. That
is why switching needs a restart rather than a `:Lazy sync`.

### The prompt

starship, in the **bracketed-segments** style with **nerd-font-symbols**
icons:

```text
{dir} .config [{branch} main] [●●●] [↑14 ↓4] [{go} v1.26.1] [{clock} 3s]
❯
```

Status is read by **colour, not syntax** — green staged, yellow modified,
grey untracked, red deleted or conflicted, cyan divergence. Nothing to
decode. (Icons appear as `{name}` tags here for the same reason they are
escapes in the config: PUA codepoints do not survive being written into a
document.)

Two properties are load-bearing here:
Two properties are load-bearing here:

- **No backgrounds anywhere.** Every style is foreground-only. A styled
  background is an opaque terminal cell, so a powerline-style prompt
  paints a solid strip straight through Ghostty's blur. The generator
  asserts on any `bg:` and refuses to build, so this cannot regress by
  accident.
- **`starship.toml` is generated**, by `scripts/gen-starship.py`. Every
  icon is a Private Use Area codepoint, and PUA characters get silently
  dropped or substituted by editors, clipboards and diff tooling — a
  missing icon leaves no trace in a review. The generator emits them as
  `\uXXXX` escapes, so the file is pure ASCII and what you read is what
  starship gets. Regenerate rather than hand-editing.

!!! warning "Two TOML traps this cost real time to find"
    Escapes only work in TOML **basic** (double-quoted) strings. In a
    literal `'single-quoted'` string, `` is seven raw characters,
    and starship rejects it with `expected escaped_char`. Separately,
    starship needs `\[` for a literal bracket, and a basic string needs
    its backslash doubled — so the file must contain `\\[`.

    And a bare TOML key binds to the most recent `[table]`: a `palette`
    line at the *bottom* of the file silently becomes
    `memory_usage.palette`. It lives in the header for that reason.

It costs ~17ms per prompt inside a git repo and ~5ms outside one, plus
~5ms of `starship init` per shell. `zsh/prompt.zsh`, the hand-rolled
pure-zsh prompt it replaced, does the same job in ~9ms and is kept
working as the fast fallback — `.zshrc` has a commented line to switch
back.

`starship timings` attributes ~11ms of that to `git_status` and
`git_branch`. The toolchain chips are under 1ms each, so trimming them
buys nothing — git state is simply what a prompt like this costs.

### Why tmux is not wired in

Deliberately. The status line is two greys — `colour243` and `colour252` —
on `bg=default`, and that is worth keeping:

1. They are palette **indices**, not hex, so they already follow whatever
   theme the terminal is on, for free.
2. `bg=default` means the status line inherits the terminal background
   instead of painting its own, which is what keeps the blur visible
   behind it.

Adding per-theme colours to `tmux.conf` would break both.

## Adding a theme

1. Copy a palette: `cp theme/palettes/tokyonight.sh theme/palettes/mine.sh`
2. Fill in the `THEME_*` values. `THEME_BAT` must name a theme `bat
   --list-themes` actually knows; `THEME_NVIM`/`THEME_LUALINE` are
   informational here.
3. Add the matching entry to `nvim/lua/config/theme.lua`'s `M.themes`,
   and a plugin spec in `nvim/lua/plugins/ui.lua`.
4. `theme mine`

Step 3 matters: an unknown name in `theme/current` falls back to
`tokyonight` in Neovim rather than throwing at startup, so a half-added
theme shows up as "the colorscheme didn't change", not as an error.

## Gotchas found while building this

Recorded because each one cost real time:

- **Ghostty's bundled `Solarized Osaka Night` is a byte-for-byte copy of
  `TokyoNight Night`.** A broken entry in their theme pack. The real
  palette here is converted from the upstream plugin's own HSL
  definitions, which is why `solarized-osaka.sh` has hex values rather
  than a `theme =` line.
- **`BAT_THEME=tokyonight_night` was silently doing nothing.** `bat` ships
  Catppuccin and Solarized but not Tokyo Night, so it fell back to its
  default. `theme` now fetches the `.tmTheme` and runs `bat cache
  --build`. Same for `delta`'s `syntax-theme`, which shares bat's
  registry.
- **A relative `[include] path` in `git/gitconfig` is silently skipped.**
  Git opens the file through the `~/.gitconfig` symlink without resolving
  it, so a relative path looks for `~/theme.gitconfig`. The include uses
  an absolute path for this reason.
- **The colorscheme is `solarized-osaka`, not `solarized-osaka-night`.**
  Unlike tokyonight, that fork's dark variant is the unsuffixed default.
- **Ghostty sets `TERM=xterm-ghostty`**, which matches neither `*256col*`
  nor `alacritty` in tmux's `terminal-overrides`. Without naming it, every
  colour inside tmux quietly drops to 256 — most visible as banding in
  Neovim. `tmux.conf` now lists it.
