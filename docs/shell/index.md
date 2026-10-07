# Shell

zsh, configured in `~/.config/zsh/.zshrc` and symlinked from `~/.zshrc`.
Steady-state startup is around **50 ms** with five plugins loaded.

## What's installed

| Tool | Replaces | Does |
|---|---|---|
| [`eza`](https://github.com/eza-community/eza) | `ls` | icons, colour, git status per file, tree view |
| [`starship`](https://starship.rs) | custom `vcs_info` prompt | git state, k8s context, language versions |
| [`zoxide`](https://github.com/ajeetdsouza/zoxide) | some `cd` | `z nvim` jumps to frecent directories |
| [`fzf`](https://github.com/junegunn/fzf) | — | ++ctrl+r++ history, ++ctrl+t++ files, ++alt+c++ cd |
| `fzf-tab` | zsh menu completion | fuzzy ++tab++ completion with previews |
| `zsh-autosuggestions` | — | ghost text from history |
| `zsh-syntax-highlighting` | — | commands coloured as you type |
| [`delta`](https://github.com/dandavison/delta) | git's pager | side-by-side syntax-highlighted diffs |

## Load order is load-bearing

The plugin block at the bottom of `.zshrc` must stay in this order:

```text
1. fzf                      defines the widgets fzf-tab builds on
2. fzf-tab                  after compinit, before autosuggestions
3. zsh-autosuggestions
4. zoxide
5. starship
6. zsh-syntax-highlighting  MUST BE LAST — it wraps every preceding widget
```

!!! danger "Syntax highlighting goes last"
    It wraps every zle widget defined before it. Source it earlier and
    autosuggestions or fzf-tab will silently stop highlighting, or break.

## Listing files

```bash
ll        # long, icons, git status, relative dates
la        # all files, no detail
l         # one per line
lt        # tree, 2 levels
ltt       # tree, 3 levels
lg        # long, respecting .gitignore
```

The git column:

| Mark | Means |
|---|---|
| `-N` | new / untracked |
| `-M` | modified |
| `-I` | ignored |
| `--` | unchanged |

## The prompt

starship, in the **bracketed-segments** style with **nerd-font-symbols**
icons. Everything after the directory is a bracketed chip, and chips appear
only when they apply.

```text
{dir} .config [{branch} main][x!?↑14↓4][{go} v1.26.1][{clock} 3s]
❯
```

Icons are written as `{name}` tags above rather than pasted in: they are
Private Use Area codepoints, which get silently dropped in transit through
editors and clipboards — including, twice, while writing this page.

| Segment | Meaning |
|---|---|
| `{dir} .config` | path, truncated to 4 components, **bold** |
| `[{branch} main]` | git branch |
| `[x!?↑14↓4]` | git status — see below |
| `[{go} v1.26.1]` | toolchain version, only where the language is used |
| `[{clock} 3s]` | command duration, only past 2s |
| `❯` | green on success, **red** after a failed command |

Git status symbols. Note these are *presence* flags, not counts — only
divergence carries a number, because 14 vs 1 is what decides whether you
pull before you push:

| Symbol | Means |
|---|---|
| `!` | tracked files modified |
| `+` | staged changes |
| `x` | deletions |
| `?` | untracked files present |
| `»` | renames |
| `✗` | merge conflict |
| `↑n` / `↓n` | n commits ahead / behind |

!!! info "`x` for deleted, not `✘`"
    `✘` (U+2718) is **not** in JetBrains Mono Nerd Font — it would render
    through macOS font fallback at a different advance width. Every glyph in
    the prompt is checked against the font before use; see
    [Theming](../theming.md) for the check.

!!! warning "kubernetes is disabled by default"
    The module reads `~/.kube/config` on every prompt, and quietly displaying
    a cluster you had stopped thinking about is how a command ends up running
    against prod. Set `disabled = false` under `[kubernetes]` in the
    generator if you want it back.

### Configuration

`starship.toml` is **generated** by `scripts/gen-starship.py` — regenerate,
don't hand-edit. The icons are Private Use Area codepoints, which editors and
diff tooling silently drop; the generator emits them as `\uXXXX` escapes so
the file stays pure ASCII.

Colours follow the active [theme](../theming.md) automatically: all three
palettes live in `starship.toml`, and `theme <name>` writes
`starship-current.toml` with the `palette` line swapped. `$STARSHIP_CONFIG`
points at that generated copy.

Styles are **foreground-only, with no backgrounds** — a styled background is
an opaque terminal cell and would punch a solid strip through Ghostty's blur.
The generator asserts on any `bg:` and refuses to build, so it cannot
regress by accident.

!!! tip "The fast fallback"
    starship costs ~17ms per prompt in a git repo, ~5ms outside one, plus
    ~5ms of `starship init` per shell. `starship timings` puts ~11ms of that
    in `git_status` + `git_branch`; the toolchain chips are under 1ms each,
    so there is nothing useful to trim.

    `zsh/prompt.zsh` is a hand-rolled pure-zsh powerline prompt that does the
    same job in ~9ms using a single `git status --porcelain=v2` call. It is
    kept working and tested — `.zshrc` has a commented line to switch back.

## Functions

| Command | Does |
|---|---|
| `mkcd <dir>` | mkdir + cd |
| `cdr` | jump to the git repo root |
| `fv` | fuzzy-find a file, open in nvim |
| `fbr` | fuzzy-switch git branch |
| `ports` | list listening ports |
| `killport <n>` | kill whatever holds that port |
| `dkclean` | `docker system prune -af --volumes` |
| `kctxp` | print current kube context |

## Cheatsheets

The `command-cheatsheets/` directory is rendered with `bat`:

```bash
zsh-commands  git-commands  k8s-commands
docker-commands  tmux-commands  nvim-commands
```

## Editing

```bash
zshrc      # open this config in nvim
zreload    # exec zsh — reload after editing
```

Secrets go in `~/.zshrc.local`, which is sourced last and never committed.
