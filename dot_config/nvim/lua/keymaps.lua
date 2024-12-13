-- Map Ctrl+C to copy to the clipboard
vim.keymap.set('v', '<C-c>', '"+y', { noremap = true, silent = true })

-- Map Ctrl+V to paste from the clipboard
vim.keymap.set('n', '<C-v>', '"+p', { noremap = true, silent = true })
vim.keymap.set('i', '<C-v>', '<C-r>+', { noremap = true, silent = true })

-- Map Alt+C to enter Visual Block mode
vim.keymap.set('n', '<A-v>', '<C-v>', { noremap = true, silent = true })

-- Map U to redo.
vim.keymap.set('n', 'U', '<C-r>', { noremap = true, silent = true })

vim.keymap.set('n', '<leader><leader>', '<C-^>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>c', ':update | bd<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>q', ':wqa<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>w', ':wa<CR>', { noremap = true, silent = true })
vim.keymap.set('i', '<A-S-d>', '<C-r>=strftime("%d-%b-%Y")<CR>', { noremap = true, silent = true })
