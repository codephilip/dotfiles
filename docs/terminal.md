# Terminal

Three emulators are installed. **Ghostty is the daily driver**
(`ghostty/config`); Alacritty is the portable fallback; Warp is still on
disk but no longer configured against.

Ghostty is the primary for one specific reason: it is the only one of the
three that can **blur its background on macOS**. Alacritty has
`window.opacity`, but nothing behind the window is ever blurred, so the
same setting that reads as frosted glass in Ghostty just looks muddy.
See [Theming](theming.md) for the full picture.

!!! danger "They do not share settings"
    Setting a font in `alacritty.toml` does nothing for Ghostty or Warp, and
    vice versa. This has already caused one round of missing icons.

!!! tip "Colours are not set per-emulator"
    Ghostty's and Alacritty's palettes are **generated** from
    `theme/palettes/<name>.sh` — do not edit colours in `ghostty/config`
    or `alacritty.toml`. Run `theme <name>` instead.

## Fonts

Every glyph in the Neovim statusline, file tree, completion menu and starship
prompt comes from a **Nerd Font** configured in the terminal emulator. Neovim
cannot supply it.

Installed: `JetBrainsMono Nerd Font` (via `brew install --cask font-jetbrains-mono-nerd-font`).

=== "Ghostty"

    `~/.config/ghostty/config`:

    ```ini
    font-family = JetBrainsMono Nerd Font
    font-size = 13.5
    adjust-cell-height = 8%
    font-thicken = true
    ```

    `adjust-cell-height` is the line-height knob — it adds leading without
    clipping descenders, which is what `[font.offset]` was approximating in
    Alacritty. `ghostty +list-fonts` shows what is actually available.

    Reload with ⌘⇧, — Ghostty has no CLI reload.

=== "Warp"

    `~/.warp/settings.toml`:

    ```toml
    [appearance.text]
    font_name = "JetBrainsMono Nerd Font"
    font_size = 13.0
    line_height_ratio = 1.3
    ```

    Warp's default is `Hack`, which has **no** Nerd Font glyphs. Restart Warp
    after editing.

    If settings sync overwrites the file, set it in the UI instead:
    Settings → Appearance → Text → Terminal Font.

=== "Alacritty"

    `~/.config/alacritty/alacritty.toml`:

    ```toml
    [font.normal]
    family = "JetBrainsMono Nerd Font"
    style = "Regular"
    ```

### Verifying

If these render as boxes, the font is not active:

```text
     ⎈ 󱁢 
```

## Theme

Alacritty is themed **Tokyo Night**. Neovim uses **Catppuccin Mocha** with a
transparent background, so the terminal's background and opacity show through.
starship matches Tokyo Night so the prompt and editor agree.

| Surface | Palette |
|---|---|
| Alacritty background | `#1a1b26` |
| starship | Tokyo Night |
| Neovim | Catppuccin Mocha, transparent |
| This site | Tokyo Night / Tokyo Night Day |

## Key repeat

macOS defaults make `hjkl` feel sluggish. Current settings:

```bash
defaults write -g KeyRepeat -int 1          # ~15ms between repeats
defaults write -g InitialKeyRepeat -int 15  # ~225ms before repeat starts
```

Requires a **logout** to take effect — macOS reads these at login.

!!! warning "The slider will overwrite these"
    `KeyRepeat 1` is faster than System Settings can go (its minimum is 2).
    Opening Settings → Keyboard and touching either slider resets them.

Revert with:

```bash
defaults delete -g KeyRepeat
defaults delete -g InitialKeyRepeat
```

## tmux

Auto-attaches on SSH only — local shells are left alone:

```bash
if [[ -z "$TMUX" && -n "$SSH_CONNECTION" ]]; then
  tmux attach || tmux new
fi
```

See `tmux-commands` for the cheatsheet.
