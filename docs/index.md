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
| Terminal | Warp (Alacritty also installed) | Nerd Font required for icons |
| Multiplexer | tmux | auto-attaches over SSH |
| AI | Claude Code + CodeCompanion | diff-reviewed edits inside the editor |

## Layout

```text
~/.config/
├── nvim/              Neovim config — see the Neovim section
├── zsh/.zshrc         symlinked from ~/.zshrc
├── starship.toml      prompt
├── git/gitconfig      symlinked from ~/.gitconfig
├── alacritty/         terminal (when using Alacritty)
├── tmux/              multiplexer
├── command-cheatsheets/   quick `bat`-rendered references
└── docs/              this site
```

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
