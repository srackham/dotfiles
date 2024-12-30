vim.keymap.set('n', '<M-v>', '<C-v>', { noremap = true, silent = true, desc = "Enter visual block mode" })
vim.keymap.set('n', '<Esc><Esc>', ':nohlsearch<CR>', { silent = true, desc = "Turn highlighing off" })
vim.keymap.set('n', 'U', '<C-r>', { noremap = true, silent = true, desc = "Redo last change" })
vim.keymap.set('n', '<Leader>n', ':enew | w ++p ', { noremap = true, silent = false, desc = "New file" })
vim.keymap.set('i', '<M-S-d>', '<C-r>=strftime("%d-%b-%Y")<CR>', { noremap = true, silent = true, desc = "Insert date" })
vim.keymap.set('n', '<Leader><Leader>', '<C-^>',
  { noremap = true, silent = true, desc = "Go to previously edited buffer" })
vim.keymap.set('n', '<Leader>S', ':set invspell<CR>', { noremap = true, silent = true, desc = "Toggle spell checker" })
vim.keymap.set('n', '<Space>', '<C-f>', { noremap = true, silent = true })
vim.keymap.set('n', '<M-Space>', '<C-b>', { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>W', ':wa<CR>', { noremap = true, silent = true, desc = "Write all changed buffers" })
vim.keymap.set('n', '<Leader>X', ':update | confirm quit<CR>',
  { noremap = true, silent = true, desc = "Write changed buffers and exit" })
vim.keymap.set('n', '<Leader>A', 'ggVG', { noremap = true, silent = true, desc = "Select all text in current buffer" })

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
vim.keymap.set('n', '<Leader>wm', '<C-w>_', { noremap = true, silent = true, desc = "Maximize window" })
vim.keymap.set('n', '<Leader>wo', '<C-w>o', { noremap = true, silent = true, desc = "Leave only this window open" })
vim.keymap.set('n', '<Leader>ws', ':split', { noremap = true, silent = true, desc = "Split window horizontally" })
vim.keymap.set('n', '<Leader>wu', ':update<CR>', { noremap = true, silent = true, desc = "Save window" })
vim.keymap.set('n', '<Leader>ww', '<C-w>w', { noremap = true, silent = true, desc = "Go to next window" })
vim.keymap.set('n', '<Leader>w=', '<C-w>=', { noremap = true, silent = true, desc = "Equalize window sizes" })

-- Quickfix commands
vim.keymap.set('n', ']q', ':cnext<CR>', { noremap = true, silent = true, desc = "Go to next Quickfix" })
vim.keymap.set('n', '[q', ':cprev<CR>', { noremap = true, silent = true, desc = "Go to previous Quickfix" })
vim.keymap.set('n', '<Leader>qc', ':cclose<CR>', { noremap = true, silent = true, desc = "Close Quickfix window" })
vim.keymap.set('n', '<Leader>qo', ':copen<CR>', { noremap = true, silent = true, desc = "Open Quickfix window" })

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

vim.keymap.set('n', '<M-w>', function()
  vim.wo.wrap = not vim.wo.wrap
  if vim.wo.wrap then
    print("Word wrap enabled")
  else
    print("Word wrap disabled")
  end
end, { noremap = true, silent = true, desc = "Toggle word wrap" })

-- When a command is executed map its corresponding next and previous motions to n and N
local function next_prev_cmd(cmd, next, prev)
  vim.keymap.set('n', 'n', function() vim.cmd(next) end, { noremap = true, silent = true })
  vim.keymap.set('n', 'N', function() vim.cmd(prev) end, { noremap = true, silent = true })
  vim.cmd(cmd)
end

-- Restore search n and N commands
vim.api.nvim_create_autocmd('CmdlineEnter', {
  pattern = '/,\\?',
  callback = function()
    vim.keymap.set('n', 'n', 'n', { noremap = true, silent = true })
    vim.keymap.set('n', 'N', 'N', { noremap = true, silent = true })
  end,
})

-- Next and previous for spelling correction
vim.keymap.set('n', ']s', function() next_prev_cmd('normal! ]s', 'normal! ]s', 'normal! [s') end,
  { noremap = true, silent = true })
vim.keymap.set('n', '[s', function() next_prev_cmd('normal! [s', 'normal! [s', 'normal! ]s') end,
  { noremap = true, silent = true })

-- Next and previous for Git hunks
vim.keymap.set('n', ']g',
  function() next_prev_cmd('Gitsigns next_hunk', 'Gitsigns next_hunk', 'Gitsigns prev_hunk') end,
  { noremap = true, silent = true })
vim.keymap.set('n', '[g',
  function() next_prev_cmd('Gitsigns prev_hunk', 'Gitsigns prev_hunk', 'Gitsigns next_hunk') end,
  { noremap = true, silent = true })

-- Next and previous for Quickfix
vim.keymap.set('n', ']q', function() next_prev_cmd('cnext', 'cnext', 'cprev') end, { noremap = true, silent = true })
vim.keymap.set('n', '[q', function() next_prev_cmd('cprev', 'cprev', 'cnext') end, { noremap = true, silent = true })
