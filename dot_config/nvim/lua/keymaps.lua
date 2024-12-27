vim.keymap.set('n', '<A-v>', '<C-v>', { noremap = true, silent = true, desc = "Enter visual block mode" })
vim.keymap.set('n', '<Esc><Esc>', ':nohlsearch<CR>', { silent = true, desc = "Turn highlighing off" })
vim.keymap.set('n', 'U', '<C-r>', { noremap = true, silent = true, desc = "Redo last change" })
vim.keymap.set('n', '<Leader>n', ':enew | w ++p ', { noremap = true, silent = false, desc = "New file" })
vim.keymap.set('i', '<A-S-d>', '<C-r>=strftime("%d-%b-%Y")<CR>', { noremap = true, silent = true, desc = "Insert date" })
vim.keymap.set('n', '<Leader><Leader>', '<C-^>',
  { noremap = true, silent = true, desc = "Go to previously edited buffer" })
vim.keymap.set('n', '<Leader>S', ':set invspell<CR>', { noremap = true, silent = true, desc = "Toggle spell checker" })
vim.keymap.set('n', '<Space>', '<C-f>', { noremap = true, silent = true })
vim.keymap.set('n', '<A-Space>', '<C-b>', { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>q', 'ZZ', { noremap = true, silent = true, desc = "Save current buffer and exit" })

-- Map Ctrl+C to copy to the clipboard
vim.keymap.set('v', '<C-c>', '"+y', { noremap = true, silent = true, desc = "Copy selection to clipboard" })
-- Map Ctrl+X to delete to the clipboard
vim.keymap.set('v', '<C-x>', '"+d', { noremap = true, silent = true, desc = "Cut selection to clipboard" })
-- Map Ctrl+V to paste from the clipboard
vim.keymap.set('n', '<C-v>', '"+Pl', { noremap = true, silent = true, desc = "Paste clipboard" })
vim.keymap.set('v', '<C-v>', 'd"+Pl', { noremap = true, silent = true, desc = "Paste clipboard" })
vim.keymap.set('i', '<C-v>', '<C-r>+', { noremap = true, silent = true, desc = "Paste clipboard" })

-- Windows commands
vim.keymap.set('n', '<Leader>wc', ':update | bdelete<CR>', { noremap = true, silent = false, desc = "Close window" })
vim.keymap.set('n', '<Leader>wm', '<C-w>_', { noremap = true, silent = false, desc = "Maximize window" })
vim.keymap.set('n', '<Leader>wo', '<C-w>o', { noremap = true, silent = false, desc = "Only this window" })
vim.keymap.set('n', '<Leader>ws', ':split', { noremap = true, silent = false, desc = "Split window horizontally" })
vim.keymap.set('n', '<Leader>wu', ':update<CR>', { noremap = true, silent = false, desc = "Update window" })
vim.keymap.set('n', '<Leader>ww', '<C-w>w', { noremap = true, silent = false, desc = "Next window" })
vim.keymap.set('n', '<Leader>w=', '<C-w>=', { noremap = true, silent = false, desc = "Equalize window sizes" })

-- Quickfix commands
vim.keymap.set('n', '<C-n>', ':cnext<CR>', { noremap = true, silent = false, desc = "Go to next Quickfix" })
vim.keymap.set('n', '<C-p>', ':cprev<CR>', { noremap = true, silent = false, desc = "Go to previous Quickfix" })
vim.keymap.set('n', '<Leader>qc', ':cclose<CR>', { noremap = true, silent = false, desc = "Close Quickfix window" })
vim.keymap.set('n', '<Leader>qo', ':copen<CR>', { noremap = true, silent = false, desc = "Open Quickfix window" })

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

vim.keymap.set('n', '<A-w>', function()
  vim.wo.wrap = not vim.wo.wrap
  if vim.wo.wrap then
    print("Word wrap enabled")
  else
    print("Word wrap disabled")
  end
end, { noremap = true, silent = true, desc = "Toggle word wrap" })
