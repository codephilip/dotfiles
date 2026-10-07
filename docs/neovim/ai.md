# AI workflow

Two tools, deliberately separate. The split is simple:

- ++space++ ++a++ — **Claude Code**. Edits your code. No API key.
- ++space++ ++n++ — **CodeCompanion**. Just talks. Needs an API key.

## Claude Code

`claudecode.nvim` runs the `claude` CLI in a split and speaks the same protocol
as the official VS Code extension. It knows what you are looking at, and its
edits arrive as reviewable diffs rather than silent buffer rewrites.

### The loop

<div class="dg">
  <div class="dg-cap">Context in, reviewable diff out</div>
  <div class="dg-flow">
    <div class="dg-node" style="--nc:var(--tn-magenta)"><b>1 · Select</b><span><code>vaf</code> grabs a function</span></div>
    <div class="dg-arrow">→</div>
    <div class="dg-node" style="--nc:var(--tn-magenta)"><b>2 · Send</b><span>Space a s</span></div>
    <div class="dg-arrow">→</div>
    <div class="dg-node" style="--nc:var(--tn-magenta)"><b>3 · Propose</b><span>Claude answers in the split</span></div>
    <div class="dg-arrow">→</div>
    <div class="dg-node" style="--nc:var(--tn-magenta)"><b>4 · Review</b><span>Diff opens in nvim. Nothing written yet.</span></div>
  </div>
  <div class="dg-fork">
    <div class="dg-out" style="--nc:var(--tn-green)"><b>Space a a — Accept</b><span>Change is written to disk</span></div>
    <div class="dg-out" style="--nc:var(--tn-red)"><b>Space a d — Deny</b><span>Nothing changes</span></div>
  </div>
</div>

1. **Select.** `vaf` grabs a whole function via treesitter. Or just leave the
   cursor somewhere — `track_selection` keeps Claude aware of your position.
2. **Send.** ++space++ ++a++ ++s++ in visual mode sends exactly that selection.
   ++space++ ++a++ ++b++ sends the whole buffer. In the file tree,
   ++space++ ++a++ ++s++ adds the file under the cursor without opening it.
3. **Propose.** Claude answers in the split.
4. **Review.** Any file edit opens as a vertical diff — your version against
   its version, in the window where you were already reading.
5. **Decide.** ++space++ ++a++ ++a++ accepts. ++space++ ++a++ ++d++ denies.
   Only now does anything touch disk.

!!! success "Why this beats a bare terminal"
    Running `claude` in a tmux pane works, but you lose two things: it cannot
    see your selection, and its edits land on disk without review. The plugin
    restores both.

### Bindings

| Keys | Does |
|---|---|
| ++space++ ++a++ ++c++ | Toggle the Claude split |
| ++space++ ++a++ ++f++ | Focus Claude without toggling |
| ++space++ ++a++ ++s++ | Send selection (visual) / add file (tree) |
| ++space++ ++a++ ++b++ | Add current buffer as context |
| ++space++ ++a++ ++r++ | Resume a past session |
| ++space++ ++a++ ++shift+c++ | Continue the most recent session |
| ++space++ ++a++ ++m++ | Select model |
| ++space++ ++a++ ++a++ | Accept diff |
| ++space++ ++a++ ++d++ | Deny diff |
| ++space++ ++a++ ++q++ | Close all pending diffs |
| ++space++ ++a++ ++question++ | Connection status |

### Configuration

In `lua/plugins/ai.lua`:

```lua
opts = {
  terminal_cmd = "claude",
  auto_start = true,
  track_selection = true,
  focus_after_send = false,  -- stay in your buffer after sending
  terminal = {
    provider = "native",     -- avoids needing snacks.nvim
    split_side = "right",
    split_width_percentage = 0.40,
  },
  diff_opts = { vertical_split = true, open_in_current_tab = true },
}
```

`provider = "native"` is deliberate: the plugin's default wants `folke/snacks.nvim`
purely for its terminal, which would mean adding a large dependency for one
window.

## CodeCompanion

A chat buffer inside Neovim talking directly to the Anthropic API.

| Keys | Does |
|---|---|
| ++space++ ++n++ ++n++ | Toggle chat |
| ++space++ ++n++ ++i++ | Inline assistant |
| ++space++ ++n++ ++a++ | Action palette (explain / fix / optimise) |
| ++space++ ++n++ ++d++ | Add selection to chat (visual) |
| ++space++ ++n++ ++c++ | Generate a `:command` |

Inside the chat buffer, ++enter++ sends and `#buffer` / `#file` pull context in.

!!! warning "Requires `ANTHROPIC_API_KEY`"
    This is billed per token, separately from your Claude subscription. Without
    the key set, ++space++ ++n++ ++n++ warns once and requests fail.

    ```bash
    echo 'export ANTHROPIC_API_KEY="sk-ant-..."' >> ~/.zshrc.local
    ```

    `~/.zshrc.local` is sourced at the end of `.zshrc` and is not committed.

### Which to use

| Situation | Tool |
|---|---|
| Change code across files | Claude Code |
| "What does this do?" about a selection | Claude Code |
| Anything you want reviewed before it lands | Claude Code |
| A quick question without a terminal split | CodeCompanion |
| You want the answer in a buffer you can yank from | CodeCompanion |

For most work Claude Code is the better tool and costs nothing extra.

## The buffer-reload problem

Claude and lazygit both write to **disk**, not to your open buffer. Without
protection you would keep editing a stale buffer and clobber their work on your
next `:w`.

`lua/config/autocmds.lua` handles this:

```lua
vim.api.nvim_create_autocmd(
  { "FocusGained", "BufEnter", "CursorHold", "TermClose", "TermLeave" },
  { callback = function()
      if vim.bo.buftype == "" and vim.fn.getcmdwintype() == "" then
        vim.cmd("checktime")
      end
    end })
```

Plus a notification on `FileChangedShellPost`, so a swap under your feet is
announced rather than silent.

!!! tip "In practice"
    Let Claude finish, glance at the *"File changed on disk — buffer reloaded"*
    message, and carry on. Do not fight the buffer.
