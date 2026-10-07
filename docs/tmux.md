# tmux

Configured in `~/.config/tmux/tmux.conf`, which tmux 3.1+ reads natively.

The prefix is ++ctrl+b++, the stock one, and **nothing is remapped**. Anything
you learn here works on a tmux you have never configured: a server you ssh
into, a colleague's machine, a fresh install. The config only changes
appearance, scrollback and latency.

Bindings are written as a sequence: ++ctrl+b++ `c` means press ++ctrl+b++,
let go, then press `c`. While the prefix is held, the status line shows `^B`
on the right, so you can see that it registered.

!!! tip "The authoritative list"
    ++ctrl+b++ ++question++ lists every binding on whatever tmux you are on.
    ++ctrl+b++ ++slash++ then a key describes just that key.

## What differs from stock

That is the whole list:

| Change | Why |
|---|---|
| ++ctrl+b++ ++shift+r++ reloads `tmux.conf` | `R` is unbound in stock tmux, so nothing is displaced |
| Windows and panes are numbered from **1** | The number row starts at 1; ++ctrl+b++ ++0++ is a reach |
| Windows renumber after one closes | No gaps: closing window 2 of 3 leaves 1 and 2 |
| Windows are named after the pane's directory | The status line says `nvim-config` instead of `zsh`, until you rename it |
| Mouse is on | Click a pane or window to focus it, drag a border to resize, scroll to enter copy mode |
| `escape-time` is 10ms | The default 500ms makes ++escape++ in Neovim feel broken |
| Scrollback is 50,000 lines | — |

To check that nothing else differs, compare against a bare server:

```bash
tmux -L defaults -f /dev/null new-session -d
diff <(tmux -L defaults list-keys | sort) <(tmux list-keys | sort)
tmux -L defaults kill-server
```

The only difference should be the `bind-key -T prefix R …` line.

## The shortlist

| Keys | Does |
|---|---|
| ++ctrl+b++ `d` | **Detach.** Everything keeps running |
| ++ctrl+b++ `c` | New window |
| ++ctrl+b++ `n` / `p` | Next / previous window |
| ++ctrl+b++ `1` … `9` | Jump to window by number |
| ++ctrl+b++ `%` | Split side by side |
| ++ctrl+b++ `"` | Split stacked |
| ++ctrl+b++ ++left++ ++down++ ++up++ ++right++ | Move between panes |
| ++ctrl+b++ `z` | Zoom the pane full-screen (toggle) |
| ++ctrl+b++ `x` | Kill pane |
| ++ctrl+b++ `[` | Scrollback / copy mode |
| ++ctrl+b++ ++question++ | List every binding |

## From the shell

| Command | Does |
|---|---|
| `tmux new -s work` | New session named `work` |
| `tmux new -A -s work` | Attach to `work`, creating it if absent |
| `tmux ls` | List sessions |
| `tmux a` | Attach to the most recent session |
| `tmux a -t work` | Attach to `work` |
| `tmux kill-session -t work` | Kill one session |
| `tmux kill-server` | Kill everything |

Over SSH, `.zshrc` attaches automatically (`tmux attach || tmux new`).
Local shells are left alone.

## Sessions

| Keys | Does |
|---|---|
| ++ctrl+b++ `d` | Detach |
| ++ctrl+b++ `s` | Session tree; pick one to switch |
| ++ctrl+b++ `$` | Rename session |
| ++ctrl+b++ `(` / `)` | Previous / next session |
| ++ctrl+b++ ++shift+l++ | Last session |
| ++ctrl+b++ ++shift+d++ | Choose a client to detach |

## Windows

| Keys | Does |
|---|---|
| ++ctrl+b++ `c` | New window |
| ++ctrl+b++ `n` / `p` | Next / previous window |
| ++ctrl+b++ `1` … `9` | Jump to window by number |
| ++ctrl+b++ `l` | Last window |
| ++ctrl+b++ `w` | Window tree, across all sessions |
| ++ctrl+b++ `,` | Rename window. Turns off directory naming for that window |
| ++ctrl+b++ `&` | Kill window (asks first) |
| ++ctrl+b++ `f` | Find a window by name or content |
| ++ctrl+b++ `.` | Move the window to another index |
| ++ctrl+b++ `'` | Prompt for a window index |

## Panes

| Keys | Does |
|---|---|
| ++ctrl+b++ `%` | Split into **left / right** |
| ++ctrl+b++ `"` | Split into **top / bottom** |
| ++ctrl+b++ ++left++ ++down++ ++up++ ++right++ | Move between panes |
| ++ctrl+b++ `o` | Cycle to the next pane |
| ++ctrl+b++ `;` | Last pane |
| ++ctrl+b++ `q` | Show pane numbers; press one to jump |
| ++ctrl+b++ `z` | Zoom (toggle). The window shows a `Z` flag while zoomed |
| ++ctrl+b++ `x` | Kill pane (asks first) |
| ++ctrl+b++ `!` | Break the pane out into its own window |
| ++ctrl+b++ `{` / `}` | Swap with the previous / next pane |
| ++ctrl+b++ ++ctrl+o++ | Rotate panes |
| ++ctrl+b++ ++space++ | Cycle through layouts |
| ++ctrl+b++ ++shift+e++ | Spread panes out evenly |

!!! info "Avoid \"horizontal\" and \"vertical\""
    tmux uses them the opposite way to how most people read them.
    ++ctrl+b++ `%` runs `split-window -h` and gives two panes **side by side**;
    ++ctrl+b++ `"` runs `split-window -v` and **stacks** them. Remember the
    result, not the flag.

### Resizing

| Keys | Does |
|---|---|
| ++ctrl+b++ ++ctrl+left++ (any arrow) | Resize by 1 cell; repeatable without the prefix |
| ++ctrl+b++ ++alt+left++ (any arrow) | Resize by 5 cells |
| ++ctrl+b++ ++alt+1++ … ++alt+5++ | Preset layouts: even-horizontal, even-vertical, main-horizontal, main-vertical, tiled |

With the mouse on, dragging a border works too.

!!! warning "Use the **left** ++option++ key"
    Ghostty has `macos-option-as-alt = left`: left ++option++ is Alt, right
    ++option++ still types accented characters. With the right one,
    ++ctrl+b++ ++alt+left++ does nothing.

## Copy mode

++ctrl+b++ `[` enters copy mode, which is how you scroll back. Scrolling the
mouse wheel does the same. `q` leaves it. ++ctrl+b++ `]` pastes.

`mode-keys` is left unset on purpose, so tmux picks: **vi keys when
`$EDITOR` looks like vi**, emacs keys otherwise. `.zshrc` sets `EDITOR=nvim`,
so you get vi. Check with `tmux show -g mode-keys`.

| Keys (vi) | Does |
|---|---|
| ++space++ | **Start a selection** |
| `v` | Toggle rectangle (block) selection |
| ++enter++ | Copy the selection and exit |
| ++escape++ | Clear the selection |
| `h` `j` `k` `l` | Move |
| `w` / `b` | Word forward / back |
| `0` / `^` / `$` | Line start / first non-blank / line end |
| ++ctrl+u++ / ++ctrl+d++ | Half page up / down |
| `g` / `G` | Top / bottom of the history |
| `H` / `L` | Top / bottom visible line |
| `/` / `?` | Search down / up |
| `n` / `N` | Next / previous match |
| `q` | Exit |

!!! warning "`v` does not start a selection"
    In stock tmux, ++space++ starts a selection and `v` toggles rectangle
    mode. Most published configs rebind `v`, which is why copy mode feels
    broken on servers you don't own. Learn ++space++.

Copied text also goes to the system clipboard through OSC 52. That's tmux's
default `set-clipboard external`, and it keeps working over SSH.

### Paste buffers

| Keys | Does |
|---|---|
| ++ctrl+b++ `]` | Paste the most recent buffer |
| ++ctrl+b++ `=` | Choose a buffer to paste |
| ++ctrl+b++ `#` | List buffers |
| ++ctrl+b++ `-` | Delete the most recent buffer |

## Prompt and introspection

| Keys | Does |
|---|---|
| ++ctrl+b++ `:` | Command prompt. `status-keys` is vi as well, so ++escape++ there switches to normal mode instead of cancelling; press it twice |
| ++ctrl+b++ ++question++ | List every binding |
| ++ctrl+b++ `/` | Describe one key |
| ++ctrl+b++ `~` | Recent messages. Config errors land here |
| ++ctrl+b++ ++shift+c++ | Customize mode: browse and change every option |
| ++ctrl+b++ `i` | Window info |
| ++ctrl+b++ `t` | Big clock |
| ++ctrl+b++ ++shift+r++ | Reload `tmux.conf` *(the one added binding)* |

Useful at the `:` prompt:

```text
:new-window -c "#{pane_current_path}"   new window in this pane's directory
:setw synchronize-panes                  type into every pane at once; again to stop
:list-keys -T copy-mode-vi               every copy-mode binding
:show -g                                 every global option
```

## Recovery

| Situation | Fix |
|---|---|
| tmux inside tmux (local + remote) | ++ctrl+b++ ++ctrl+b++ sends the prefix through to the inner one |
| Config change not showing | ++ctrl+b++ ++shift+r++, or `tmux kill-server` for structural changes |
| Config suspected broken | `tmux -L test -f /dev/null`: a clean server with no config |
| Pane garbled | ++ctrl+b++ `r` redraws the client |
| Colours look banded inside tmux | `echo $TERM` should say `tmux-256color`, and the outer terminal needs a `Tc` entry in `terminal-overrides` |
| Config sourced twice | A leftover `~/.tmux.conf` symlink. Check `tmux display -p '#{config_files}'` |

The same reference is in the terminal as `tmux-commands`.
