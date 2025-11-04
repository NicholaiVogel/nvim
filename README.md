# Neovim Configuration

A clean, modular Neovim setup focused on TypeScript/JavaScript development.

## Structure

```
~/.config/nvim/
├── init.lua              # Entry point
└── lua/
    ├── core/
    │   ├── options.lua   # Vim settings
    │   └── keymaps.lua   # Key bindings
    └── plugins/
        └── plugin.lua    # Plugin specs & configs
```

## Features

- **Package Manager**: lazy.nvim
- **Color Scheme**: Catppuccin Mocha
- **File Explorer**: nvim-tree
- **Fuzzy Finder**: Telescope
- **LSP**: Mason + nvim-lspconfig
- **Autocompletion**: nvim-cmp with LSP support
- **Syntax**: Treesitter
- **Formatter**: Conform (Prettier)
- **Snippets**: LuaSnip + friendly-snippets

## Key Bindings

Leader key: `<Space>`

| Key | Action |
|-----|--------|
| `<leader>e` | Toggle file explorer |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Find buffers |
| `<leader>w` | Save |
| `<leader>q` | Quit |
| `<C-h/j/k/l>` | Navigate windows |

## Installation

1. Clone this repo to `~/.config/nvim`
2. Open Neovim - plugins will install automatically
3. Restart Neovim

## LSP Servers

Mason will auto-install:
- ts_ls (TypeScript)
- eslint
- jsonls
- html
- cssls
- tailwindcss
