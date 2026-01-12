# Developer Configuration

A comprehensive collection of configuration files for a modern developer environment. This repository contains configurations for terminal, shell, editor, and development tools.

## 📋 Overview

This configuration setup is designed for macOS/Linux systems with a focus on minimal, fast, and remote-friendly tooling. Each configuration is self-contained and can be used independently.

## 🔧 Core Dependencies

### Required System Tools

- **Git** - Version control (required for Neovim plugins, git aliases, and various integrations)
- **Neovim** (0.9+) - Modern Vim editor with Lua configuration
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

### Alacritty (`alacritty/`)

**Font Requirements:**
- **JetBrains Mono** font family must be installed
  - Regular style
  - Bold style  
  - Italic style
- Font size: 13.5pt with y-offset of 1

**Color Scheme:**
- Uses Tokyo Night color theme (dark background: `#1a1b26`)

**Key Features:**
- Window padding: 14px horizontal, 12px vertical
- Opacity: 0.97
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
- Built-in git prompt (uses zsh `vcs_info`, no plugins needed)
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

### SSH (`ssh/`)

**Configuration:**
- Config file is encrypted with Ansible Vault
- Decrypt with: `ansible-vault decrypt ~/.config/ssh/config`

**Installation:**
- Link config: `ln -s ~/.config/ssh/config ~/.ssh/config`
- Ensure proper permissions: `chmod 600 ~/.ssh/config`

### PowerShell (`powershell/`)

**Git Aliases (`powershell/git-aliases.ps1`):**
Basic git aliases for PowerShell:
- `gst`, `ga`, `gc`, `gp`, `gl`, `gco`, `gcb`, `gb`, `gd`, `glog`

**Installation:**
- Source in PowerShell profile if using Windows

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

## 🚀 Quick Setup

### macOS

```bash
# Install core dependencies via Homebrew
brew install neovim tmux fzf ripgrep bat git

# Install fonts
brew install font-jetbrains-mono

# Link configurations (example)
ln -s ~/.config/zsh/.zshrc ~/.zshrc
ln -s ~/.config/tmux/tmux.conf ~/.tmux.conf
ln -s ~/.config/git/gitconfig ~/.gitconfig
ln -s ~/.config/nvim ~/.config/nvim  # if not already linked
ln -s ~/.config/alacritty ~/.config/alacritty  # if using Alacritty

# Restart terminal or source zshrc
source ~/.zshrc
```

### Linux

```bash
# Install core dependencies (example for Debian/Ubuntu)
sudo apt install neovim tmux fzf ripgrep bat git zsh

# Install JetBrains Mono font
# Download from https://www.jetbrains.com/lp/mono/ or use package manager

# Link configurations (same as macOS)
# ...
```

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

### Alacritty + tmux
- Alacritty's color scheme works well with tmux's 256-color mode
- Both use similar color palettes for consistency

## 📝 Notes

- This configuration does **not** use Oh My Zsh - it relies on built-in zsh features
- Neovim plugins are managed via `lazy.nvim` and auto-install on first run
- LSP servers are installed via `mason.nvim` when needed
- tmux plugins in the `plugins/` directory are not automatically loaded (no TPM config)
- SSH config is encrypted with Ansible Vault for security
- All aliases are modular and can be sourced independently
