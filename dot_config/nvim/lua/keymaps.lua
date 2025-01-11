-- Map contextual next and previous navigation commands
local function map_next_prev(key, next, prev, desc)
  local mapped_cmd = function(cmd, prev_cmd)
    return function()
      vim.keymap.set('n', 'n', cmd, { noremap = true, silent = true })
      vim.keymap.set('n', 'N', prev_cmd, { noremap = true, silent = true })
      cmd()
    end
  end
  local n = type(next) == "string" and function() vim.cmd(next) end or next
  local p = type(prev) == "string" and function() vim.cmd(prev) end or prev
  vim.keymap.set('n', ']' .. key, mapped_cmd(n, p), { noremap = true, silent = true, desc = "Go to next " .. desc })
  vim.keymap.set('n', '[' .. key, mapped_cmd(p, n), { noremap = true, silent = true, desc = "Go to previous " .. desc })
end

map_next_prev('d', vim.diagnostic.goto_next, vim.diagnostic.goto_prev, "diagnostic message")
map_next_prev('g', 'Gitsigns next_hunk', 'Gitsigns prev_hunk', "Git hunk")
map_next_prev('q', 'cnext', 'cprev', "Quickfix")
map_next_prev('t', 'tabnext', 'tabprevious', "tab")
map_next_prev('w', 'wincmd w', 'wincmd W', "window")
map_next_prev('s', 'normal! ]s', 'normal! [s', "misspelt word") -- Retain original mapping
map_next_prev('z', 'normal! ]s', 'normal! [s', "misspelt word")

-- Restore search n and N commands
vim.api.nvim_create_autocmd('CmdlineEnter', {
  pattern = '/,\\?',
  callback = function()
    vim.keymap.set('n', 'n', 'n', { noremap = true, silent = true })
    vim.keymap.set('n', 'N', 'N', { noremap = true, silent = true })
  end,
})

vim.keymap.set('n', '<M-v>', '<C-v>', { noremap = true, silent = true, desc = "Enter visual block mode" })
vim.keymap.set('n', '<Esc><Esc>', ':nohlsearch<CR>', { silent = true, desc = "Turn highlighing off" })
vim.keymap.set('n', 'U', '<C-r>', { noremap = true, silent = true, desc = "Redo last change" })
vim.keymap.set('n', '<Leader>N', ':enew | w ++p ', { noremap = true, silent = false, desc = "New file" })
vim.keymap.set('i', '<C-l>', '<Esc>[sz=', { noremap = true, silent = true }) -- Correct last error
vim.keymap.set('i', '<M-S-d>', '<C-r>=strftime("%d-%b-%Y")<CR>', { noremap = true, silent = true, desc = "Insert date" })
vim.keymap.set('n', '<Leader><Leader>', '<C-^>',
  { noremap = true, silent = true, desc = "Go to previously edited buffer" })
vim.keymap.set('n', '<Leader>Z', function()
  vim.wo.spell = not vim.wo.spell
  local status = vim.wo.spell and "enabled" or "disabled"
  print("Spell checking " .. status)
end, { noremap = true, silent = true, desc = "Toggle spell checker" })
vim.keymap.set('n', '<Leader>W', ':wa<CR>', { noremap = true, silent = true, desc = "Write all changed buffers" })
vim.keymap.set('n', '<Leader>X', ':update | confirm quitall<CR>',
  { noremap = true, silent = true, desc = "Write changed buffers and exit" })
vim.keymap.set('n', '<Leader>A', 'ggVG', { noremap = true, silent = true, desc = "Select all text in current buffer" })

-- Extra miscellaneous commands
local is_relative = false
local is_numbered = false
local function set_numbered()
  if is_numbered then
    vim.wo.relativenumber = is_relative
    vim.wo.number = not is_relative
    print((is_relative and "Relative" or "Absolute") .. " line numbering enabled")
  else
    vim.wo.relativenumber = false
    vim.wo.number = false
    print("Line numbering disabled")
  end
end
vim.keymap.set('n', '<Leader>xl', function()
  is_numbered = not is_numbered
  set_numbered()
end, { noremap = true, silent = true, desc = "Toggle line numbering" })
vim.keymap.set('n', '<Leader>xr', function()
  is_relative = not is_relative
  set_numbered()
end, { noremap = true, silent = true, desc = "Toggle relative line numbering" })

-- Map Ctrl+C to copy to the clipboard
vim.keymap.set('v', '<C-c>', '"+y', { noremap = true, silent = true, desc = "Copy selection to clipboard" })
-- Map Ctrl+X to delete to the clipboard
vim.keymap.set('v', '<C-x>', '"+d', { noremap = true, silent = true, desc = "Cut selection to clipboard" })
-- Map Ctrl+V to paste from the clipboard
vim.keymap.set('n', '<C-v>', '"+Pl', { noremap = true, silent = true, desc = "Paste clipboard" })
vim.keymap.set('v', '<C-v>', 'd"+Pl', { noremap = true, silent = true, desc = "Paste clipboard" })
vim.keymap.set('i', '<C-v>', '<C-r>+', { noremap = true, silent = true, desc = "Paste clipboard" })

-- Windows commands
local function close_window()
  local current_buf_id = vim.api.nvim_get_current_buf()
  local is_modified = vim.api.nvim_buf_get_option(current_buf_id, 'modified')
  if is_modified then
    vim.notify("Cannot close window: buffer has unsaved changes", vim.log.levels.ERROR)
  else
    local success = pcall(function() vim.cmd('close') end)
    if not success then
      vim.cmd('bdelete')
    end
  end
end
vim.keymap.set('n', '<Leader>wc', close_window, { noremap = true, silent = false, desc = "Close window" })
vim.keymap.set('n', '<Leader>C', close_window, { noremap = true, silent = false, desc = "Close window" })
vim.keymap.set('n', '<Leader>wC', '<C-w>o', { noremap = true, silent = true, desc = "Leave only this window open" })
vim.keymap.set('n', '<Leader>wm', '<C-w>_', { noremap = true, silent = true, desc = "Maximize window" })
vim.keymap.set('n', '<Leader>wo', ':split<CR>', { noremap = true, silent = true, desc = "Open new window" })
vim.keymap.set('n', '<Leader>w=', '<C-w>=', { noremap = true, silent = true, desc = "Equalize window sizes" })

-- Tab commands
vim.keymap.set('n', '<Leader>to', ':tab split<CR>', { noremap = true, silent = true, desc = "Open buffer in new tab" })
vim.keymap.set('n', '<Leader>tc', ':tabclose<CR>', { noremap = true, silent = true, desc = "Close tab" })

-- Quickfix commands
vim.keymap.set('n', '<Leader>qc', ':cclose<CR>', { noremap = true, silent = true, desc = "Close Quickfix window" })
vim.keymap.set('n', '<Leader>qo', ':copen<CR>', { noremap = true, silent = true, desc = "Open Quickfix window" })

-- Latin long vowels
vim.keymap.set('i', '<M-S-a>', 'ā', { noremap = true, silent = true })
vim.keymap.set('i', '<M-S-e>', 'ē', { noremap = true, silent = true })
vim.keymap.set('i', '<M-S-i>', 'ī', { noremap = true, silent = true })
vim.keymap.set('i', '<M-S-o>', 'ō', { noremap = true, silent = true })
vim.keymap.set('i', '<M-S-u>', 'ū', { noremap = true, silent = true })

-- UTF8 characters
vim.keymap.set('i', '<M-S-c>', '†', { noremap = true, silent = true })
vim.keymap.set('i', '<M-S-h>', '…', { noremap = true, silent = true })
vim.keymap.set('i', '<M-S-m>', '—', { noremap = true, silent = true })
vim.keymap.set('i', '<M-S-v>', '⋮', { noremap = true, silent = true })
vim.keymap.set('i', '<M-S-t>', '✓', { noremap = true, silent = true })
vim.keymap.set('i', '<M-S-x>', '✗', { noremap = true, silent = true })

vim.keymap.set('n', '<M-w>', function()
  vim.wo.wrap = not vim.wo.wrap
  print(vim.wo.wrap and "Word wrap enabled" or "Word wrap disabled")
end, { noremap = true, silent = true, desc = "Toggle word wrap" })
