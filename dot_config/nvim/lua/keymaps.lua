-- Map Alt+C to enter Visual Block mode
vim.keymap.set('n', '<A-v>', '<C-v>', { noremap = true, silent = true })

-- Map Ctrl+C to copy to the clipboard
vim.keymap.set('v', '<C-c>', '"+y', { noremap = true, silent = true })

-- Map Ctrl+V to paste from the clipboard
vim.keymap.set('n', '<C-v>', '"+Pl', { noremap = true, silent = true })
vim.keymap.set('v', '<C-v>', 'd"+Pl', { noremap = true, silent = true })
vim.keymap.set('i', '<C-v>', '<C-r>+', { noremap = true, silent = true })

-- Map U to redo.
vim.keymap.set('n', 'U', '<C-r>', { noremap = true, silent = true })

vim.keymap.set('n', '<leader><leader>', '<C-^>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>c', ':update | bd<cr>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>q', ':wqa<cr>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>w', ':wa<cr>', { noremap = true, silent = true })
vim.keymap.set('i', '<A-S-d>', '<C-r>=strftime("%d-%b-%Y")<cr>', { noremap = true, silent = true })

-- Spell checker mappings (https://neovim.io/doc/user/spell.html)
vim.keymap.set('n', '<leader>s', ':set invspell<cr>', { noremap = true, silent = true }) -- Toggle spell checker
vim.keymap.set('i', '<C-l>', '<esc>[s1z=`]a', { noremap = true, silent = true })         -- Correct last error
