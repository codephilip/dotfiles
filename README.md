# dotfiles

My `~/.config`. One repo for every machine: macOS, Linux desktops,
headless Linux servers and (optionally) Windows.

Neovim is the centrepiece, tuned for reading unfamiliar code and with Claude
wired in. Around it are zsh, tmux, Ghostty and one colour palette shared by
every tool.

> **Full docs:** run `make serve` and open <http://127.0.0.1:8000>, or browse
> [`docs/`](docs/index.md) here on GitHub. This README is the short version.

## The stack

| Layer | Choice | Notes |
| --- | --- | --- |
| Editor | Neovim ≥ 0.12 | lazy.nvim, native LSP, fzf-lua, blink.cmp, conform, Claude Code + CodeCompanion + Copilot |
| Shell | zsh, no framework | starship prompt, fzf, fzf-tab, zoxide, eza, autosuggestions |
| Multiplexer | tmux | prefix `Ctrl-a`, auto-attaches over SSH |
| Terminal | Ghostty (Alacritty fallback) | JetBrainsMono Nerd Font, blur/glass |
| Git | git + delta + lazygit + gh / gh-dash | PR review inside Neovim (diffview, octo) |
| Containers | docker / kubectl aliases, lazydocker, k9s | configs pulled back into `~/.config` |
| Theme | `tokyonight` · `solarized-osaka` · `catppuccin-mocha` | `theme <name>` switches every tool at once |

## Quick start

This repo **is** `~/.config`, so clone it there. `make install` links the few
files that live outside `~/.config` and **reports** missing tools without
installing them.

```bash
# macOS and Linux: Homebrew is the package manager on both
# (Linux needs build tools + zsh first, see docs/setup.md)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

git clone https://github.com/codephilip/dotfiles.git ~/.config
cd ~/.config
make tools | sh    # install the tool list from bootstrap
make verify        # dry run: what would be linked, what's missing
make install       # link ~/.zshrc ~/.tmux.conf ~/.gitconfig (~/.ssh/config), generate theme files
exec zsh
nvim               # plugins install themselves; :Mason for language servers
```

**Windows:** `make windows` from Git Bash with scoop. See
[docs/windows.md](docs/windows.md).

After that, restore the things a public repo can't hold: `ssh/config`,
`gh auth login`, and `~/.zshrc.local` for secrets. On a Mac, also fix key
repeat. Both are covered in **[docs/setup.md](docs/setup.md)**, along with the
per-distro Linux steps, adopting an existing `~/.config`, and keeping machines
in sync.

## Everyday commands

```bash
make help            # every make target
make verify          # health report for this machine; changes nothing
make install         # re-run after a git pull (idempotent)

theme list           # themes, active one marked
theme next           # cycle; theme <name> to pick one

git-commands         # terminal cheatsheets rendered with bat. Also:
                     #   tmux- zsh- nvim- vim- docker- k8s-commands
```

Inside Neovim: press `Space` and wait, and which-key lists everything.
`:Doctor` checks the setup's health.

## Layout

```text
~/.config/
├── bootstrap             symlinks + tool report  (make install / verify / tools)
├── Makefile              entry point for everything
├── nvim/                 Neovim: init.lua, lua/config, lua/plugins, lazy-lock.json
├── zsh/                  .zshrc (→ ~/.zshrc), prompt fallback, vendored fzf-tab
├── tmux/tmux.conf        → ~/.tmux.conf
├── git/                  gitconfig (→ ~/.gitconfig), global ignore, aliases
├── ghostty/  alacritty/  terminals
├── starship.toml         prompt (generated from the palette by scripts/gen-starship.py)
├── theme/                palettes (source of truth) + the active theme name
├── docker/  k8s/         aliases, lazydocker and k9s configs
├── gh/  gh-dash/         GitHub CLI and PR dashboard
├── scripts/              theme, newscript, windows-setup, gen-starship.py
├── command-cheatsheets/  terminal-readable references
├── docs/  mkdocs.yml     the docs site
└── brief/                one-page executive brief (→ docs/assets/*.pdf)
```

Some files are **generated and gitignored**: `ghostty/theme.conf`,
`alacritty/theme-current.toml`, `git/theme.gitconfig`,
`starship-current.toml` and the k9s skin. `make install` creates them. Don't
edit them by hand.

**Not tracked, on purpose:** `ssh/`, `~/.zshrc.local`, `ghostty/local.conf`,
and the state other tools write into `~/.config` (gh tokens, stripe keys,
caches). See [`.gitignore`](.gitignore).

## Docs

The long-form docs are a [MkDocs Material](https://squidfunk.github.io/mkdocs-material/)
site in `docs/`:

```bash
brew install mkdocs-material   # once (or: pip install mkdocs-material)
make serve                     # live reload at http://127.0.0.1:8000
make docs                      # strict build into ./site; fails on dead links
```

| Page | What's there |
| --- | --- |
| [Setup](docs/setup.md) | new machine on macOS / Linux / Windows, secrets, syncing machines |
| [Neovim](docs/neovim/index.md) | architecture, every plugin, key bindings, PR review, CI, AI workflow |
| [Shell](docs/shell/index.md) | zsh, prompt, fzf bindings, aliases and functions |
| [tmux](docs/tmux.md) | every key, stock and ours |
| [Docker and Kubernetes](docs/containers.md) | aliases, lazydocker, k9s |
| [Terminal](docs/terminal.md) | Ghostty, Alacritty, fonts |
| [Theming](docs/theming.md) | how one palette reaches every tool, adding a theme |
| [Git](docs/git.md) | config, aliases, delta |
| [Windows](docs/windows.md) | scoop + MSYS2 setup |
| [Troubleshooting](docs/troubleshooting.md) | failures that actually happened, and their fixes |
| [Maintenance](docs/maintenance.md) | rules, checklists and the monthly routine that keep this repo accurate |

## Keeping it maintained

The short version of [docs/maintenance.md](docs/maintenance.md):

- **One source of truth per fact.** The tool list is in `bootstrap`, colours
  are in `theme/palettes/`, plugin versions are in `nvim/lazy-lock.json`.
  Docs link to these and don't copy them.
- **Machine-specific settings go in local files** (`~/.zshrc.local`,
  `ghostty/local.conf`), not in hostname checks.
- **Every new directory in `git status` gets a decision:** track and document
  it, or gitignore it.
- **Monthly:** `brew upgrade`, run the
  [Neovim routine](nvim/README.md#maintenance), `make verify`, `make docs`.
  Commit, then on each other machine run
  `git pull && make install && nvim "+Lazy restore"`.
