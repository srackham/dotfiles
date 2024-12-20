-- Map Alt+C to enter Visual Block mode
vim.keymap.set('n', '<A-v>', '<C-v>', { noremap = true, silent = true })

-- Map Ctrl+C to copy to the clipboard
vim.keymap.set('v', '<C-c>', '"+y', { noremap = true, silent = true })
-- Map Ctrl+X to delete to the clipboard
vim.keymap.set('v', '<C-x>', '"+d', { noremap = true, silent = true })
-- Map Ctrl+V to paste from the clipboard
vim.keymap.set('n', '<C-v>', '"+Pl', { noremap = true, silent = true })
vim.keymap.set('v', '<C-v>', 'd"+Pl', { noremap = true, silent = true })
vim.keymap.set('i', '<C-v>', '<C-r>+', { noremap = true, silent = true })

-- Map U to redo.
vim.keymap.set('n', 'U', '<C-r>', { noremap = true, silent = true })

vim.keymap.set('n', '<Leader><Leader>', '<C-^>', { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>c', ':update | bd<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>n', ':enew | w ++p ', { noremap = true, silent = false })
vim.keymap.set('n', '<Leader>q', ':wqa<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>w', ':wa<CR>', { noremap = true, silent = true })
vim.keymap.set('i', '<A-S-d>', '<C-r>=strftime("%d-%b-%Y")<CR>', { noremap = true, silent = true })

-- Spell checker mappings (https://neovim.io/doc/user/spell.html)
vim.keymap.set('n', '<Leader>s', ':set invspell<CR>', { noremap = true, silent = true }) -- Toggle spell checker
vim.keymap.set('i', '<C-s>', '<Esc>[s1z=`]a', { noremap = true, silent = true })         -- Correct last spell error

-- Latin long vowels
vim.keymap.set('i', '<C-Bslash>a', 'ā', { noremap = true, silent = true })
vim.keymap.set('i', '<C-Bslash>e', 'ē', { noremap = true, silent = true })
vim.keymap.set('i', '<C-Bslash>i', 'ī', { noremap = true, silent = true })
vim.keymap.set('i', '<C-Bslash>o', 'ō', { noremap = true, silent = true })
vim.keymap.set('i', '<C-Bslash>u', 'ū', { noremap = true, silent = true })

-- UTF8 characters
vim.keymap.set('i', '<C-Bslash>d', '†', { noremap = true, silent = true })
vim.keymap.set('i', '<C-Bslash>h', '…', { noremap = true, silent = true })
vim.keymap.set('i', '<C-Bslash>m', '—', { noremap = true, silent = true })
vim.keymap.set('i', '<C-Bslash>v', '⋮', { noremap = true, silent = true })
