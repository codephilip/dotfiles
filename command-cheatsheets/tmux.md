# tmux — Command Cheatsheet

Prefix: **`Ctrl-a`** — the stock prefix is `Ctrl-b`. Only the prefix is
changed: on a vanilla tmux you ssh into, press `Ctrl-b` and everything after
it below is the same. `C-a C-a` sends a literal `Ctrl-a` (shell line-start).

Notation: `C-a c` means press `Ctrl-a`, release, then `c`.

Three deviations from stock, and that is the whole list:

- the prefix is **`C-a`** (`C-b` is released)
- windows and panes are numbered from **1**
- `C-a R` reloads `~/.config/tmux/tmux.conf` (`R` is unbound in stock tmux)

`C-a ?` lists every binding (`C-b ?` on a stock tmux). That is the real cheatsheet —
this file is the subset worth memorising.

---

## 🧠 Model

```
server → session → window → pane
```

- **session** — a named workspace that outlives your terminal
- **window** — a tab inside a session
- **pane** — a split inside a window

Detaching leaves everything running. That is the whole point of tmux.

---

## 🚪 From the Shell

| Command | Does |
|---|---|
| `tmux` | new unnamed session |
| `tmux new -s work` | new session named `work` |
| `tmux ls` | list sessions |
| `tmux a` | attach to the most recent session |
| `tmux a -t work` | attach to `work` |
| `tmux new -A -s work` | attach to `work`, create it if absent |
| `tmux kill-session -t work` | kill one session |
| `tmux kill-server` | kill everything |

---

## 📦 Sessions

| Key | Does |
|---|---|
| `C-a d` | **detach** — the one to never forget |
| `C-a s` | interactive session tree |
| `C-a $` | rename session |
| `C-a (` / `C-a )` | previous / next session |
| `C-a L` | last session |
| `C-a D` | choose a client to detach |

---

## 🪟 Windows

| Key | Does |
|---|---|
| `C-a c` | new window |
| `C-a n` / `C-a p` | next / previous window |
| `C-a 1` … `C-a 9` | jump to window by number |
| `C-a l` | last window |
| `C-a w` | interactive window tree |
| `C-a ,` | rename window |
| `C-a &` | kill window (asks first) |
| `C-a f` | find window by name |
| `C-a .` | move window to another index |
| `C-a '` | prompt for a window index to select |

---

## 🔲 Panes

| Key | Does |
|---|---|
| `C-a %` | split into **left / right** |
| `C-a "` | split into **top / bottom** |
| `C-a ←↓↑→` | move between panes |
| `C-a o` | cycle to next pane |
| `C-a ;` | last pane |
| `C-a q` | show pane numbers; press one to jump |
| `C-a z` | **zoom** the pane full-screen (toggle) |
| `C-a x` | kill pane (asks first) |
| `C-a !` | break pane out into its own window |
| `C-a {` / `C-a }` | swap pane with previous / next |
| `C-a C-o` | rotate panes |
| `C-a Space` | cycle layouts |
| `C-a E` | spread panes out evenly |

Avoid the words "horizontal" and "vertical" for the splits — tmux uses them
backwards from how most people read them. `C-a %` runs `split-window -h` and
gives you two panes side by side; `C-a "` runs `split-window -v` and stacks
them. Remember the glyphs and the result, not the flag names.

### Resizing

| Key | Does |
|---|---|
| `C-a C-←↓↑→` | resize by 1 (repeatable — hold the arrow) |
| `C-a M-←↓↑→` | resize by 5 (`M-` is Alt/Option) |
| `C-a M-1` … `M-5` | even-horizontal, even-vertical, main-horizontal, main-vertical, tiled |

---

## 📋 Copy Mode

`C-a [` enters copy mode (scrollback). `q` leaves it. `C-a ]` pastes.

`mode-keys` is deliberately left unset, so tmux chooses: **vi keys when
`$EDITOR`/`$VISUAL` looks vi-ish, emacs keys otherwise.** Check with
`tmux show -g mode-keys`. This config ships `$EDITOR=nvim`, so you get vi.

### vi mode

| Key | Does |
|---|---|
| `Space` | **start selection** (not `v` — see below) |
| `v` | toggle rectangle/block selection |
| `Enter` | copy selection and exit |
| `Escape` | clear selection |
| `h j k l` | move |
| `w` / `b` | word forward / back |
| `0` / `^` / `$` | line start / first non-blank / end |
| `C-u` / `C-d` | half page up / down |
| `g` / `G` | top / bottom of history |
| `H` / `L` | top / bottom visible line |
| `/` / `?` | search down / up |
| `n` / `N` | next / previous match |
| `q` | exit copy mode |

> **`v` is not begin-selection.** In stock tmux, vi copy mode starts a
> selection with `Space`; `v` toggles rectangle mode. Nearly every published
> config rebinds `v` to begin-selection, which is exactly why copy mode feels
> broken on a server you don't own. Learn `Space`.

### emacs mode

| Key | Does |
|---|---|
| `C-Space` | start selection |
| `M-w` or `C-w` | copy selection and exit |
| `C-g` | clear selection |
| `C-a` / `C-e` | line start / end |
| `Space` / `PageUp` | page down / up |
| `C-s` / `C-r` | incremental search down / up |
| `n` | search again |
| `M-<` / `M->` | top / bottom of history |
| `g` | go to line number |
| `q` | exit copy mode |

### Buffers

| Key | Does |
|---|---|
| `C-a ]` | paste most recent buffer |
| `C-a =` | choose a buffer to paste |
| `C-a #` | list buffers |
| `C-a -` | delete most recent buffer |

`set-clipboard` is `external` (the tmux default), so copying in copy mode
also forwards to the system clipboard via OSC 52 — which Alacritty supports,
and which keeps working over ssh. With `mouse on`, dragging a selection
copies into a tmux buffer the same way.

---

## 🔧 Prompt & Introspection

| Key | Does |
|---|---|
| `C-a :` | command prompt |
| `C-a ?` | list all key bindings |
| `C-a /` | describe one key |
| `C-a t` | clock |
| `C-a i` | window info |
| `C-a ~` | show recent messages (errors land here) |
| `C-a C` | customize-mode — browse and change every option |
| `C-a R` | reload this config *(the one added binding)* |

Useful at the `:` prompt:

```
:source-file ~/.config/tmux/tmux.conf
:new-window -c "#{pane_current_path}"
:kill-session -t other
:setw synchronize-panes          # type into every pane at once; run again to stop
:show -g                         # every global option
:list-keys -T copy-mode-vi
```

---

## 🧯 Recovery

| Situation | Fix |
|---|---|
| Nested tmux (local + remote) | the remote is stock, so `C-b` reaches it directly; if both use this config, `C-a C-a` |
| Config suspected broken | `tmux -L test -f /dev/null` — clean server, no config |
| Config changed | `C-a R`, or `tmux kill-server` for structural changes |
| Pane stuck/garbled | `C-a r` refreshes the client |
| Lost a session | `tmux ls`, then `tmux a -t <name>` |
| Terminal colours wrong | check `echo $TERM` is `tmux-256color` inside tmux |

---

## 📌 The Shortlist

```
C-a d        detach
C-a c        new window
C-a n / p    next / prev window
C-a 1..9     jump to window
C-a %        split side by side
C-a "        split stacked
C-a ←↓↑→     move between panes
C-a z        zoom pane
C-a x        kill pane
C-a [        scrollback
C-a ?        list all keys
```

---

## 🔗 Config Note

tmux 3.1+ reads `~/.config/tmux/tmux.conf` natively — no symlink needed.
A leftover `~/.tmux.conf` symlink pointing at the same file makes tmux
source the config **twice**; check with:

```
tmux display-message -p '#{config_files}'
```

To confirm nothing here deviates from stock, diff against a bare server:

```
tmux -L defaults -f /dev/null new-session -d
diff <(tmux -L defaults list-keys | sort) <(tmux list-keys | sort)
```

Expect only the prefix lines (`C-a` added, `C-b` gone) and
`bind-key -T prefix R source-file …`.
