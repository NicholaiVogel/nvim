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

New Features
--- 

- AI-powered code generation via ThePrimeagen's agent plugin
    - `fill_in_function`: generates function bodies from context
    - visual mode: modify selected code with AI
    - `stop_all_requests`: cancel pending AI operations
    - supports SKILL.md and AGENT.md for custom rules

Features
---

This configuration provides LSP integration for TypeScript and
JavaScript with intelligent code navigation, autocompletion powered by
nvim-cmp with snippet expansion, and Telescope for fast fuzzy finding
across files, buffers, and content. Syntax highlighting uses Treesitter
for semantic understanding, and Prettier handles auto-formatting on
save.

AI-powered development is available through ThePrimeagen's agent plugin.
Use `fill_in_function` to generate function implementations from
context, or select code in visual mode and transform it with natural
language prompts. Cancel pending operations with `stop_all_requests`.
Custom behavior can be defined via SKILL.md and AGENT.md files.

Navigation uses `<Space>` as the leader key for all custom keybindings.
Fugitive handles git operations, Lualine provides status information,
and Neo-tree offers visual file management.
