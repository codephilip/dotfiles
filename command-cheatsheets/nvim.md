# Neovim — Command Cheatsheet

Leader key: <Space>

Neovim is a modal editor.
Learn a small set of commands and reuse them everywhere (local + SSH).

---

## 📁 Files

Open file:
:e file.txt

Create / open new file:
<Space>nf

Save file:
:w
<Space>sf

Quit:
:q

Quit all:
:qa

---

## 📂 File Tree (nvim-tree)

Toggle file tree:
<Space>e

Inside the tree:
a       → create file  
A       → create directory  
r       → rename  
d       → delete  
Enter  → open file  

Icons are intentionally disabled for remote safety.

---

## 🔍 Fuzzy Finder (fzf)

Find files:
<Space>ff

Find git files:
<Space>fg

Search text (ripgrep):
<Space>fw

List open buffers:
<Space>fb

Help tags:
<Space>fh

---

## 📄 Buffers (Safe)

Next buffer:
<Space>bn

Previous buffer:
<Space>bp

Delete buffer safely (keeps layout):
<Space>bd

---

## 📑 Tabs (Workspaces)

New tab:
<Space>tn

Close tab:
<Space>tc

Only this tab:
<Space>to

Next tab:
<Space>tl

Previous tab:
<Space>th

---

## 🧠 Navigation

Move between splits (tmux-compatible):
Ctrl-h / Ctrl-j / Ctrl-k / Ctrl-l

Clear search highlight:
<Esc>

---

## 🏃 Looking Through A File Fast

Holding j is the slow way. It is one line per keypress no matter how
fast the key repeat is set, so a 600-line file is always 600 presses.
Use these instead — roughly in order of how much they pay off.

Collapse every function to one line, see the whole file's shape:
zM

Expand it all again:
zR

Toggle just the fold under the cursor:
za

Open / close the fold under the cursor:
zo / zc

Half a page at a time, cursor stays centred:
Ctrl-d / Ctrl-u

Jump to any visible line by number — line numbers are relative, so
read the gutter and type the number you see:
12j / 8k

Jump to any visible character — press s, type 2 characters, then the
label that appears:
s

Next / previous function:
]f / [f

Next / previous class:
]c / [c

Symbol outline of the file, navigate it like a table of contents:
<Space>o

Fuzzy-search the lines of just this buffer:
<Space>sb

Back / forward through where you have jumped from:
Ctrl-o / Ctrl-i

Top / middle / bottom of the visible screen:
H / M / L

Start / end of file:
gg / G

---

## 🧩 LSP (IDE Features)

Go to definition:
gd

Find references:
gr

Hover documentation:
K

Rename symbol:
<Space>rn

Code actions:
<Space>ca

Format file:
<Space>f

---

## 🚨 Diagnostics

Show diagnostics popup:
<Space>dd

Next diagnostic:
]d

Previous diagnostic:
[d

---

## 🌿 Git (gitsigns)

Git changes appear in the gutter automatically.

Preview hunk:
:GitSigns preview_hunk

Stage hunk:
:GitSigns stage_hunk

---

## 🧠 Editing (Core)

Undo:
u

Redo:
Ctrl-r

Visual mode:
v

Visual line mode:
V

Delete line:
dd

Copy line:
yy

Paste:
p

---

## 🧯 Terminal Mode

Exit terminal mode:
Esc

---

## 📌 Mental Model

Buffers = files  
Tabs = workspaces  
Windows = splits  

Use buffers constantly.  
Use tabs sparingly.

---

## 🔗 Config

Config location:
~/.config/nvim/

Reload config:
:source ~/.config/nvim/init.lua
