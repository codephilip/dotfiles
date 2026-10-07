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

## Quick reference

=== "Ours"

    | Keys / setting | Does |
    |---|---|
    | ++ctrl+a++ | The prefix. **Replaces** stock ++ctrl+b++, which is unbound |
    | ++ctrl+a++ ++ctrl+a++ | Sends a literal ++ctrl+a++, so "start of line" still works in the shell |
    | ++ctrl+a++ ++shift+r++ | Reload `tmux.conf`. `R` is unbound in stock tmux, so nothing is displaced |
    | Numbering from **1** | Windows and panes. The number row starts at 1 |
    | Renumbering | Closing window 2 of 3 leaves 1 and 2, no gap |
    | Window names | Named after the pane's directory (`nvim-config`, not `zsh`) until you rename one |
    | Mouse on | Click to focus, drag a border to resize, scroll to enter copy mode |
    | `escape-time` 10ms | The default 500ms makes ++escape++ in Neovim feel broken |
    | Scrollback 50,000 lines | — |
    | Auto-attach over SSH | `.zshrc` attaches to the last session, or starts one, when `$SSH_CONNECTION` is set. Local shells are left alone |

    That is the whole list. See [why](#why-the-bindings-stay-stock).

=== "Stock"

    Shown with this config's ++ctrl+a++. On any other machine it's ++ctrl+b++.

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
    | ++ctrl+a++ `s` | Session tree; pick one to switch |
    | ++ctrl+a++ `[` | Scrollback / copy mode. `q` leaves |
    | ++ctrl+a++ `:` | Command prompt |
    | ++ctrl+a++ ++question++ | List every binding |
    | `tmux new -A -s work` | Attach to `work`, creating it if absent |
    | `tmux a` | Attach to the most recent session |

## Why the bindings stay stock

The rule: **keep tmux on its default key bindings**, and change only things
that cost no muscle memory, such as appearance, numbering and latency.

Much of the time tmux isn't running on this machine. It's on a bastion host,
a build agent, a production box during an incident, or a colleague's laptop.
None of those have this config. A custom split key makes you faster at your
desk and slower on every one of those machines, and the slowdown hits when you
can least afford it. Before adding a binding, check that the key is unbound in
stock tmux, and that you wouldn't miss it on a server.

**The prefix is the one exception.** It's pressed before every command, so
comfort wins: ++ctrl+a++ sits under the little finger, ++ctrl+b++ is a
stretch. Only the prefix changes, so every key after it is identical
everywhere. Two side effects:

- **++ctrl+a++ is also "start of line"** in zsh, bash and Emacs. Inside tmux,
  press ++ctrl+a++ ++ctrl+a++ to send it through.
- **Nested tmux is simpler.** A server you SSH into runs stock tmux on
  ++ctrl+b++, so ++ctrl+a++ drives your local tmux and ++ctrl+b++ drives the
  remote one.

??? note "Proving nothing else differs from stock"
    Compare against a bare server:

    ```bash
    tmux -L defaults -f /dev/null new-session -d
    diff <(tmux -L defaults list-keys | sort) <(tmux list-keys | sort)
    tmux -L defaults kill-server
    ```

    The differences should be the prefix lines (`C-a` added, `C-b` gone) and
    the `bind-key -T prefix R …` line.

## Stock keys in detail

Everything in this section is stock tmux. ++ctrl+a++ ++question++ lists every
binding; ++ctrl+a++ `/` then a key describes just that key.

=== "Sessions"

    | Keys | Does |
    |---|---|
    | ++ctrl+a++ `d` | Detach |
    | ++ctrl+a++ `s` | Session tree; pick one to switch |
    | ++ctrl+a++ `$` | Rename session |
    | ++ctrl+a++ `(` / `)` | Previous / next session |
    | ++ctrl+a++ ++shift+l++ | Last session |
    | ++ctrl+a++ ++shift+d++ | Choose a client to detach |

=== "Windows"

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

=== "Panes"

    | Keys | Does |
    |---|---|
    | ++ctrl+a++ `%` | Split into **left / right** |
    | ++ctrl+a++ `"` | Split into **top / bottom** |
    | ++ctrl+a++ ++left++ ++down++ ++up++ ++right++ | Move between panes |
    | ++ctrl+a++ `o` / `;` | Next pane / last pane |
    | ++ctrl+a++ `q` | Show pane numbers; press one to jump |
    | ++ctrl+a++ `z` | Zoom (toggle). The window shows a `Z` flag while zoomed |
    | ++ctrl+a++ `x` | Kill pane (asks first) |
    | ++ctrl+a++ `!` | Break the pane out into its own window |
    | ++ctrl+a++ `{` / `}` | Swap with the previous / next pane |
    | ++ctrl+a++ ++space++ | Cycle through layouts |
    | ++ctrl+a++ ++ctrl+left++ (any arrow) | Resize by 1 cell; repeatable without the prefix |
    | ++ctrl+a++ ++alt+left++ (any arrow) | Resize by 5 cells |
    | ++ctrl+a++ ++alt+1++ … ++alt+5++ | Preset layouts: even-horizontal, even-vertical, main-horizontal, main-vertical, tiled |

    `%` runs `split-window -h` and gives panes **side by side**; `"` runs
    `split-window -v` and **stacks** them. Remember the result, not the flag.
    For the ++alt++ keys use the **left** ++option++: Ghostty sets
    `macos-option-as-alt = left`, so the right one types accented characters.

=== "Copy mode"

    ++ctrl+a++ `[` or the mouse wheel enters it; `q` leaves. `mode-keys` is
    left unset, so tmux picks vi keys because `$EDITOR` is `nvim`. Check with
    `tmux show -g mode-keys`.

    | Keys (vi) | Does |
    |---|---|
    | ++space++ | **Start a selection** |
    | `v` | Toggle rectangle (block) selection |
    | ++enter++ | Copy the selection and exit |
    | ++escape++ | Clear the selection |
    | `w` / `b` | Word forward / back |
    | ++ctrl+u++ / ++ctrl+d++ | Half page up / down |
    | `g` / `G` | Top / bottom of the history |
    | `H` / `L` | Top / bottom visible line |
    | `/` / `?` | Search down / up; `n` / `N` for next / previous |
    | ++ctrl+a++ `]` | Paste the most recent buffer |
    | ++ctrl+a++ `=` | Choose a buffer to paste |

    `v` does **not** start a selection in stock tmux. Most published configs
    rebind it, which is why copy mode feels broken on servers you don't own.
    Learn ++space++. Copied text also reaches the system clipboard through
    OSC 52 (stock `set-clipboard external`), which works over SSH.

=== "Prompt"

    | Keys | Does |
    |---|---|
    | ++ctrl+a++ `:` | Command prompt. `status-keys` is vi too, so ++escape++ there switches to normal mode; press it twice to cancel |
    | ++ctrl+a++ ++question++ | List every binding |
    | ++ctrl+a++ `/` | Describe one key |
    | ++ctrl+a++ `~` | Recent messages. Config errors land here |
    | ++ctrl+a++ ++shift+c++ | Customize mode: browse and change every option |
    | ++ctrl+a++ `r` | Redraw the client |

    Useful at the `:` prompt:

    ```text
    :new-window -c "#{pane_current_path}"   new window in this pane's directory
    :setw synchronize-panes                  type into every pane at once; again to stop
    :list-keys -T copy-mode-vi               every copy-mode binding
    :show -g                                 every global option
    ```

=== "Shell"

    | Command | Does |
    |---|---|
    | `tmux new -s work` | New session named `work` |
    | `tmux new -A -s work` | Attach to `work`, creating it if absent |
    | `tmux ls` | List sessions |
    | `tmux a` / `tmux a -t work` | Attach to the most recent session / to `work` |
    | `tmux kill-session -t work` | Kill one session |
    | `tmux kill-server` | Kill everything |

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
