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
