# tmux — Command Cheatsheet

Prefix: **`Ctrl-b`** — stock tmux. Nothing in `tmux/tmux.conf` is remapped,
so everything below also works on a vanilla tmux you ssh into.

Notation: `C-b c` means press `Ctrl-b`, release, then `c`.

Two deviations from stock, and that is the whole list:

- windows and panes are numbered from **1**
- `C-b R` reloads `~/.config/tmux/tmux.conf` (`R` is unbound in stock tmux)

`C-b ?` lists every binding on any machine. That is the real cheatsheet —
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
| `C-b d` | **detach** — the one to never forget |
| `C-b s` | interactive session tree |
| `C-b $` | rename session |
| `C-b (` / `C-b )` | previous / next session |
| `C-b L` | last session |
| `C-b D` | choose a client to detach |

---

## 🪟 Windows

| Key | Does |
|---|---|
| `C-b c` | new window |
| `C-b n` / `C-b p` | next / previous window |
| `C-b 1` … `C-b 9` | jump to window by number |
| `C-b l` | last window |
| `C-b w` | interactive window tree |
| `C-b ,` | rename window |
| `C-b &` | kill window (asks first) |
| `C-b f` | find window by name |
| `C-b .` | move window to another index |
| `C-b '` | prompt for a window index to select |

---

## 🔲 Panes

| Key | Does |
|---|---|
| `C-b %` | split into **left / right** |
| `C-b "` | split into **top / bottom** |
| `C-b ←↓↑→` | move between panes |
| `C-b o` | cycle to next pane |
| `C-b ;` | last pane |
| `C-b q` | show pane numbers; press one to jump |
| `C-b z` | **zoom** the pane full-screen (toggle) |
| `C-b x` | kill pane (asks first) |
| `C-b !` | break pane out into its own window |
| `C-b {` / `C-b }` | swap pane with previous / next |
| `C-b C-o` | rotate panes |
| `C-b Space` | cycle layouts |
| `C-b E` | spread panes out evenly |

Avoid the words "horizontal" and "vertical" for the splits — tmux uses them
backwards from how most people read them. `C-b %` runs `split-window -h` and
gives you two panes side by side; `C-b "` runs `split-window -v` and stacks
them. Remember the glyphs and the result, not the flag names.

### Resizing

| Key | Does |
|---|---|
| `C-b C-←↓↑→` | resize by 1 (repeatable — hold the arrow) |
| `C-b M-←↓↑→` | resize by 5 (`M-` is Alt/Option) |
| `C-b M-1` … `M-5` | even-horizontal, even-vertical, main-horizontal, main-vertical, tiled |

---

## 📋 Copy Mode

`C-b [` enters copy mode (scrollback). `q` leaves it. `C-b ]` pastes.

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
| `C-b ]` | paste most recent buffer |
| `C-b =` | choose a buffer to paste |
| `C-b #` | list buffers |
| `C-b -` | delete most recent buffer |

`set-clipboard` is `external` (the tmux default), so copying in copy mode
also forwards to the system clipboard via OSC 52 — which Alacritty supports,
and which keeps working over ssh. With `mouse on`, dragging a selection
copies into a tmux buffer the same way.

---

## 🔧 Prompt & Introspection

| Key | Does |
|---|---|
| `C-b :` | command prompt |
| `C-b ?` | list all key bindings |
| `C-b /` | describe one key |
| `C-b t` | clock |
| `C-b i` | window info |
| `C-b ~` | show recent messages (errors land here) |
| `C-b C` | customize-mode — browse and change every option |
| `C-b R` | reload this config *(the one added binding)* |

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
| Nested tmux (local + remote) | `C-b C-b` sends the prefix through to the inner one |
| Config suspected broken | `tmux -L test -f /dev/null` — clean server, no config |
| Config changed | `C-b R`, or `tmux kill-server` for structural changes |
| Pane stuck/garbled | `C-b r` refreshes the client |
| Lost a session | `tmux ls`, then `tmux a -t <name>` |
| Terminal colours wrong | check `echo $TERM` is `tmux-256color` inside tmux |

---

## 📌 The Shortlist

```
C-b d        detach
C-b c        new window
C-b n / p    next / prev window
C-b 1..9     jump to window
C-b %        split side by side
C-b "        split stacked
C-b ←↓↑→     move between panes
C-b z        zoom pane
C-b x        kill pane
C-b [        scrollback
C-b ?        list all keys
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

The only line should be `bind-key -T prefix R source-file …`.
