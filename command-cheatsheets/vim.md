# Vim — Command Guide (basic → advanced)

A standalone guide to Vim, independent of any personal config. Everything
here works in stock Vim or Neovim, locally or over SSH. Items marked (nvim)
need Neovim; items marked (opt) depend on settings you may need to turn on.

How to read this:
- Commands are written as you type them. `<Esc>` `<CR>` `<C-x>` = Ctrl-x.
- `{motion}` means "any movement" (w, $, }, f), `N` means a number.
- Learn it in order. Sections 1–4 are a full working editor. 5–12 are what
  make you fast. 13–16 are the power tools.

The one idea behind everything:

    [count] operator motion      d2w   = delete 2 words
                                 c}    = change to end of paragraph
                                 y$    = yank to end of line

Operators are verbs, motions/text objects are nouns. Learn ~8 of each and you
know hundreds of commands.

---

## 1. 🚪 Survival (do these first)

Modes:
<Esc>   → Normal mode (home base — go here whenever lost)
i       → Insert mode (typing text)
v       → Visual (select characters)
V       → Visual line
<C-v>   → Visual block (columns)
:       → Command line

Save / quit:
:w            → save
:q            → quit (refuses if unsaved)
:wq  or  ZZ   → save and quit
:q!  or  ZQ   → quit, throw away changes
:qa           → quit everything
:wa           → save all
:e!           → reload file from disk, discard changes

Undo / redo:
u        → undo
<C-r>    → redo
U        → undo all changes on the line
:earlier 10m   → file as it was 10 minutes ago
:later 10m

Stuck?
<Esc><Esc>     → back to Normal, clears pending command
:help {topic}  → built-in docs, e.g. :help text-objects
:help          → then <C-]> follows a link, <C-t> goes back

---

## 2. ⌨️ Entering Insert mode

i   → before cursor              a   → after cursor
I   → start of line (first char) A   → end of line
o   → new line below             O   → new line above
gi  → insert where you last left Insert mode
gI  → column 0 of the line

In Insert mode:
<C-w>   → delete previous word
<C-u>   → delete to start of line
<C-h>   → backspace
<C-o>   → run ONE Normal command, then come back
<C-r>0  → paste register 0 (yank); <C-r>" , <C-r>+ also work
<C-n> / <C-p> → word completion (next / previous match)
<C-t> / <C-d> → indent / dedent the line

---

## 3. 🏃 Moving around

Characters / lines:
h j k l       → left down up right
5j            → 5 lines down (`:set relativenumber` shows the count to type)
gj / gk       → down/up by SCREEN line (wrapped lines)

Words:
w / W   → next word start         (W = space-separated WORD)
b / B   → previous word start
e / E   → end of word
ge      → end of previous word

Within a line:
0   → column 0               ^   → first non-blank char
$   → end of line            g_  → last non-blank char
f{c} → jump TO next {c}      F{c} → backwards
t{c} → jump just BEFORE {c}  T{c} → backwards
;    → repeat last f/t       ,    → repeat, reversed

Across the file:
gg      → top                G   → bottom
42G or :42  → go to line 42
50%     → 50% through the file
{ / }   → previous / next blank line (paragraph)
( / )   → previous / next sentence
%       → jump to matching ( ) [ ] { }
H / M / L → top / middle / bottom of screen

Scrolling:
<C-d> / <C-u>  → half page down / up
<C-f> / <C-b>  → full page
zz / zt / zb   → put cursor line in centre / top / bottom of screen
<C-e> / <C-y>  → scroll one line, cursor stays

Jump list (your breadcrumbs):
<C-o>   → back to where you were
<C-i>   → forward again
``      → jump back to the position before the last jump
`.      → the exact spot of your last edit
gi      → resume inserting at the last insert position

---

## 4. ✂️ The core editing verbs

Delete / change / yank (copy):
x       → delete char under cursor        X → char before
dd      → delete line
D       → delete to end of line
dw      → delete word
d$ / d0 → delete to end / start of line
cc      → change line (delete + insert)
C       → change to end of line
cw      → change word
s       → substitute one char    S → substitute line
r{c}    → replace one char with {c}
R       → Replace mode (overtype), <Esc> to leave
yy      → yank line
Y       → yank line (Neovim: yank to end of line, like y$)
yw      → yank word

Paste:
p   → paste after cursor / below line
P   → paste before cursor / above line
]p  → paste and fix indent to match the line

Repeat:
.     → repeat the last change (the most powerful key in Vim)
3.    → repeat the last change 3 times

Join / case / indent:
J        → join next line onto this one
gJ       → join with no space
~        → toggle case of char
g~w / gUw / guw → toggle / UPPER / lower a word
gUU / guu       → UPPER / lower the whole line
>>  / <<  → indent / dedent line
==        → auto-indent line
=ap       → auto-indent a paragraph
gg=G      → auto-indent the whole file

Increment numbers:
<C-a> / <C-x>  → +1 / -1 the number under (or after) the cursor
5<C-a>         → +5
g<C-a>         → in Visual selection: 1,2,3… down a column

---

## 5. 🎯 Text objects (the real power)

Operator + `i` (inner) or `a` (around) + object.

Objects:
w     → word               s   → sentence      p   → paragraph
" ' ` → quoted string
( or b → parentheses       [   → brackets      { or B → braces
<  or t → <> / HTML tag
f     → function  (needs a plugin such as treesitter-textobjects)

Examples (cursor anywhere inside the thing):
diw    → delete word               daw   → delete word + trailing space
ci"    → change what's inside "quotes"
da"    → delete the quotes AND their contents
ci(    → change inside parentheses
da{    → delete a whole {block}
dit    → delete inside an HTML tag
cit    → change the tag's content
yap    → yank paragraph
vip    → select paragraph
vi{    → select inside braces (press i{ again to widen)
ci'    → rewrite a string argument in one move

Rule of thumb: `c` + object = "rewrite this thing". Say the sentence aloud:
"change inside quotes".

---

## 6. 🔍 Search

Search in file:
/pattern   → forward         ?pattern  → backward
n / N      → next / previous match
*  / #     → search word under cursor forward / backward
g* / g#    → same, partial matches too
`:noh`     → clear highlight until the next search

Case: `:set ignorecase smartcase` (opt) makes `/foo` match Foo and FOO, while
`/Foo` matches only Foo.

Useful atoms:
\<word\>    → whole word
\v          → "very magic" (use normal regex: `/\v(foo|bar)\d+`)
\c / \C     → force ignore / match case
.           → any char    .*  → anything    ^ $ → line start / end

Combine with operators:
d/foo<CR>    → delete from cursor up to the next "foo"
c/;<CR>      → change up to the next semicolon
gn           → select the next match; `cgn` then `.` = change each match one by one

---

## 7. 🔁 Search & replace (:substitute)

:s/old/new/          → first match on this line
:s/old/new/g         → every match on this line
:%s/old/new/g        → whole file
:%s/old/new/gc       → ask for each (y / n / a = all / q / l = last)
:'<,'>s/old/new/g    → only the Visual selection (typing : in Visual adds this)
:5,20s/old/new/g     → lines 5–20
:%s/\<foo\>/bar/g    → whole word only
:%s/old/new/gi       → ignore case
:%s/\s\+$//e         → trim trailing whitespace (e = no error if none)
:%s//new/g           → reuse the LAST search pattern
:%s/\(\w\+\) \(\w\+\)/\2 \1/   → capture groups, swap two words
:%s/pattern/\=line('.')/       → expression on the right-hand side
:g& or &&            → repeat last :s

---

## 8. 👁️ Visual mode

v / V / <C-v>    → start char / line / block selection
o                → jump to the other end of the selection
gv               → reselect the last selection
Then any operator: d  c  y  >  <  =  ~  U  u  J  :  r{c}

Visual block (columns) tricks:
<C-v>3j  I#<Esc>   → insert `#` at the start of 4 lines (comment them out)
<C-v>3j  $A;<Esc>  → append `;` to the end of 4 lines
<C-v>jj  c...      → change a column of text
<C-v>jj  d         → delete a column

Repeat an indent: `>` drops the selection, so use `gv>` to indent again
(or `3>` to indent 3 levels at once).
Paste over a selection: `p` replaces it, but the replaced text lands in the
unnamed register. Use `"0p` to paste your original yank again.

---

## 9. 📋 Registers (many clipboards)

"{reg}   → prefix any yank/delete/paste to pick a register
"ayy     → yank line into register a
"ap      → paste from register a
"Ayy     → APPEND line to register a

Special registers:
""   → default (last delete or yank)
"0   → last YANK (not clobbered by deletes)
"1–9 → last 9 big deletes
"_   → black hole (delete without saving anywhere)
"+ "* → system clipboard (`"+y` / `"+p`; `:set clipboard=unnamedplus` (opt)
        makes plain y and p use it)
".   → last inserted text
":   → last command line
"/   → last search
"%   → current file name

Tricks:
:reg              → look at all registers
"_dd              → delete a line without losing what you yanked
<C-r>{reg}        → insert register while in Insert / command-line mode
"0p               → paste your last yank even after you deleted something

---

## 10. 📌 Marks & jumping

m{a-z}   → set a mark in this file
'{a-z}   → jump to the LINE of that mark
`{a-z}   → jump to the exact position
m{A-Z}   → global mark (works across files)
'{A-Z}   → jump to that file + position

Automatic marks:
``    → previous jump position           `.  → last change
`^    → where Insert mode last ended      `[ `]  → start / end of last yank/change
`<  `> → start / end of last Visual selection
:marks     → list them

---

## 11. 🎬 Macros (record & replay)

q{a-z}   → start recording into a register (e.g. qa)
q        → stop recording
@a       → play it
@@       → replay the last macro
5@a      → play 5 times
:%norm @a    → run macro `a` on every line
:'<,'>norm @a → run on the Visual selection

Recipe for a repeatable macro:
1. Go to the start of the line first (0).
2. Do the edit using motions that work on every line (w, f, t, $, ci").
3. End with a move to the next line (j).
4. qa … q, then 100@a  (it stops on the first failed motion).

Edit a macro: `:let @a='` then `<C-r><C-r>a` then `'` <CR>
Paste it with "ap, tweak, yank back with "ayy

---

## 12. 🪟 Windows, buffers, tabs

Buffers (open files):
:ls               → list buffers
:b {name}         → switch by (partial) name
:bn / :bp         → next / previous
:bd               → close buffer
<C-^>             → toggle between the current and previous file
:e#               → same as <C-^>
:bufdo {cmd}      → run a command in every buffer

Windows (splits):
:sp file / :vsp file → split horizontal / vertical (file optional)
<C-w>s / <C-w>v      → split current window
<C-w>h j k l         → move between splits
<C-w>w               → cycle through windows
<C-w>c               → close this window
<C-w>o               → keep ONLY this window
<C-w>=               → equalise sizes
<C-w>_ / <C-w>|      → maximise height / width
<C-w>x               → swap with neighbour
<C-w>H J K L         → move window to far left/bottom/top/right
<C-w>T               → move window into its own tab
:windo {cmd}         → run a command in every window

Tabs:
:tabnew     → new tab        :tabc    → close tab
:tabn / :tabp  → next / previous tab
gt / gT     → next / previous tab
3gt         → go to tab 3
:tabo       → close all other tabs

---

## 13. 🧰 Ex commands (the `:` line)

Ranges (prefix any ex command):
:5          → go to line 5
:5,10d      → delete lines 5–10
:.,$d       → from the current line to end of file
:%          → whole file
:'a,'bd     → between marks a and b
:/foo/,/bar/d → from the next "foo" to the next "bar"
:.,+4y      → current line + 4 below

Handy ex commands:
:d  :y  :m  :t  :>  :<
:m 0          → move current line to the top
:m $          → move current line to the bottom
:t.           → duplicate the current line (`:t.` = copy to here)
:5t.          → copy line 5 below the cursor
:5m.          → move line 5 below the cursor
:norm {keys}  → run Normal keys: `:%norm Aa;` adds ; to every line
:sort         → sort lines  (:sort u = unique, :sort n = numeric, :sort! = reverse)
:retab        → convert tabs ↔ spaces per your settings
:set list     → show whitespace    :set nolist
:set wrap!    → toggle wrap (the `!` toggles any boolean option)
:set ft=lua   → set filetype
:syntax on / :noh

The global command — your power tool:
:g/pattern/d           → delete every line matching pattern
:v/pattern/d  or :g!/pat/d → delete every line NOT matching
:g/pattern/s/a/b/g     → substitute only on lines that match
:g/^/m0                → reverse the whole file
:g/pattern/m0          → move all matching lines to the top (reversed)
:g/^$/d                → delete all empty lines
:g/TODO/y A            → collect all TODO lines into register a
:g/pattern/norm @q     → run a macro on every matching line
:g/foo/t.              → duplicate every line with foo
:g/./,/^$/j            → squeeze blank lines (compress paragraphs)

Shell integration:
:!cmd               → run a shell command, show output
:r !date            → insert command output below the cursor
:r file             → insert another file
:.!cmd              → replace this line with the output
:%!sort             → pipe the buffer through `sort`
:%!jq .             → format JSON in place
:'<,'>!sort -u      → sort + dedupe a selection
:w !sudo tee %      → save a file you opened without root
:cd %:h             → cd to the current file's directory

---

## 14. 🔎 Lists: quickfix, location, grep

:grep foo           → search project (uses ripgrep if grepprg is set)
:vimgrep /foo/ **/*.lua → built-in search into the quickfix list
:copen / :cclose    → open / close the quickfix window
:cnext / :cprev     → next / previous entry
:cfirst / :clast    → jump to ends
:cdo s/old/new/g | update → replace across every quickfix entry
:cfdo %s/old/new/ge | update → same, once per FILE
:lopen / :lnext     → location list (same idea, per window)

Project-wide replace recipe:
1. :grep old                (fills the quickfix list)
2. :cdo s/old/new/gc | update
3. :wa

---

## 15. 🧱 Folds, formatting, indentation

Folds:
za / zA   → toggle fold (zA = recursive)
zo / zc   → open / close
zO / zC   → open / close recursively
zR / zM   → open ALL / close ALL
zj / zk   → move to next / previous fold
zf{motion} → create a manual fold (zfap)
zd / zE   → delete one / all manual folds

Formatting:
gq{motion}   → hard-wrap lines to textwidth (gqap, gqq)
gw{motion}   → same, cursor stays put
gu / gU      → lower / upper case operators
g?{motion}   → ROT13 (g?? for the line)
:%!column -t → align columns
=             → re-indent using the filetype's rules

Info:
ga   → show the character's code
g<C-g> → word / line count
<C-g> → file name and position
:set number? → query any option (add `?`)

---

## 16. 🧠 Advanced patterns

Repeat anything:
.         → repeat last change
&         → repeat last :s on this line
g&        → repeat last :s on the whole file with the same flags
@:        → repeat the last ex command
@@        → repeat the last macro
;  ,      → repeat / reverse last f/t/F/T

Edit-in-one-shot idioms (build a change that `.` can repeat):
ciw<text><Esc>  then  w.   → replace one word, move, repeat
*  cgn <text> <Esc>  .  .  → rename a word everywhere by hitting `.` repeatedly
A;<Esc>  j.  j.           → append ; to several lines
f,;.                       → hop and repeat an edit

Swap / transpose:
xp      → swap two characters
ddp     → swap two lines (ddP = move line up)
dwwP     → swap two words (cursor at start of the first)
:m+1 / :m-2 → move a line down / up

Comment (nvim 0.10+ built-in):
gcc       → comment line
gc{motion} → comment motion (gcap = paragraph)
gc in Visual → comment selection

Count + motion + operator, all together:
d3w       → delete 3 words
3dd       → delete 3 lines
2d}       → delete 2 paragraphs
c2f,      → change up to and including the 2nd comma
y2ap      → yank 2 paragraphs
d/foo<CR> → delete up to "foo"

Insert-mode tricks:
<C-o>zz   → recentre without leaving Insert mode
<C-r>=5*5<CR> → insert the result of an expression
<C-v>u00e9 → insert a unicode char by code (é)
<C-k>e:    → insert a digraph (ë)

Command-line window (edit past commands like text):
q:  → history of ex commands, editable; <CR> runs the line
q/  → same for searches
<C-f> inside `:` → open it from the command line

Persistent undo & sessions:
:undolist      → all undo branches
g- / g+        → move back / forward through undo TIME (not just the tree)
:mksession! s.vim → save windows/buffers; `nvim -S s.vim` restores

---

## 17. 🧭 Cheat-card: the 20 that matter most

ciw   change a word          ci"   change inside quotes
dap   delete paragraph       vip   select paragraph
.     repeat last change     u     undo
*     search word under cursor
cgn   change next match (then . . .)
f{c}  jump to a char         ;     repeat it
%     matching bracket       gg G  top / bottom
<C-o> <C-i>   jump back / forward
:%s/a/b/gc    replace with confirm
:g/pat/d      delete matching lines
qa … q @a     record / play macro
<C-v>  I      edit many lines at once
"0p   paste last yank after a delete
zM zR za      fold all / unfold all / toggle
:cdo s/a/b/ | update   project-wide replace
gv    reselect the last selection
:norm A;      run a normal command on a range

---

## 18. 🗺️ Practice path

Day 1   Section 1–3: survive, move with w b f t { }, stop using the arrows.
Day 2   Section 4–5: dd, cw, ci", dap, `.` — notice you almost never retype.
Day 3   Section 6–7: / * n, :%s with `gc`.
Week 2  Sections 8–11: visual block, registers, marks, a macro a day.
Week 3  Sections 12–15: splits, :g, :norm, :cdo, folds.
Ongoing Run `vimtutor` once a month (type `vimtutor` in the terminal) and
        `:Tutor` inside Neovim. Then `:help index` to see every key.
