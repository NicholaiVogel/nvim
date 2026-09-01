Neovim Configuration
===

Modular Neovim setup.

Installation
---

```bash
# Clone to config directory
git clone <repo-url> ~/.config/nvim
# Run setup script (installs opencode, symlinks dotfiles, adds shell aliases)
./setup.sh
# Launch Neovim - plugins install automatically
nvim
```

Features
---

This configuration provides LSP integration for TypeScript and
JavaScript with intelligent code navigation, autocompletion powered by
nvim-cmp with snippet expansion, and Telescope for fast fuzzy finding
across files, buffers, and content. Syntax highlighting uses Treesitter
for semantic understanding, and Prettier handles auto-formatting on
save.

Navigation uses `<Space>` as the leader key for all custom keybindings.
Fugitive handles git operations, Lualine provides status information,
and Neo-tree offers visual file management.
