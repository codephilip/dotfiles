# Windows (optional)

The repo is macOS-first. Windows support is opt-in and entirely separate:
`make windows` runs `scripts/windows-setup`, and nothing in it touches what
the Macs read. `make install` refuses to run on Windows and points here.

```bash
# Git Bash, with scoop installed (https://scoop.sh)
git clone <this repo> ~/.config
cd ~/.config && make windows
```

Then open Alacritty: it starts in zsh, and `tmux` works from there.
Re-running is safe; every step checks before it acts.

## What it sets up

| Piece | Source | Notes |
|---|---|---|
| CLI tools, Alacritty, JetBrainsMono Nerd Font | scoop | same set as `bootstrap`'s brew lists |
| Neovim 0.11.x | scoop, **held** | the config targets 0.11; `scoop update` must not jump to 0.12 |
| zig | scoop | the C compiler treesitter uses to build parsers |
| zsh, tmux | MSYS2 (`~/msys64`) via `pacman` | real tmux, not the psmux clone |
| zsh-autosuggestions / -syntax-highlighting | git clone into `zsh/plugins/` | gitignored; `.zshrc` already falls back there |

## How tmux runs on Windows

tmux has no native Windows version. It needs Unix features like
pseudo-terminals, `fork()` and Unix sockets. MSYS2 (Cygwin underneath)
provides these through `msys-2.0.dll`, so its `zsh.exe` and `tmux.exe`
are real Windows binaries that behave like Unix programs. Git Bash uses
the same layer but ships no package manager, which is why full MSYS2
is needed.

```
Alacritty.exe
  └─ ~/msys64/usr/bin/zsh.exe --login     (alacritty/local.toml)
       └─ tmux                             (reads ~/.config/tmux/tmux.conf)
            └─ nvim, lazygit, k9s, …       (native, from scoop)
```

## The Windows-only glue

- **`alacritty/local.toml`**: generated and gitignored. `alacritty.toml`
  imports it, and Alacritty skips the import when the file is missing, so
  macOS is unaffected. It sets zsh as the shell and these variables:
    - `MSYS2_PATH_TYPE=inherit` keeps the Windows PATH, so scoop's tools resolve.
    - `CHERE_INVOKING=1` starts the shell in the current directory.
    - `HOSTNAME` is preset so `/etc/profile` skips `hostname.exe`, which
      application control can block.
- **`~/.zshenv`**: `export ZDOTDIR="$HOME/.config/zsh"`. Used instead of a
  `~/.zshrc` symlink, because Windows file symlinks need admin or Developer Mode.
- **`~/msys64/etc/nsswitch.conf`**: `db_home: /c/Users/%U`. MSYS2's
  default asks AD for the home directory. On a domain account that lookup
  can fail and fall back to `/home/<user>`, which hides every dotfile.
- **`%APPDATA%\alacritty`**: Alacritty on Windows reads only this directory.
  The script creates it as a junction to `~/.config/alacritty` if it's missing.

## Managed-machine gotchas

- **7-Zip blocked**: `scoop install msys2` extracts with 7z, and application
  control may refuse to run `7z.exe` ("Access is denied"). The script avoids
  this by unpacking the MSYS2 tarball with Git Bash's `tar`.
- **Don't run MSYS2's zsh from inside Git Bash** for testing. The two
  `msys-2.0.dll` runtimes interfere (wrong `$HOME`, odd permission errors).
  Launch it from Alacritty, `cmd` or PowerShell.
- **Treesitter parsers** build on first nvim start, in the background.
  Leave that first session open until they finish, or run `:TSUpdateSync`.
