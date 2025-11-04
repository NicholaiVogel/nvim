**All tmux commands start with:** `Ctrl + w` (custom config)
### Starting & Managing Sessions

| Command                     | Action                      |
| --------------------------- | --------------------------- |
| `tmux`                      | Start new session           |
| `tmux new -s name`          | Start new session with name |
| `tmux ls`                   | List all sessions           |
| `tmux attach`               | Attach to last session      |
| `tmux attach -t name`       | Attach to named session     |
| `tmux kill-session -t name` | Kill named session          |
| `tmux kill-server`          | Kill all sessions           |
### Inside tmux

| Command          | Action                                   |
| ---------------- | ---------------------------------------- |
| `Ctrl + w` → `d` | **Detach** from session (keeps running!) |
| `Ctrl + w` → `s` | List and switch sessions                 |
| `Ctrl + w` → `$` | Rename current session                   |

---
## Windows 

| Command            | Action                                  |
| ------------------ | --------------------------------------- |
| `Ctrl + w` → `c`   | **Create** new window                   |
| `Ctrl + w` → `n`   | **Next** window                         |
| `Ctrl + w` → `p`   | **Previous** window                     |
| `Ctrl + w` → `1-9` | Switch to window 1-9                    |
| `Ctrl + w` → `w`   | List all windows                        |
| `Ctrl + w` → `,`   | **Rename** window                       |
| `Ctrl + w` → `&`   | **Kill** window (asks for confirmation) |
| `Ctrl + w` → `l`   | Last active window                      |

> **Note:** Window indexing starts at 1 (not 0) in this config

---

## Panes 

### Creating Panes

| Command          | Action                              |
| ---------------- | ----------------------------------- |
| `Ctrl + w` → `%` | Split **vertically** (left/right)   |
| `Ctrl + w` → `"` | Split **horizontally** (top/bottom) |

### Navigating Panes

| Command                   | Action                                   |
| ------------------------- | ---------------------------------------- |
| `Ctrl + w` → `h/j/k/l`    | **Move between panes (vim-style)**       |
| `Ctrl + w` → `arrow keys` | Move between panes (also works)          |
| `Ctrl + w` → `o`          | Cycle through panes                      |
| `Ctrl + w` → `q`          | Show pane numbers (press number to jump) |
| `Ctrl + w` → `;`          | Toggle last active pane                  |

> **Vim keybindings:** `h` = left, `j` = down, `k` = up, `l` = right

### Managing Panes

| Command                     | Action                            |
| --------------------------- | --------------------------------- |
| `Ctrl + w` → `x`            | **Kill** current pane             |
| `Ctrl + w` → `z`            | **Zoom** pane (fullscreen toggle) |
| `Ctrl + w` → `!`            | Break pane into new window        |
| `Ctrl + w` → `{`            | Swap with previous pane           |
| `Ctrl + w` → `}`            | Swap with next pane               |
| `Ctrl + w` → `Ctrl + arrow` | Resize pane                       |
| `Ctrl + w` → `Space`        | Cycle through pane layouts        |

---

## Copy Mode (Scrolling & Copying)

| Command          | Action                                   |
| ---------------- | ---------------------------------------- |
| `Ctrl + w` → `[` | Enter **copy mode** (scroll with arrows) |
| `q` or `Esc`     | Exit copy mode                           |
| `Space`          | Start selection (in copy mode)           |
| `Enter`          | Copy selection                           |
| `Ctrl + w` → `]` | Paste                                    |
| `/`              | Search forward (in copy mode)            |
| `?`              | Search backward (in copy mode)           |
| `n`              | Next search result                       |
| `N`              | Previous search result                   |

**With mouse enabled:** Just scroll normally! (Mouse is enabled in this config)

---

## Help & Info

| Command          | Action                        |
| ---------------- | ----------------------------- |
| `Ctrl + w` → `?` | **Show all keybindings**      |
| `Ctrl + w` → `t` | Show clock (any key to exit)  |
| `Ctrl + w` → `i` | Display pane info             |
| `tmux info`      | Show tmux info (outside tmux) |

---

## Command Mode

| Command          | Action                             |
| ---------------- | ---------------------------------- |
| `Ctrl + w` → `:` | Enter command mode                 |
| `Ctrl + w` → `r` | **Reload config** (custom binding) |

### Useful Commands in Command Mode
```
:source-file ~/.tmux.conf    # Reload config (or just use Ctrl+w r)
:setw synchronize-panes on   # Type in all panes at once
:setw synchronize-panes off  # Disable sync
:resize-pane -D 10           # Resize down 10 lines
:resize-pane -U 10           # Resize up 10 lines
```

---
## Troubleshooting

| Problem            | Solution                                  |
| ------------------ | ----------------------------------------- |
| Can't scroll       | `Ctrl + w, [` for copy mode, or use mouse |
| Lost in panes      | `Ctrl + w, q` shows numbers               |
| Forgot command     | `Ctrl + w, ?` shows all keybindings       |
| Session stuck      | `tmux kill-session -t name` from outside  |
| Config not working | `Ctrl + w, r` to reload                   |
| Wrong colors       | Already set to `tmux-256color` in config  |
