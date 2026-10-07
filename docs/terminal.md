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

macOS defaults make `hjkl` feel sluggish. Three steps, and the **order
matters** — see [troubleshooting](troubleshooting.md#holding-j-or-k-crawls-one-line-at-a-time)
for the full account.

**1. System Settings → Keyboard.** *Key Repeat Rate* to the fastest notch,
*Delay Until Repeat* to the shortest.

**2. Then, in a terminal:**

```bash
defaults write -g KeyRepeat -int 1                      # ~15ms between repeats
defaults write -g InitialKeyRepeat -int 15              # ~225ms before repeat starts
defaults write -g ApplePressAndHoldEnabled -bool false  # no GUI equivalent
```

**3. Log out and back in.** macOS reads the rate at login, so a terminal
relaunch does nothing.

!!! info "Why the slider first, and the commands second"
    They are not alternatives — each does something the other cannot, and the
    GUI has to go first.

    `KeyRepeat 1` is faster than the slider can express (its floor is `2`), so
    the commands have to come *after* it. Go the other way round and the slider
    silently resets your `1` back to `2`. `ApplePressAndHoldEnabled` has no GUI
    control at all, and while it is on, holding a key opens the accent-character
    picker **instead of repeating** — no rate helps.

    In practice the writes also do not take unless the pane has set the sliders
    first, which is why step 1 is not optional.

!!! warning "Touching the slider again undoes step 2"
    Any later visit to Settings → Keyboard that nudges either slider resets
    `KeyRepeat` to `2`. Re-run the commands if you do.

Revert with:

```bash
defaults delete -g KeyRepeat
defaults delete -g InitialKeyRepeat
defaults delete -g ApplePressAndHoldEnabled
```

## Key bindings

The terminals themselves add exactly one binding each — everything else is
left stock deliberately, so the muscle memory transfers to a vanilla install.

| Keys | Where | Does |
|---|---|---|
| ++shift+enter++ | Ghostty, Alacritty | Sends `ESC CR` instead of submitting |
| ++ctrl+a++ ++shift+r++ | tmux | Reload `tmux.conf`, with a confirmation message |
| ++cmd+shift+comma++ | Ghostty | Reload config — Ghostty has no CLI reload |

++shift+enter++ is the one that matters day to day: Claude Code and most REPLs
need a literal newline to add a line without submitting the prompt, and the
default behaviour submits. Both terminals are configured to match.

## tmux

Auto-attaches on SSH only — local shells are left alone:

```bash
if [[ -z "$TMUX" && -n "$SSH_CONNECTION" ]]; then
  tmux attach || tmux new
fi
```

The prefix is ++ctrl+a++ rather than ++ctrl+b++. After the prefix, every
binding is stock apart from ++ctrl+a++ ++shift+r++ above, so on a tmux you have
never configured you press ++ctrl+b++ and the rest is the same. The full key
reference is on the [tmux](tmux.md) page.
