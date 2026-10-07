# Zsh — Command Cheatsheet

Zsh is your interactive shell.
It controls navigation, history, job control, and command execution.

---

## 📁 Navigation

Current directory:
pwd

Change directory:
cd /path/to/dir

Go home:
cd
cd ~

Go back:
cd -

Jump to git repo root:
cdr

Create directory + enter:
mkcd new-folder

---

## 📂 Directory Listing

Basic:
ls

Long format:
ll

All files (including hidden):
la

Tree-like view:
ls -R

---

## 🔍 History & Recall (Very Important)

Show history:
history

Repeat last command:
!!

Repeat last argument:
!$

Repeat command by number:
!123

Search history interactively:
Ctrl-r

Clear history file:
history -c

---

## ✂️ Editing & Control

Cancel current command:
Ctrl-c

Clear screen:
Ctrl-l

End input / logout:
Ctrl-d

Paste last argument:
Alt-.

---

## 🔄 Jobs & Processes

Run in background:
command &

List jobs:
jobs

Bring job to foreground:
fg

Send job to background:
bg

Suspend running command:
Ctrl-z

---

## 🔎 Pipes & Redirection

Pipe output:
command1 | command2

Redirect output to file:
command > file.txt

Append output:
command >> file.txt

Redirect stderr:
command 2> error.log

Suppress output:
command > /dev/null 2>&1

---

## 🌱 Environment Variables

Set variable (session only):
export VAR=value

View variable:
echo $VAR

List environment:
env

Edit shell config:
vi ~/.zshrc

Reload config:
source ~/.zshrc

---

## 🧠 Globbing (Power Feature)

All .js files:
ls *.js

Recursive match:
ls **/*.js

Exclude files:
ls ^(*.log)

Case-insensitive:
ls *.TXT

---

## ✏️ Editors

Open file:
vi file.txt

Open directory:
vi .

Editor used by tools:
$EDITOR
$VISUAL

---

## 🧵 Aliases & Functions

List aliases:
alias

Create alias:
alias gs='git status'

Remove alias:
unalias gs

Functions live in ~/.zshrc

---

## 🔧 Completion

Autocomplete:
Tab

Cycle options:
Tab Tab

Accept suggestion:
→ (right arrow)

Cancel completion:
Ctrl-c

---

## 🌍 SSH / Remote Usage

Connect to server:
ssh user@host

Detach tmux safely:
Ctrl-a d

Reconnect:
tmux a

---

## 🧯 Troubleshooting

Check shell:
echo $SHELL

Check zsh version:
zsh --version

Run command without alias:
\ls

Debug startup:
zsh -xv

---

## 📌 Daily Muscle Memory

Ctrl-r     → history search  
Ctrl-l     → clear screen  
Ctrl-c     → cancel  
Ctrl-d     → exit shell  
!!         → repeat last command  
!$         → last argument  
cd -       → previous directory  

---

## 🔗 Config Note

Zsh config lives in:
~/.config/zsh/.zshrc

Reload after changes:
source ~/.zshrc

---

## ✨ New shell tooling

### fzf — fuzzy everything
Fuzzy search command history:
Ctrl-R

Insert a file path at the cursor:
Ctrl-T

Fuzzy cd into a subdirectory:
Alt-C

Fuzzy tab completion with preview (any command):
<TAB>

Fuzzy-find a file and open it in nvim:
fv

Fuzzy-switch git branch:
fbr

### zoxide — jump to directories you actually use
Jump to the best match:
z nvim
z config

Pick interactively from matches:
zi

### eza — ls with icons, colour and git status
Long listing with git status:
ll

All files, no detail:
la

Tree, 2 levels deep:
lt

Tree, 3 levels deep:
ltt

Long listing, respecting .gitignore:
llg

Git column meanings:
-N  new / untracked
-M  modified
-I  ignored
--  unchanged

### autosuggestions
Accept the whole greyed-out suggestion:
Right-arrow
Ctrl-Space

Accept one word of it:
Alt-Right

### History search
Type a prefix, then walk matching history:
Up / Down

Keep a command OUT of history:
(prefix it with a space)

### delta — better git diffs
Jump between files inside a diff:
n
N

### Config shortcuts
Edit this shell config:
zshrc

Reload the shell after editing:
zreload

Edit the nvim config:
nvimrc
