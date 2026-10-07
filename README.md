# Developer Configuration

A comprehensive collection of configuration files for a modern developer environment. This repository contains configurations for terminal, shell, editor, and development tools.

## 📋 Overview

This configuration setup is designed for macOS/Linux systems with a focus on minimal, fast, and remote-friendly tooling. Each configuration is self-contained and can be used independently.

## 🚀 Quick Start

This repository *is* `~/.config`, so most tools (Neovim, Ghostty, Alacritty, tmux)
already find their config at the XDG path with no setup. Only the few files that
have to live outside `~/.config` need linking.

`make install` deliberately **reports** missing tools rather than installing
them, so adopting this on a new machine is five steps, not one:

```bash
# 1. Homebrew — nothing here installs it for you
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Clone. The path matters — see "Cloning somewhere else" below.
git clone https://github.com/codephilip/dotfiles.git ~/.config

# 3. Tools. `make verify` prints this same list filtered to what you're missing.
brew install bat delta eza fd fzf lazygit neovim ripgrep starship tmux \
             zoxide zsh-autosuggestions zsh-syntax-highlighting
brew install --cask ghostty alacritty font-jetbrains-mono-nerd-font

# 4. Symlinks + generated theme files
cd ~/.config
make verify    # dry run — show what would change
make install

# 5. Pick up the new shell, then let the editor bootstrap itself
exec zsh
nvim           # lazy.nvim self-installs; then :Mason for the language servers
```

`make install` is idempotent and never overwrites a real file — if `~/.zshrc`
already exists as a regular file, it says so and leaves it alone. It links
`~/.zshrc`, `~/.tmux.conf` and `~/.gitconfig`, lists any missing formulae and
casks as copy-pasteable `brew install` lines, then runs `theme regen` to write
the generated colour fragments (a fresh clone has none — they are gitignored)
and fetch the `bat` theme Tokyo Night needs.

### Four things `make install` can't do for you

These are per-machine or secret, so they are not in the repo and nothing
checks for them:

| What | Command | Needed for |
| --- | --- | --- |
| SSH config | restore `ssh/config` from your password manager | the `github`, `prox-*`, `macmini*` and Hetzner hosts |
| GitHub auth | `gh auth login` | `gh`; the token lives in the keychain, not here |
| Secrets | create `~/.zshrc.local` with `export ANTHROPIC_API_KEY=…` | CodeCompanion in Neovim (inert without it) |
| Docs toolchain | `pip install mkdocs-material` | `make serve` / `make docs` only |

`ssh/config` is gitignored — it used to be an Ansible Vault blob in the repo,
but it is local-only now, so a rebuild needs it from elsewhere. `bootstrap`
reports `not in repo, nothing to link` and carries on.

### Cloning somewhere else

`git clone … ~/.config` fails if `~/.config` already exists with content,
which is common on a machine that has been used. Adopt the directory in place
instead:

```bash
git init ~/.config && cd ~/.config
git remote add origin https://github.com/codephilip/dotfiles.git
git fetch origin && git checkout -f main
```

Cloning to a path *other* than `~/.config` only half-works: `bootstrap` and
`scripts/theme` both resolve the repo from their own location, so linking and
theme generation are correct — but every tool that reads an XDG path (Neovim,
Ghostty, Alacritty, starship) still looks in `~/.config` and will not see the
clone. Symlink `~/.config` at it, or clone there in the first place.

Per-tool details and manual steps are in the sections below.

## 🔧 Core Dependencies

### Required System Tools

- **Git** - Version control (required for Neovim plugins, git aliases, and various integrations)
- **Neovim** (0.11+) - Required, not just recommended: the LSP config uses the
  native `vim.lsp.config` / `vim.lsp.enable` API added in 0.11
- **tmux** - Terminal multiplexer
- **Zsh** - Shell (uses built-in features, no Oh My Zsh required)
- **ripgrep** (rg) - Fast text search (required for Neovim `:Rg` command)
- **bat** - Syntax-highlighted pager (required for zsh pager and cheatsheet viewing)
- **fzf** - Fuzzy finder (required for Neovim file navigation)

### Optional but Recommended

- **Docker** - Container platform (for docker aliases)
- **kubectl** - Kubernetes CLI (for k8s aliases)
- **lsof** - List open files (for `ports()` and `killport()` functions)

## 📁 Configuration Files

### Theme (`theme/`, `scripts/theme`)

One palette drives the terminal, prompt, fzf, Neovim, `bat` and `delta`.
Three are available; switch with a single command:

```bash
theme list              # all themes, active one marked
theme solarized-osaka   # switch
theme next              # cycle
theme show              # swatches for the active palette
```

| Theme | Look |
| --- | --- |
| `tokyonight` | cool blue-violet on near-black (default) |
| `solarized-osaka` | deep teal-black, Solarized accents |
| `catppuccin-mocha` | warm, soft, low-contrast |

`theme/palettes/<name>.sh` is the single source of truth. The per-tool
fragments (`ghostty/theme.conf`, `alacritty/theme-current.toml`,
`git/theme.gitconfig`) are **generated** from it and gitignored — don't
hand-edit them, and don't put colours in `ghostty/config` or
`alacritty.toml`. Full detail: [`docs/theming.md`](docs/theming.md).

### Ghostty (`ghostty/`) — primary terminal

Ghostty is the daily driver because it is the only emulator here that can
**blur its background on macOS**. Alacritty has `window.opacity`, but
nothing behind the window is blurred, so the same value that reads as
frosted glass in Ghostty just looks muddy.

**Key Features:**
- `background-opacity = 0.86` + `background-blur = macos-glass-regular`
- Window padding: 14pt horizontal, 12pt vertical; titlebar hidden
- `JetBrainsMono Nerd Font` at 13.5pt, `adjust-cell-height = 8%`
- Beam cursor with blinking; `copy-on-select`
- Shift+Enter sends ESC CR (needed by Claude Code and most REPLs)

Reload config with ⌘⇧, — Ghostty has no CLI reload.

### Alacritty (`alacritty/`) — fallback

Kept because it works everywhere, including over X forwarding and on
Linux. Tracks the same palette, so switching between the two is not a
visual jump.

**Font Requirements:**
- **JetBrains Mono Nerd Font** must be installed
  - Regular style
  - Bold style  
  - Italic style
- Font size: 13.5pt with y-offset of 1

**Color Scheme:**
- Generated — imports `alacritty/theme-current.toml`, written by `theme`

**Key Features:**
- Window padding: 14px horizontal, 12px vertical
- Opacity: 0.92 — deliberately higher than Ghostty's 0.86, since without
  blur a lower value is just hard to read
- `live_config_reload`, so a theme switch applies without a restart
- Scrollback history: 10,000 lines
- Selection automatically copied to clipboard
- Beam cursor with blinking enabled

**Installation:**
- On macOS: Install JetBrains Mono via Homebrew (`brew install font-jetbrains-mono`) or download from [JetBrains](https://www.jetbrains.com/lp/mono/)
- On Linux: Install via package manager or download from JetBrains website

### Neovim (`nvim/`)

**Plugin Manager:**
- **lazy.nvim** - Automatically bootstrapped on first run

**Core Dependencies:**
- **fzf** - Must be installed and built (`fzf` binary in PATH)
- **ripgrep** - Required for `:Rg` search command (`rg` binary in PATH)
- **git** - Required for git integration (gitsigns, fzf git commands)

**LSP Servers (installed via Mason.nvim):**
- `lua_ls` - Lua Language Server
- `ts_ls` - TypeScript/JavaScript Language Server
- `pyright` - Python Language Server
- `gopls` - Go Language Server
- `rust_analyzer` - Rust Language Server
- `bashls` - Bash Language Server
- `yamlls` - YAML Language Server
- `jsonls` - JSON Language Server

**Treesitter Parsers (auto-installed):**
- lua, vim, bash, json, yaml, javascript, typescript, html, css, python

**Keybindings:**
- `<Space>` - Leader key
- `<leader>e` - Toggle file tree (nvim-tree)
- `<leader>ff` - Find files (fzf)
- `<leader>fg` - Find git files
- `<leader>fb` - Find buffers
- `<leader>fw` - Search with ripgrep
- `<leader>f` - Format code (LSP)
- `gd` - Go to definition (LSP)
- `gr` - Go to references (LSP)
- `K` - Hover documentation (LSP)
- `<leader>rn` - Rename symbol (LSP)
- `<C-h/j/k/l>` - Navigate windows (works with tmux via vim-tmux-navigator)

**Plugins:**
- nvim-tree.lua - File tree
- fzf.vim - Fuzzy finder
- nvim-treesitter - Syntax highlighting
- gitsigns.nvim - Git signs in gutter
- nvim-cmp + sources - Autocompletion
- nvim-lspconfig - LSP client
- mason.nvim - LSP server installer
- vim-tmux-navigator - Seamless tmux/neovim navigation
- bufdelete.nvim - Safe buffer deletion
- LuaSnip - Snippet engine (for LSP snippets)

**Installation:**
1. Ensure Neovim 0.9+ is installed
2. Install fzf: `brew install fzf` (macOS) or via package manager
3. Install ripgrep: `brew install ripgrep` (macOS) or via package manager
4. Link config: `ln -s ~/.config/nvim ~/.config/nvim` (if needed)
5. Launch Neovim - plugins will auto-install via lazy.nvim
6. LSP servers will be installed automatically via Mason when you open files

### tmux (`tmux/`)

**Terminal Requirements:**
- **tmux-256color** terminal capability - Your terminal must support 256-color mode
- On macOS, this is typically enabled by default in modern terminals
- On Linux, you may need to ensure `TERM=tmux-256color` is set

**Keybindings:**
- Prefix: `Ctrl-a` (changed from default `Ctrl-b`)
- `|` - Split window vertically
- `-` - Split window horizontally
- `h/j/k/l` - Navigate panes (vim-style)
- `H/J/K/L` - Resize panes
- `r` - Reload config
- `q` - Detach session

**Features:**
- Mouse support enabled
- History limit: 50,000 lines
- Vim-style copy mode
- Window/pane indexing starts at 1
- Status bar shows session name and hostname (when SSH'd)

**Plugin Directories (Optional):**
The `plugins/` directory contains plugin folders, but no TPM configuration is present. These plugins are not automatically loaded unless TPM is configured separately:
- nord-tmux (theme)
- tmux-prefix-highlight
- tmux-sensible
- tmux-sessionx
- tmux-yank
- vim-tmux-navigator (also in Neovim)

**Installation:**
1. Install tmux: `brew install tmux` (macOS) or via package manager
2. Link config: `ln -s ~/.config/tmux/tmux.conf ~/.tmux.conf`
3. Ensure your terminal supports 256-color mode

### Zsh (`zsh/`)

**Dependencies:**
- **bat** - Required for pager (`LESSOPEN`) and cheatsheet commands
- **git** - Required for git aliases and prompt integration
- **Docker** (optional) - For docker aliases
- **kubectl** (optional) - For k8s aliases
- **lsof** - Required for `ports()` and `killport()` functions (usually pre-installed on macOS)

**Features:**
- starship prompt — bracketed segments with Nerd Font icons, themed from
  the shared palette. `starship.toml` is generated by
  `scripts/gen-starship.py`; `zsh/prompt.zsh` is the faster pure-zsh
  fallback. See [`docs/shell/index.md`](docs/shell/index.md)
- No framework — no oh-my-zsh, prezto, zinit or antigen
- 50,000 line history with sharing across sessions
- Case-insensitive globbing
- Autocompletion with menu selection

**Aliases:**
- Git aliases: sourced from `~/.config/git/aliases.sh`
- Docker aliases: sourced from `~/.config/docker/aliases.sh`
- Kubernetes aliases: sourced from `~/.config/k8s/aliases.sh`
- Cheatsheet commands: `git-commands`, `k8s-commands`, `docker-commands`, `tmux-commands`, `zsh-commands`, `nvim-commands`

**Functions:**
- `mkcd <dir>` - Create directory and cd into it
- `cdr` - Jump to git repository root
- `ports` - Show active listening ports
- `killport <port>` - Kill process on specified port
- `dkclean` - Docker system prune
- `kctxp` - Show current kubectl context

**Auto-tmux:**
- Automatically attaches/creates tmux session when SSH'ing into a server

**macOS-specific:**
- Disables press-and-hold character accent menu

**Installation:**
1. Ensure zsh is your default shell (usually default on macOS)
2. Install bat: `brew install bat` (macOS) or via package manager
3. Link config: `ln -s ~/.config/zsh/.zshrc ~/.zshrc`
4. Source it: `source ~/.zshrc` or restart terminal

### Git (`git/`)

**Configuration:**
- User name: `codephil`
- User email: `philip@meiers.in`

**Aliases (`git/aliases.sh`):**
Extensive git aliases for common operations:
- Status: `gs`, `gss`
- Logs: `gl`, `glg`, `gla`
- Branches: `gb`, `gbv`, `gbd`
- Checkout/Switch: `gco`, `gcob`, `gsw`, `gswc`
- Add/Commit: `ga`, `gaa`, `gc`, `gcm`, `gca`, `gcan`
- Fetch/Pull/Push: `gf`, `gfa`, `gp`, `gpo`, `gpm`
- Rebase: `grb`, `grbi`, `grbc`, `grba`
- Diff: `gd`, `gds`
- Stash: `gsh`, `gshp`, `gshl`

**Installation:**
- Git aliases are automatically sourced by zsh config if `~/.config/git/aliases.sh` exists
- Git config can be linked: `ln -s ~/.config/git/gitconfig ~/.gitconfig`

### Docker (`docker/`)

**Aliases (`docker/aliases.sh`):**
- Base: `d`, `dc`
- Containers: `dps`, `dpa`, `dst`
- Images: `di`
- Logs/Exec: `dl`, `dlf`, `dex`
- Build/Run: `db`, `dr`, `drm`, `drmi`
- Compose: `dcu`, `dcud`, `dcd`, `dcb`, `dcl`, `dclf`
- Cleanup: `dclean`, `dcleanf`

**Installation:**
- Aliases are automatically sourced by zsh config if `~/.config/docker/aliases.sh` exists
- Requires Docker to be installed

### Kubernetes (`k8s/`)

**Aliases (`k8s/aliases.sh`):**
- Base: `k`
- Get: `kgp`, `kgs`, `kgd`, `kgn`, `kgi`, `kgcm`, `kgsec`
- Describe: `kdp`, `kdd`, `kds`
- Logs: `kl`, `klf`, `klp`
- Exec: `kex`, `ksh`, `kbash`
- Apply/Delete: `ka`, `kdel`
- Context/Namespace: `kctx`, `kctxs`, `kns`, `knsa`
- Rollout: `kro`, `kru`
- Metrics: `ktp`, `ktn`

**Installation:**
- Aliases are automatically sourced by zsh config if `~/.config/k8s/aliases.sh` exists
- Requires kubectl to be installed

### SSH (`ssh/`) — not tracked

`ssh/` is gitignored. The config was previously committed as an Ansible Vault
blob, but the repo is public and the decrypted file contains host names and
addresses, so it is local-only now. Keep a copy in your password manager.

**On a new machine:**
```bash
# restore ssh/config from your password manager, then:
chmod 600 ~/.config/ssh/config
make install        # links it to ~/.ssh/config
```

`make install` links `~/.ssh/config` when the file is present and reports
`not in repo, nothing to link` when it isn't — it is never an error.

### Command Cheatsheets (`command-cheatsheets/`)

Markdown cheatsheets for:
- docker.md
- git.md
- k8s.md
- nvim.md
- tmux.md
- zsh.md

**Viewing:**
- Use aliases: `git-commands`, `k8s-commands`, `docker-commands`, `tmux-commands`, `zsh-commands`, `nvim-commands`
- These use `bat` for syntax highlighting

## 📦 Installing Dependencies

Symlinking is handled by `make install` (see [Quick Start](#-quick-start)) —
these are just the packages. `make install` also reports which of them are
missing, so you can run it first and paste the command it gives you.

### macOS

This is the same list `bootstrap` checks for, kept in sync with
`BREW_FORMULAE` and `BREW_CASKS` in that file.

```bash
brew install bat delta eza fd fzf lazygit neovim ripgrep starship tmux \
             zoxide zsh-autosuggestions zsh-syntax-highlighting
brew install --cask ghostty alacritty font-jetbrains-mono-nerd-font
```

The font must be the **Nerd Font** build — plain JetBrains Mono has no glyphs
for the icons in the Neovim statusline, file tree or prompt.

### Linux

```bash
# Debian/Ubuntu — note bat is `batcat` and fd is `fdfind` on apt
sudo apt install neovim tmux fzf ripgrep bat fd-find git zsh

# Not in apt; install via Homebrew on Linux, cargo, or the release pages:
#   delta eza lazygit starship zoxide
```

JetBrains Mono Nerd Font: download the patched build from
<https://github.com/ryanoasis/nerd-fonts/releases> — the upstream JetBrains
release is unpatched and will render icons as tofu.

## 🔗 Integration Notes

### Neovim + tmux Navigation
- The `vim-tmux-navigator` plugin enables seamless navigation between Neovim windows and tmux panes using `Ctrl-h/j/k/l`
- Works automatically when both are configured

### Zsh + Neovim
- `EDITOR` and `VISUAL` environment variables are set to `nvim`
- Git commits and other editor operations will use Neovim

### Zsh + bat
- `bat` is used as the pager for `less` (via `LESSOPEN`)
- Cheatsheet commands use `bat` for syntax highlighting

### Terminal + tmux
- tmux's status line is two greys on `bg=default`, so it inherits the
  terminal's background and palette rather than defining its own. That is
  what keeps Ghostty's blur visible behind the status line, and it means
  tmux needs no per-theme config at all
- `terminal-overrides` must name `xterm-ghostty` explicitly — Ghostty's
  `$TERM` matches neither `*256col*` nor `alacritty`, and without it every
  colour inside tmux silently drops to 256

## 📝 Notes

- This configuration does **not** use Oh My Zsh - it relies on built-in zsh features
- Neovim plugins are managed via `lazy.nvim` and auto-install on first run
- LSP servers are installed via `mason.nvim` when needed
- tmux plugins in the `plugins/` directory are not automatically loaded (no TPM config)
- SSH config is encrypted with Ansible Vault for security
- All aliases are modular and can be sourced independently
