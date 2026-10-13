# Neovim — Command Cheatsheet

Leader key: <Space>

Neovim is a modal editor.
Learn a small set of commands and reuse them everywhere (local + SSH).

Verified against the live config (nvim 0.12). Forgot one? Press <Space> and
wait (which-key), or <Space>sk to fuzzy-search every keymap.

---

## 📁 Files & Quitting

Open file:
:e file.txt

Find and open a file:
<Space><Space>   (or <Space>ff)

Write file:
:w
<Space>w

Quit window:
:q
<Space>q

Quit everything:
:qa
<Space>Q

(Unsaved changes prompt you instead of failing — `confirm` is on.)

Make current file executable:
<Space>cx

Open URL / path under cursor:
gx

---

## 📂 File Tree (nvim-tree)

Toggle file tree:
<Space>e

Reveal the current file in the tree:
<Space>E

Inside the tree:
a       → create file (end the name with / for a directory)
r       → rename
d       → delete
x / c / p → cut / copy / paste
y / Y / gy → copy name / relative path / absolute path
Enter or l → open file / expand directory
h       → close directory
Ctrl-t  → cd into directory
-       → go up to the parent directory
i       → file info
H       → toggle dotfiles
I       → toggle git-ignored files
R       → refresh
W / E   → collapse all / expand all
Ctrl-v / Ctrl-x → open in vertical / horizontal split
g?      → full list of tree keys
q       → close the tree

---

## 🔍 Fuzzy Finder (fzf-lua)

Find files:
<Space>ff   (or <Space><Space>)

Find git files:
<Space>fg

Recent files:
<Space>fr

Open buffers:
<Space>fb

Files in the nvim config:
<Space>fc

Live grep (ripgrep) across the project:
<Space>/   (or <Space>sg)

Grep the word under cursor / the selection:
<Space>sw

Grep just this buffer:
<Space>sb

Help pages:
<Space>sh

Search keymaps:
<Space>sk

Marks / jumplist / quickfix / command history:
<Space>sm / <Space>sj / <Space>sq / <Space>s:

Resume the last picker:
<Space>sr

Workspace diagnostics:
<Space>sd

Inside a picker:
Ctrl-q  → send all matches to quickfix
Ctrl-/  → toggle picker help
Ctrl-d / Ctrl-u → scroll the preview

---

## 📄 Buffers

Buffers show as tabs along the top (barbar).

Next / previous buffer:
L / H   (or Shift-l / Shift-h)

Jump back to the other (last) buffer:
<Space>bb

Jump to buffer by position:
<Space>1 … <Space>5   (<Space>9 = last)

Pick a buffer by letter:
<Space>bs

Close buffer (keeps window layout):
<Space>bd

Close all other buffers:
<Space>bo

Close all unpinned buffers:
<Space>bP

Pin / unpin buffer:
<Space>bp

Reorder buffer tab left / right:
<Space>b<   /   <Space>b>

---

## 🪟 Windows (Splits)

Split below / split right:
<Space>-   /   <Space>|

Move between splits (also from terminal mode):
Ctrl-h / Ctrl-j / Ctrl-k / Ctrl-l

Resize:
Ctrl-Arrow keys

Close the other windows:
Ctrl-w o

---

## 📑 Tabs (Workspaces)

No custom keys — use the built-ins. Buffers do most of the work.

New tab:
:tabnew

Next / previous tab:
gt / gT

Close tab:
:tabclose

Only this tab:
:tabonly

---

## 🧠 Navigation

Clear search highlight:
<Esc>

Search next / previous (stays centred):
n / N

Jump back / forward through your jumplist:
Ctrl-o / Ctrl-i

Move the line (or selection) up / down:
Alt-k / Alt-j

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

Select a syntax node with labels (flash + treesitter):
S

Next / previous function:
]f / [f   (end of function: ]F / [F)

Next / previous class:
]c / [c   (end of class: ]C / [C)

Next / previous symbol in the outline:
]] / [[

Jump up to the enclosing function / class (the sticky header):
[x

Symbol outline of the file, navigate it like a table of contents:
<Space>o

Floating symbol navigator:
<Space>cO

Document symbols (fuzzy picker):
gO

Fuzzy-search the lines of just this buffer:
<Space>sb

Scroll the cursor line to top / middle / bottom of the screen:
zt / zz / zb
(H and L are buffer prev/next here, so use M for the screen middle only)

Start / end of file:
gg / G

Grow / shrink selection by syntax node (works from normal mode):
Ctrl-Space  /  Backspace (in visual mode)

---

## 🎯 Text Objects (treesitter)

Use after an operator (d, c, y, v …):

Function:   af / if
Class:      ac / ic
Parameter:  aa / ia
Block:      ab / ib
Comment:    a/
Git hunk:   ih

Examples:
vif → select inside the function
daa → delete a parameter
yac → yank the whole class

Swap parameter with next / previous:
<Space>cp / <Space>cP

---

## 🧩 LSP (IDE Features)

Go to definition:
gd

Go to declaration:
gD

Go to implementation:
gI

Go to type definition:
gy

References:
gr

Document symbols:
gO

Workspace symbols:
<Space>cs

Hover documentation:
K   (press K twice to jump into the float)

Signature help (insert mode):
Ctrl-s

Rename symbol:
<Space>cr

Code actions:
<Space>ca

Format file:
<Space>cf

Incoming / outgoing calls:
<Space>cc / <Space>cC

Toggle inlay hints (when the server supports them):
<Space>uh

Manage servers and tools:
<Space>cm   (Mason)

Lint the buffer now:
<Space>cl

Completion menu (blink.cmp):
Ctrl-Space → open
Ctrl-n / Ctrl-p → next / previous
Ctrl-y → accept
Ctrl-e → dismiss
Tab / Shift-Tab → jump through snippet placeholders

---

## 🚨 Diagnostics

Show this line's diagnostics:
<Space>cd

Next / previous diagnostic:
]d / [d

First / last diagnostic in the buffer:
[D / ]D

Workspace diagnostics (picker):
<Space>sd

Toggle diagnostics on / off:
<Space>ud

Quickfix list (where grep and LSP results land):
<Space>xq
]q / [q → next / previous item

---

## 🌿 Git (gitsigns + lazygit)

Git changes appear in the gutter automatically.

Open lazygit in a float:
<Space>gg

Next / previous hunk:
]h / [h

Stage / reset hunk (also works on a visual selection):
<Space>gh / <Space>gH

Undo last stage:
<Space>gu

Stage / reset the whole buffer:
<Space>gS / <Space>gR

Preview hunk inline:
<Space>gp

Blame this line (full commit) / blame the whole buffer:
<Space>gb / <Space>gB

Toggle inline blame:
<Space>ub

Diff against index / against last commit:
<Space>gd / <Space>gD

Pickers — commits (repo), commits (this file), status:
<Space>gc / <Space>gC / <Space>gs

Select the hunk you are standing in:
vih

Branch switching lives in lazygit (<Space>gg).

---

## 🤖 AI

Claude Code (terminal in a side split):
<Space>ac   → toggle
<Space>af   → focus
<Space>ar   → resume a session
<Space>aC   → continue the last session
<Space>am   → select model
<Space>ab   → add current buffer as context
<Space>as   → send selection (visual mode) / add file in the tree
<Space>aa / <Space>ad → accept / deny a proposed diff
<Space>aq   → close all diffs
<Space>a?   → connection status

CodeCompanion (chat inside nvim):
<Space>nn   → toggle chat
<Space>na   → action palette
<Space>ni   → inline assistant
<Space>nd   → add selection to chat (visual)
<Space>nc   → generate a :command

---

## 📝 Markdown

Toggle rendered view:
<Space>um

Toggle a task checkbox:
<Space>mx

Toggle table mode / realign table:
<Space>mt / <Space>mr

CSV selection → table:
<Space>mT

Start / stop `mkdocs serve` and open the browser:
<Space>mp

Markdown, git commit and text buffers wrap and spell-check automatically.

---

## ✏️ Editing (Core)

Undo / redo:
u / Ctrl-r

Visual mode / line / block:
v / V / Ctrl-v

Delete line / copy line / paste:
dd / yy / p

Comment line / selection / motion:
gcc / gc / gc{motion}

Indent selection (stays selected):
< / >

Paste over a selection without losing what you yanked:
p (in visual mode)

Substitute with the cursor parked in the pattern:
<Space>sR   (buffer, or selection in visual mode)

The system clipboard is the default register — yy and p talk to it.
Trailing whitespace is trimmed on save (not in markdown / git commits).
Missing parent directories are created on save.
Files edited outside nvim (Claude, lazygit) reload automatically.

---

## 🎛️ Toggles

Wrap:               <Space>uw
Relative numbers:   <Space>ur
Diagnostics:        <Space>ud
Inline git blame:   <Space>ub
Inlay hints:        <Space>uh
Treesitter context: <Space>ut
Colour swatches:    <Space>uc
Markdown rendering: <Space>um
Inspect highlight under cursor: <Space>ui

---

## 🧯 Terminal

Floating terminal (toggle, works inside the terminal too):
Ctrl-\

Leave terminal mode:
Ctrl-/
(or Ctrl-\ Ctrl-n)

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

Edit the config (picker):
<Space>fc

Re-source the file you're editing:
<Space>cR
(plugin specs need a restart or :Lazy reload)

Plugin manager:
<Space>L   (Lazy)

Health check:
:checkhealth

Pick a colour scheme from the shell, then restart nvim:
theme <name>
