-- Basic Settings
local config = require("core.config")
local editor = config.editor()

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.wrap = false
vim.opt.tabstop = editor.tabSize
vim.opt.shiftwidth = editor.tabSize
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.signcolumn = 'yes'
vim.opt.clipboard = "unnamedplus"
vim.opt.scrolloff = editor.scrollOffset
vim.opt.sidescrolloff = editor.scrollOffset

-- Leader key
vim.g.mapleader = ' '
