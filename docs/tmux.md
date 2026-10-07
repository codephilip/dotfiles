# tmux

Configured in `~/.config/tmux/tmux.conf`, which tmux 3.1+ reads natively.

!!! important "The prefix is ++ctrl+a++, not the stock ++ctrl+b++"
    This config changes the prefix and nothing else about the bindings. On a
    tmux without this config, such as a server, a colleague's machine or a
    fresh install, press ++ctrl+b++ instead. Every key after the prefix on
    this page is the same there.

Bindings are written as a sequence: ++ctrl+a++ `c` means press ++ctrl+a++,
let go, then press `c`. While the prefix is held, the status line shows `^A`
on the right, so you can see that it registered.

## Why the bindings stay stock

This is a deliberate rule: **keep tmux on its default key bindings**, and
change only things that cost no muscle memory, such as appearance, numbering
and latency. The prefix is the one exception, explained below.

The reason is DevOps work. Much of the time tmux isn't running on this
machine. It's on a bastion host, a build agent, a production box you've
SSH'd into to debug an incident, or a colleague's laptop during a pairing
session. None of those have this config. A remapped prefix or a custom split
key makes you faster at your desk and slower on every one of those machines,
and the slowdown hits mid-incident, when you can least afford it. Stock
bindings work the same everywhere.

Before adding a binding, check two things:

- **Is the key unbound in stock tmux?** If not, the binding overrides a
  default you'd then have to unlearn.
- **Would you miss it on a server?** If yes, you'll be reaching for a key
  that isn't there. Learn the stock way instead.

`prefix R` (reload) passes both, which is why it's the only one added.

### The exception: ++ctrl+a++

The prefix is pressed before every single command, so it's the one key where
comfort wins. ++ctrl+a++ sits under the left little finger, while ++ctrl+b++
is a stretch. It costs less muscle memory than it looks: only the prefix
changes, so the keys after it are identical on every machine.

It has two side effects:

- **++ctrl+a++ is also "start of line"** in zsh, bash and Emacs. Inside tmux,
  press ++ctrl+a++ ++ctrl+a++ to send it through.
- **Nested tmux is simpler.** A server you SSH into runs stock tmux on
  ++ctrl+b++, so ++ctrl+a++ drives your local tmux and ++ctrl+b++ drives the
  remote one, with no doubling up.

!!! tip "The authoritative list"
    ++ctrl+a++ ++question++ lists every binding. ++ctrl+a++ ++slash++ then a key
    describes just that key. On a stock tmux, both are ++ctrl+b++ ++question++
    and ++ctrl+b++ ++slash++.

## What differs from stock

That is the whole list:

| Change | Why |
|---|---|
| Prefix is ++ctrl+a++; ++ctrl+b++ is released | Easier to reach. See [the exception](#the-exception-ctrla) above |
| ++ctrl+a++ ++ctrl+a++ sends a literal ++ctrl+a++ | So "start of line" still works in the shell |
| ++ctrl+a++ ++shift+r++ reloads `tmux.conf` | `R` is unbound in stock tmux, so nothing is displaced |
| Windows and panes are numbered from **1** | The number row starts at 1; ++ctrl+a++ ++0++ is a reach |
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

The differences should be the prefix lines (`C-a` added, `C-b` gone) and the
`bind-key -T prefix R …` line.

## The shortlist

| Keys | Does |
|---|---|
| ++ctrl+a++ `d` | **Detach.** Everything keeps running |
| ++ctrl+a++ `c` | New window |
| ++ctrl+a++ `n` / `p` | Next / previous window |
| ++ctrl+a++ `1` … `9` | Jump to window by number |
| ++ctrl+a++ `%` | Split side by side |
| ++ctrl+a++ `"` | Split stacked |
| ++ctrl+a++ ++left++ ++down++ ++up++ ++right++ | Move between panes |
| ++ctrl+a++ `z` | Zoom the pane full-screen (toggle) |
| ++ctrl+a++ `x` | Kill pane |
| ++ctrl+a++ `[` | Scrollback / copy mode |
| ++ctrl+a++ ++question++ | List every binding |

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
| ++ctrl+a++ `d` | Detach |
| ++ctrl+a++ `s` | Session tree; pick one to switch |
| ++ctrl+a++ `$` | Rename session |
| ++ctrl+a++ `(` / `)` | Previous / next session |
| ++ctrl+a++ ++shift+l++ | Last session |
| ++ctrl+a++ ++shift+d++ | Choose a client to detach |

## Windows

| Keys | Does |
|---|---|
| ++ctrl+a++ `c` | New window |
| ++ctrl+a++ `n` / `p` | Next / previous window |
| ++ctrl+a++ `1` … `9` | Jump to window by number |
| ++ctrl+a++ `l` | Last window |
| ++ctrl+a++ `w` | Window tree, across all sessions |
| ++ctrl+a++ `,` | Rename window. Turns off directory naming for that window |
| ++ctrl+a++ `&` | Kill window (asks first) |
| ++ctrl+a++ `f` | Find a window by name or content |
| ++ctrl+a++ `.` | Move the window to another index |
| ++ctrl+a++ `'` | Prompt for a window index |

## Panes

| Keys | Does |
|---|---|
| ++ctrl+a++ `%` | Split into **left / right** |
| ++ctrl+a++ `"` | Split into **top / bottom** |
| ++ctrl+a++ ++left++ ++down++ ++up++ ++right++ | Move between panes |
| ++ctrl+a++ `o` | Cycle to the next pane |
| ++ctrl+a++ `;` | Last pane |
| ++ctrl+a++ `q` | Show pane numbers; press one to jump |
| ++ctrl+a++ `z` | Zoom (toggle). The window shows a `Z` flag while zoomed |
| ++ctrl+a++ `x` | Kill pane (asks first) |
| ++ctrl+a++ `!` | Break the pane out into its own window |
| ++ctrl+a++ `{` / `}` | Swap with the previous / next pane |
| ++ctrl+a++ ++ctrl+o++ | Rotate panes |
| ++ctrl+a++ ++space++ | Cycle through layouts |
| ++ctrl+a++ ++shift+e++ | Spread panes out evenly |

!!! info "Avoid \"horizontal\" and \"vertical\""
    tmux uses them the opposite way to how most people read them.
    ++ctrl+a++ `%` runs `split-window -h` and gives two panes **side by side**;
    ++ctrl+a++ `"` runs `split-window -v` and **stacks** them. Remember the
    result, not the flag.

### Resizing

| Keys | Does |
|---|---|
| ++ctrl+a++ ++ctrl+left++ (any arrow) | Resize by 1 cell; repeatable without the prefix |
| ++ctrl+a++ ++alt+left++ (any arrow) | Resize by 5 cells |
| ++ctrl+a++ ++alt+1++ … ++alt+5++ | Preset layouts: even-horizontal, even-vertical, main-horizontal, main-vertical, tiled |

With the mouse on, dragging a border works too.

!!! warning "Use the **left** ++option++ key"
    Ghostty has `macos-option-as-alt = left`: left ++option++ is Alt, right
    ++option++ still types accented characters. With the right one,
    ++ctrl+a++ ++alt+left++ does nothing.

## Copy mode

++ctrl+a++ `[` enters copy mode, which is how you scroll back. Scrolling the
mouse wheel does the same. `q` leaves it. ++ctrl+a++ `]` pastes.

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
| ++ctrl+a++ `]` | Paste the most recent buffer |
| ++ctrl+a++ `=` | Choose a buffer to paste |
| ++ctrl+a++ `#` | List buffers |
| ++ctrl+a++ `-` | Delete the most recent buffer |

## Prompt and introspection

| Keys | Does |
|---|---|
| ++ctrl+a++ `:` | Command prompt. `status-keys` is vi as well, so ++escape++ there switches to normal mode instead of cancelling; press it twice |
| ++ctrl+a++ ++question++ | List every binding |
| ++ctrl+a++ `/` | Describe one key |
| ++ctrl+a++ `~` | Recent messages. Config errors land here |
| ++ctrl+a++ ++shift+c++ | Customize mode: browse and change every option |
| ++ctrl+a++ `i` | Window info |
| ++ctrl+a++ `t` | Big clock |
| ++ctrl+a++ ++shift+r++ | Reload `tmux.conf` *(the one added binding)* |

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
| tmux inside tmux (local + remote) | The remote is stock, so ++ctrl+b++ reaches it directly. If both have this config, ++ctrl+a++ ++ctrl+a++ sends the prefix to the inner one |
| Config change not showing | ++ctrl+a++ ++shift+r++, or `tmux kill-server` for structural changes |
| Config suspected broken | `tmux -L test -f /dev/null`: a clean server with no config |
| Pane garbled | ++ctrl+a++ `r` redraws the client |
| Colours look banded inside tmux | `echo $TERM` should say `tmux-256color`, and the outer terminal needs a `Tc` entry in `terminal-overrides` |
| Config sourced twice | A leftover `~/.tmux.conf` symlink. Check `tmux display -p '#{config_files}'` |

The same reference is in the terminal as `tmux-commands`.
