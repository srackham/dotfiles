vim.keymap.set('n', '<A-v>', '<C-v>', { noremap = true, silent = true }) -- Map enter Visual Block mode
vim.keymap.set('n', '<Esc><Esc>', ':nohlsearch<CR>', { silent = true })  -- Turn highlighting off
vim.keymap.set('n', '/', '/\\v', { noremap = true })                     -- Use "very magic" for searches
vim.keymap.set('c', 's/', 's/\\v', { noremap = true })                   -- Use "very magic" for substitute

-- Map Ctrl+C to copy to the clipboard
vim.keymap.set('v', '<C-c>', '"+y', { noremap = true, silent = true })
-- Map Ctrl+X to delete to the clipboard
vim.keymap.set('v', '<C-x>', '"+d', { noremap = true, silent = true })
-- Map Ctrl+V to paste from the clipboard
vim.keymap.set('n', '<C-v>', '"+Pl', { noremap = true, silent = true })
vim.keymap.set('v', '<C-v>', 'd"+Pl', { noremap = true, silent = true })
vim.keymap.set('i', '<C-v>', '<C-r>+', { noremap = true, silent = true })

vim.keymap.set('n', 'U', '<C-r>', { noremap = true, silent = true, desc = "Redo last change" })
vim.keymap.set('n', '<Leader>n', ':enew | w ++p ', { noremap = true, silent = false, desc = "New file" })
vim.keymap.set('i', '<A-S-d>', '<C-r>=strftime("%d-%b-%Y")<CR>', { noremap = true, silent = true, desc = "Insert date" })
vim.keymap.set('n', '<Leader><Leader>', '<C-^>',
  { noremap = true, silent = true, desc = "Go to previously edited buffer" })

-- Spell checker mappings (https://neovim.io/doc/user/spell.html)
vim.keymap.set('n', '<Leader>s', ':set invspell<CR>', { noremap = true, silent = true }) -- Toggle spell checker

-- Windows commands
vim.keymap.set('n', '<Leader>wc', ':q<CR>', { noremap = true, silent = false, desc = "Close window" })
vim.keymap.set('n', '<Leader>wm', '<C-w>_', { noremap = true, silent = false, desc = "Maximize window" })
vim.keymap.set('n', '<Leader>wo', '<C-w>o', { noremap = true, silent = false, desc = "Only this window" })
vim.keymap.set('n', '<Leader>wu', ':update<CR>', { noremap = true, silent = false, desc = "Update window" })
vim.keymap.set('n', '<Leader>ww', '<C-w>w', { noremap = true, silent = false, desc = "Next window" })

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
