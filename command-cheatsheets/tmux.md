# tmux – Command Reference

Prefix key: **Ctrl-a**

---

## 🧠 Core Concepts

Hierarchy:
server → session → window → pane

- **Session**: named workspace
- **Window**: tab inside a session
- **Pane**: split inside a window

---

## 📦 Session Management

Create named session:
tmux new -s work

List sessions:
tmux ls

Attach last session:
tmux a

Attach specific session:
tmux a -t work

Detach:
Ctrl-a d

Rename session:
Ctrl-a $

Kill current session:
Ctrl-a : kill-session

Kill all sessions:
tmux kill-server

---

## 🪟 Window Management

New window:
Ctrl-a c

Next / previous:
Ctrl-a n  
Ctrl-a p

Jump by number:
Ctrl-a 1 .. 9

Rename window:
Ctrl-a ,

Close window:
Ctrl-a &

---

## 🔲 Pane Management

Split horizontal:
Ctrl-a |

Split vertical:
Ctrl-a -

Move between panes:
h  j  k  l

Resize panes:
H  J  K  L

Swap panes:
Ctrl-a {  
Ctrl-a }

Zoom pane:
Ctrl-a z

Close pane:
Ctrl-a x

---

## 🧭 Layouts & Navigation

Cycle layouts:
Ctrl-a Space

Show pane numbers:
Ctrl-a q

---

## 📋 Copy / Scroll Mode (SSH-safe)

Enter copy mode:
Ctrl-a [

Start selection (vi):
v

Copy selection:
y

Exit:
q  or  Enter

---

## 🔍 Command Prompt

Open prompt:
Ctrl-a :

Common commands:
:new -s test  
:kill-pane  
:kill-window  
:source-file ~/.tmux.conf  

---

## 🧯 Recovery & Troubleshooting

Detach safely:
Ctrl-a d

Reattach:
tmux a

Nested tmux:
Ctrl-a Ctrl-a

Bypass config (debug):
tmux -L test -f /dev/null

---

## 🌍 Remote / SSH Workflow

Create session immediately:
tmux new -s server

Detach before disconnect:
Ctrl-a d

Reattach after reconnect:
tmux a

---

## 📌 Most Used (Mental Shortlist)

Ctrl-a c      → new window  
Ctrl-a d      → detach  
Ctrl-a n / p  → switch windows  
Ctrl-a | / -  → split panes  
Ctrl-a z      → zoom pane  
Ctrl-a [      → copy mode  
Ctrl-a r      → reload config  

---

## 🔗 Config Note (Read Once)

tmux reads config from `~/.tmux.conf`.  
This setup symlinks it to `~/.config/tmux/tmux.conf`.

Refresh symlink (safe):
ln -sf ~/.config/tmux/tmux.conf ~/.tmux.conf

Reload for most changes:
Ctrl-a r

Restart required for structural changes:
tmux kill-server
