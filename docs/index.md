# Dotfiles

Working reference for the setup in `~/.config`. Everything here describes what is
actually installed and configured, not what could be.

!!! tip "Looking for the one-page summary?"
    The [executive brief](assets/executive-brief.pdf) is a print-ready PDF covering the
    Neovim config in seven pages. This site is the long form.

## The stack

| Layer | Choice | Why |
|---|---|---|
| Editor | Neovim 0.11.2 | 27 plugins, tuned for reading unfamiliar code |
| Shell | zsh | starship prompt, fzf, zoxide, autosuggestions |
| Terminal | Ghostty (Alacritty as fallback) | only one that blurs its background on macOS |
| Multiplexer | tmux | auto-attaches over SSH |
| Theming | one palette, three themes | [`theme <name>`](theming.md) switches every tool at once |
| AI | Claude Code + CodeCompanion | diff-reviewed edits inside the editor |

## Setting this up on a new machine

The install sequence lives in the
[README](https://github.com/codephilip/dotfiles#-quick-start) rather than here,
for the obvious reason that this site needs `mkdocs-material` installed before
you can read it.

The short version: install Homebrew, clone to `~/.config`, `brew install` the
formulae and casks, `make install`, then open `nvim` and let lazy.nvim
bootstrap. Four things are deliberately not in the repo and have to be restored
by hand — `ssh/config`, `gh auth login`, a `~/.zshrc.local` holding
`ANTHROPIC_API_KEY`, and the docs toolchain. The README has the table.

## Layout

```text
~/.config/
├── nvim/              Neovim config — see the Neovim section
├── zsh/.zshrc         symlinked from ~/.zshrc
├── zsh/plugins/       vendored fzf-tab, so a clone needs nothing fetched
├── starship.toml      prompt (theme/ generates starship-current.toml)
├── git/gitconfig      symlinked from ~/.gitconfig
├── ghostty/           primary terminal
├── alacritty/         fallback terminal
├── tmux/              multiplexer
├── theme/             palettes + active theme; scripts/theme generates from these
├── scripts/           theme switcher, starship generator
├── bootstrap          symlinks + tool report; run via `make install`
├── command-cheatsheets/   quick `bat`-rendered references
└── docs/              this site
```

Generated files (`ghostty/theme.conf`, `alacritty/theme-current.toml`,
`git/theme.gitconfig`, `starship-current.toml`) are gitignored and absent from a
fresh clone — `make install` writes them. Never hand-edit them; see
[Theming](theming.md).

## Start here

<div class="grid cards" markdown>

-   __Neovim__

    ---

    The centrepiece. Architecture, every plugin and what it does, the bindings
    worth memorising, and the Claude review loop.

    [:octicons-arrow-right-24: Neovim](neovim/index.md)

-   __Shell__

    ---

    What `ll` now does, the fzf bindings you did not have before, and how the
    prompt is assembled.

    [:octicons-arrow-right-24: Shell](shell/index.md)

-   __tmux__

    ---

    Every key, stock prefix and all, plus the two things this config changes.

    [:octicons-arrow-right-24: tmux](tmux.md)

-   __Docker and Kubernetes__

    ---

    The `docker`, `kubectl` and k9s shortcuts, and which cleanup command
    deletes your volumes.

    [:octicons-arrow-right-24: Docker and Kubernetes](containers.md)

-   __Terminal__

    ---

    Fonts, themes, and the one setting that controls whether icons render at all.

    [:octicons-arrow-right-24: Terminal](terminal.md)

-   __Troubleshooting__

    ---

    The failure modes that have actually happened here, with the fix for each.

    [:octicons-arrow-right-24: Troubleshooting](troubleshooting.md)

</div>

## Conventions

Keys are written as they are pressed. The Neovim leader is ++space++, so
++space++ ++f++ ++f++ means *press space, then f, then f* — not a chord.

Commands you run in a shell are shown without a prompt character so they can be
copied directly:

```bash
nvim --headless "+Lazy! sync" +qa
```

## Rebuilding this site

```bash
cd ~/.config
make serve     # live-reload on http://127.0.0.1:8000
make docs      # build static site into ./site
make pdf       # regenerate the executive brief PDF
```
