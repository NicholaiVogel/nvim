# Neovim Cheatsheet

## Modes
- `i` - Insert mode (start typing)
- `v` - Visual mode (select text)
- `V` - Visual line mode (select full lines)
- `Ctrl+v` - Visual block mode (select columns)
- `Esc` or `Ctrl+[` - Return to Normal mode
- `:` - Command mode

## Basic Navigation
- `h` `j` `k` `l` - Left, Down, Up, Right
- `w` - Jump forward to start of word
- `b` - Jump backward to start of word
- `e` - Jump to end of word
- `0` - Jump to start of line
- `^` - Jump to first non-blank character
- `$` - Jump to end of line
- `gg` - Go to top of file
- `G` - Go to bottom of file
- `{number}G` - Go to line number (e.g., `42G`)
- `Ctrl+d` - Scroll down half page
- `Ctrl+u` - Scroll up half page
- `Ctrl+f` - Scroll down full page
- `Ctrl+b` - Scroll up full page
- `%` - Jump to matching bracket/parenthesis

## Editing
- `i` - Insert before cursor
- `a` - Insert after cursor
- `I` - Insert at start of line
- `A` - Insert at end of line
- `o` - Open new line below
- `O` - Open new line above
- `x` - Delete character under cursor
- `dd` - Delete current line
- `dw` - Delete word
- `d$` or `D` - Delete to end of line
- `d0` - Delete to start of line
- `cc` - Change entire line (delete and enter insert mode)
- `cw` - Change word
- `u` - Undo
- `Ctrl+r` - Redo
- `yy` - Yank (copy) current line
- `yw` - Yank word
- `y$` - Yank to end of line
- `p` - Paste after cursor
- `P` - Paste before cursor
- `r{char}` - Replace single character
- `.` - Repeat last command

## Visual Mode
- `v` - Start visual mode
- `V` - Start visual line mode
- `Ctrl+v` - Start visual block mode
- `y` - Yank (copy) selection
- `d` - Delete selection
- `c` - Change selection
- `>` - Indent selection
- `<` - Unindent selection
- `~` - Toggle case

## Search & Replace
- `/pattern` - Search forward
- `?pattern` - Search backward
- `n` - Next search result
- `N` - Previous search result
- `*` - Search for word under cursor
- `:%s/old/new/g` - Replace all occurrences in file
- `:%s/old/new/gc` - Replace with confirmation
- `:noh` - Clear search highlighting

## File Operations
- `:w` - Save file
- `:q` - Quit
- `:wq` or `:x` - Save and quit
- `:q!` - Quit without saving
- `:e filename` - Open file
- `:bn` - Next buffer
- `:bp` - Previous buffer
- `:bd` - Close buffer

## Window Management
- `:sp` or `:split` - Split horizontally
- `:vsp` or `:vsplit` - Split vertically
- `Ctrl+w h/j/k/l` - Navigate between windows
- `Ctrl+w w` - Cycle through windows
- `Ctrl+w q` - Close current window
- `Ctrl+w =` - Make windows equal size
- `Ctrl+w _` - Maximize height
- `Ctrl+w |` - Maximize width

## Custom Keybindings
*Based on your config with `<leader>` = Space*

### File Explorer
- `Space+e` - Toggle NvimTree file explorer

### Fuzzy Finder (Telescope)
- `Space+ff` - Find files
- `Space+fg` - Live grep (search in files)
- `Space+fb` - Find buffers

### Window Navigation
- `Ctrl+h` - Move to left window
- `Ctrl+j` - Move to down window
- `Ctrl+k` - Move to up window
- `Ctrl+l` - Move to right window

### Quick Actions
- `Space+w` - Save file
- `Space+q` - Quit

### Autocompletion
- `Ctrl+Space` - Trigger completion
- `Enter` - Confirm completion
- `Tab` - Next completion item
- `Shift+Tab` - Previous completion item

## Useful Tips
- **Repeat actions**: Number before command (e.g., `5dd` deletes 5 lines)
- **Combine motions**: `d3w` deletes 3 words, `y2j` yanks 2 lines down
- **Inside/Around**: `ci"` change inside quotes, `da(` delete around parentheses
- **Jump to character**: `f{char}` jump forward to char, `F{char}` jump backward
- `;` repeat last f/F/t/T, `,` repeat in opposite direction
- **Macros**: 
  - `q{letter}` start recording to register
  - `q` stop recording
  - `@{letter}` play macro
  - `@@` replay last macro

## Command Line Tricks
- `:!command` - Run shell command
- `:r !command` - Insert command output
- `:%!command` - Filter file through command
- `:term` - Open terminal in vim

## Marks & Jumps
- `m{letter}` - Set mark
- `'{letter}` - Jump to mark
- `''` - Jump back to previous position
- `Ctrl+o` - Jump to older position
- `Ctrl+i` - Jump to newer position

## Pro Tips
- Use `.` to repeat your last change - super powerful!
- Learn to use `ci"`, `ci'`, `ci(`, `ci{` to change inside quotes/brackets
- Combine counts with motions: `3w`, `5j`, `2dd`
- Use relative line numbers (you have this enabled!) with counts: `5j` to jump 5 lines down
- System clipboard integration: Just yank normally with `y` - it copies to system clipboard! (You have `clipboard=unnamedplus` set)

---
*Last updated: November 2025*
