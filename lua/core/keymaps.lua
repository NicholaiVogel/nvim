-- Key mappings
local keymap = vim.keymap.set

-- File explorer
keymap('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = "Toggle file explorer" })

-- Fuzzy finder
keymap('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = "Find files" })
keymap('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { desc = "Live grep" })
keymap('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { desc = "Find buffers" })

-- Better window navigation
keymap('n', '<C-h>', '<C-w>h')
keymap('n', '<C-j>', '<C-w>j')
keymap('n', '<C-k>', '<C-w>k')
keymap('n', '<C-l>', '<C-w>l')

-- Quick save and quit
keymap('n', '<leader>w', ':w<CR>', { desc = "Save" })
keymap('n', '<leader>q', ':q<CR>', { desc = "Quit" })
