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
-- vim.opt.clipboard = "unnamedplus"
vim.opt.clipboard = "unnamedplus"
vim.g.termfeatures = vim.g.termfeatures or {}
vim.g.termfeatures.osc52 = true
local ok, osc52 = pcall(require, "vim.ui.clipboard.osc52")
if ok then
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = osc52.copy("+"),
      ["*"] = osc52.copy("*"),
    },
    paste = {
      ["+"] = osc52.paste("+"),
      ["*"] = osc52.paste("*"),
    },
  }
end
vim.opt.scrolloff = editor.scrollOffset
vim.opt.sidescrolloff = editor.scrollOffset

-- Leader key
vim.g.mapleader = ' '
