# Aliases and functions

Every shortcut `.zshrc` defines, in one place. Tool-specific sets have their
own pages:

- **git**: `gs`, `gl`, `gco`… on the [Git](../git.md#aliases) page
- **docker** and **kubectl**: `dps`, `kgp`, `ksh`… on the
  [Docker and Kubernetes](../containers.md) page

`alias` with no arguments lists everything defined in the current shell, and
`type <name>` tells you what a single one expands to.

## Files

`ls` and friends use [eza](https://github.com/eza-community/eza) when it is
installed, and fall back to plain `ls` flags when it is not.

| Alias | Does |
|---|---|
| `ls` | Icons, directories first |
| `ll` | Long listing: hidden files, git status column, relative dates |
| `la` | All files, no detail |
| `l` | One per line |
| `lt` / `ltt` | Tree, 2 / 3 levels deep |
| `llg` | Long listing that skips anything `.gitignore`d |

The `--git` column in `ll` and `llg` is explained in
[Shell](index.md#listing-files).

## TUIs

| Alias | Opens |
|---|---|
| `lg` | lazygit, for the repo you're in |
| `ld` | lazydocker. See [Docker and Kubernetes](../containers.md#lazydocker) |
| `k9s` | k9s, for the current kube context |

`ld` hides the system linker when you type it, but only then. Aliases never
apply inside scripts, so compilers still find the real `ld`. Type `command ld`
if you ever need it by hand.

## Hidden files

Dotfiles (`.env`, `.github/`, `.zshrc`) are hidden by default in plain `ls`
and shown by the long forms:

| Command | Dotfiles |
|---|---|
| `ls`, `l`, `lt`, `ltt` | Hidden |
| `ll`, `la`, `llg` | Shown |
| `ls -a`, `lt -a` | Shown. `-a` works with any of them |
| `ls -A` | Shown, without `.` and `..` (with plain `ls`, not eza) |

`llg` also drops anything matched by `.gitignore`, so a gitignored `.env` stays
out of it even though it's a dotfile.

Other places dotfiles do or don't appear:

- **fzf** (++ctrl+t++, ++alt+c++, `fv`) includes them, but skips `.git` and
  gitignored files. That comes from `fd --hidden` in `FZF_DEFAULT_COMMAND`.
- **Globs** don't match them. `rm *` leaves `.env` alone, and `ls *.yml` misses
  `.pre-commit-config.yml`. Write the dot explicitly: `ls .*.yml`.
- **Tab completion** only offers them once you've typed the leading `.`.

## Moving around

| Command | Does |
|---|---|
| `..` / `...` / `....` | Up 1, 2, 3 directories |
| `nvim/` | A bare directory name changes into it (`AUTO_CD`) |
| `cd -` | Previous directory |
| `z <partial>` | Jump to a frequently used directory (zoxide) |
| `zi` | Pick from zoxide's list interactively |
| `cdr` | Repo root of the current git repository |
| `mkcd <dir>` | `mkdir -p`, then `cd` into it |
| `cl` | `clear` |

## Safety nets

`rm`, `cp` and `mv` are aliased to their `-i` forms, so each one asks before
deleting or overwriting a file. To skip the prompt for one command, call the
real binary: `command rm file` or `\rm file`.

## Editing

| Alias | Does |
|---|---|
| `v` / `vi` / `vim` | `nvim` |
| `fv` | Fuzzy-find a file with a preview, open it in nvim |
| `zshrc` | Open `~/.config/zsh/.zshrc` |
| `nvimrc` | Open `~/.config/nvim/init.lua` |
| `zreload` | `exec zsh`: restart the shell to apply `.zshrc` edits |

## System

| Command | Does |
|---|---|
| `ports` | List every listening TCP port and its process |
| `killport <n>` | `kill -9` whatever holds port `n` |
| `theme <name>` | Switch the [theme](../theming.md) everywhere, then restart the shell |
| `theme` / `theme list` | Show the active theme / list the available ones |
| `theme next` | Cycle to the next theme |

## Cheatsheets

Each one prints a file from `~/.config/command-cheatsheets/` through `bat`:

| Alias | Covers |
|---|---|
| `zsh-commands` | zsh line editing and shell tricks |
| `git-commands` | git aliases and workflows |
| `docker-commands` | docker aliases |
| `k8s-commands` | kubectl aliases |
| `tmux-commands` | tmux keys |
| `nvim-commands` | Neovim keys |

## Local additions

`~/.zshrc.local` is sourced last and is never committed. Put
machine-specific aliases and secrets there.
