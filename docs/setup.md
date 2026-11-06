# New machine setup

One repo, every machine. This repo *is* `~/.config`, so Neovim, Ghostty,
Alacritty, starship and the rest find their config at the XDG path without
any setup. `make install` only links the few files that have to live outside
`~/.config`, and then it tells you what is still missing.

`make install` **reports** missing tools. It never installs them, so you
decide what goes on each machine. The steps below are the whole sequence.

!!! info "Homebrew everywhere, including Linux"
    The tool list in `bootstrap` is a list of Homebrew formulae. On Linux, use
    [Homebrew on Linux](https://docs.brew.sh/Homebrew-on-Linux) too. The
    alternative is distro packages, which cause three problems:

    - Debian and Ubuntu ship a Neovim older than the 0.11 this config needs.
    - apt renames binaries (`bat` becomes `batcat`, `fd` becomes `fdfind`),
      and `.zshrc` looks for the real names.
    - Half the list (`delta`, `eza`, `lazygit`, `starship`…) isn't packaged at
      all, so you end up with a mix of cargo, curl scripts and releases. The
      versions then drift between machines.

    With Homebrew, `make tools` prints the same install line on every machine.
    `.zshrc` and `bootstrap` already look for every Homebrew prefix
    (`/opt/homebrew`, `/usr/local`, `/home/linuxbrew/.linuxbrew`).

## Install

=== "macOS"

    ```bash
    # 1. Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # 2. Clone (the path matters, see "Cloning somewhere else" below)
    git clone https://github.com/codephilip/dotfiles.git ~/.config

    # 3. Tools: formulae + casks (terminals, Nerd Font)
    cd ~/.config && make tools | sh

    # 4. Symlinks + generated theme files
    make verify    # dry run, shows what would change
    make install

    # 5. New shell, then let the editor bootstrap itself
    exec zsh
    nvim           # lazy.nvim installs the plugins; then :Mason for language servers
    ```

    Then fix **key repeat** (see [below](#macos-key-repeat)), or holding
    ++j++ in Neovim moves one line at a time.

=== "Linux"

    ```bash
    # 1. Build prerequisites + zsh (pick your distro)
    sudo apt install build-essential procps curl file git zsh        # Debian / Ubuntu
    sudo dnf group install development-tools \
      && sudo dnf install procps-ng curl file git zsh                # Fedora
    sudo pacman -S --needed base-devel procps-ng curl file git zsh   # Arch

    # 2. Homebrew on Linux, then put it on PATH for this shell
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

    # 3. Clone
    git clone https://github.com/codephilip/dotfiles.git ~/.config

    # 4. Tools (formulae only, Linux has no casks)
    cd ~/.config && make tools | sh

    # 5. Symlinks + generated theme files
    make verify
    make install

    # 6. zsh as login shell. Use the system zsh: chsh only accepts
    #    shells listed in /etc/shells, and brew's zsh isn't in it.
    chsh -s "$(command -v /usr/bin/zsh || command -v zsh)"
    exec zsh
    nvim
    ```

    On a **desktop** Linux machine, also install:

    | What | How |
    | --- | --- |
    | JetBrainsMono **Nerd Font** | download from [nerd-fonts releases](https://github.com/ryanoasis/nerd-fonts/releases), unzip into `~/.local/share/fonts`, run `fc-cache -f` |
    | Terminal | [Ghostty](https://ghostty.org/docs/install) or `alacritty` from the distro |
    | Clipboard tool | `wl-clipboard` (Wayland) or `xclip` (X11). Neovim yanks to the system clipboard (`clipboard=unnamedplus`) and needs one of these |

    A **headless server** needs neither the font nor a terminal. Icons are
    drawn by the terminal on the machine you SSH *from*. `make verify` lists
    the desktop items separately, so you can skip them.

=== "Windows"

    Windows has its own installer (scoop + MSYS2). `make install` refuses to
    run there. Full detail is on the [Windows](windows.md) page.

    ```bash
    # Git Bash, with scoop installed (https://scoop.sh)
    git clone https://github.com/codephilip/dotfiles.git ~/.config
    cd ~/.config && make windows
    ```

`make install` is idempotent and never overwrites a real file. If `~/.zshrc`
already exists as a regular file, it tells you and leaves it alone. Here is
what it does:

1. Links `~/.zshrc`, `~/.tmux.conf`, `~/.gitconfig` and, if present,
   `~/.ssh/config`.
2. Lists missing tools as copy-pasteable `brew install` lines.
3. Runs `theme regen`, which writes the generated colour fragments (a fresh
   clone has none, they're gitignored) and fetches the `bat` theme that Tokyo
   Night needs.

## What the repo can't carry

These are per-machine or secret, so they aren't in the repo and nothing
checks for them:

| What | Command | Needed for |
| --- | --- | --- |
| SSH config | restore `ssh/config` from the password manager, `chmod 600`, re-run `make install` | the `github`, `prox-*`, `macmini*` and Hetzner hosts |
| GitHub auth | `gh auth login` | `gh`, gh-dash, octo.nvim. The token lives in the OS keychain |
| Secrets | create `~/.zshrc.local` with `export ANTHROPIC_API_KEY=…` | CodeCompanion in Neovim (inert without it) |
| Ghostty overrides | `ghostty/local.conf` (gitignored), e.g. `background-blur = macos-glass-regular` on macOS 26+ | per-machine terminal tweaks |
| Docs toolchain | `brew install mkdocs-material` (or `pip install mkdocs-material`) | `make serve` / `make docs` |

`~/.zshrc.local` is sourced last and gitignored. Put anything that differs
between machines there (secrets, work-only PATH entries, aliases for one
host) rather than adding `if hostname == …` branches to `.zshrc`.

## macOS key repeat

A stock Mac makes Neovim feel broken: holding ++j++ moves one line per press.
The fix is per-user macOS defaults, which can't live in a repo, so
`make install` reports them and you run them yourself. All three steps are
needed, in this order:

1. **System Settings → Keyboard.** Set *Key Repeat Rate* to the fastest notch
   and *Delay Until Repeat* to the shortest. Do this first. Writing the
   defaults without it doesn't take effect.
2. **Run:**
   ```bash
   defaults write -g KeyRepeat -int 1                      # below the slider's floor of 2
   defaults write -g InitialKeyRepeat -int 15
   defaults write -g ApplePressAndHoldEnabled -bool false  # no GUI control for this
   ```
3. **Log out and back in.** Relaunching the terminal isn't enough.

`make verify` reports the *stored* value, which is correct right away even
though the session still uses the old one. The only real test is holding ++j++
after logging out. More detail: [Troubleshooting](troubleshooting.md#holding-j-or-k-crawls-one-line-at-a-time).

## Cloning somewhere else

`git clone … ~/.config` fails if `~/.config` already has content, which is
common on a machine that has been in use. Adopt the directory in place
instead:

```bash
git init ~/.config && cd ~/.config
git remote add origin https://github.com/codephilip/dotfiles.git
git fetch origin && git checkout -f main   # -f: repo files win over existing ones
```

Check `git status` afterwards. Untracked files that tools wrote there stay
put, and the `.gitignore` already covers the common ones.

Cloning to a path *other* than `~/.config` only half works. `bootstrap` and
`scripts/theme` resolve the repo from their own location, so linking and
theme generation are fine. But every tool that reads an XDG path (Neovim,
Ghostty, Alacritty, starship) still looks in `~/.config`. Symlink `~/.config`
to the clone, or clone there in the first place.

## Keeping a machine in sync

After a change lands on another machine:

```bash
cd ~/.config
git pull
make install          # picks up new links, regenerates theme files
exec zsh
nvim "+Lazy restore"  # match plugins to the committed lazy-lock.json
```

Use **`:Lazy restore`** on the secondary machines, not `:Lazy update`.
`restore` checks out the exact commits that were vetted and committed,
while `update` pulls whatever upstream has now. Update on one machine, using
the [Neovim maintenance routine](https://github.com/codephilip/dotfiles/blob/main/nvim/README.md#maintenance),
commit the lockfile, then restore everywhere else.

### Version drift

Some tools arrive by several routes (native installer, npm, pip, cargo, a
direct download), so `make verify` has an **External tools** section that
prints each one's path, how it was probably installed, and its version:

```text
External tools
  not from this homebrew — compare versions across machines
  ✓ Claude Code 2.1.318
      /Users/pg/.local/bin/claude — native installer / pipx / uv
  ✓ mkdocs 1.6.1
      /opt/homebrew/bin/mkdocs — homebrew
```

A *missing* tool shows up as an error. The same tool installed three ways on
three machines just quietly runs three versions. Run `make verify` on each
machine now and then and compare.
