Utils = require 'utils' -- Load ./lua/utils.lua

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
map_next_prev('q', function()
    local success, _ = pcall(vim.cmd, 'cnext')
    if not success then
      vim.cmd('cfirst')
    end
  end,
  function()
    local success, _ = pcall(vim.cmd, 'cprev')
    if not success then
      vim.cmd('clast')
    end
  end, "Quickfix")
map_next_prev('t', 'tabnext', 'tabprevious', "tab")
map_next_prev('w', 'wincmd w', 'wincmd W', "window")
map_next_prev('z', 'normal! ]s', 'normal! [s', "misspelt word")

-- Restore search n and N commands
local restore_next_prev = function()
  vim.keymap.set('n', 'n', 'n', { noremap = true, silent = true })
  vim.keymap.set('n', 'N', 'N', { noremap = true, silent = true })
end
vim.api.nvim_create_autocmd('CmdlineEnter', {
  pattern = { '/', '\\?' },
  callback = restore_next_prev,
})
vim.keymap.set('n', '*', function()
  restore_next_prev()
  return '*'
end, { expr = true })
vim.keymap.set('n', '#', function()
  restore_next_prev()
  return '#'
end, { expr = true })


-- Miscellaneous commands
vim.keymap.set('n', '<Esc><Esc>', ':nohlsearch<CR>:echo<CR>',
  { silent = true, desc = "Turn highlighing off and clear status line" })
vim.keymap.set('n', '<C-r>', '@:', { noremap = true, silent = true, desc = "Repeat the last command" })
vim.keymap.set('n', '<C-Space>', '<C-f>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-M-Space>', '<C-b>', { noremap = true, silent = true })
vim.keymap.set('n', 'U', '<C-r>', { noremap = true, silent = true, desc = "Redo last change" })
vim.keymap.set('n', '<Leader>N', ':enew | w ++p ', { noremap = true, silent = false, desc = "New file" })
vim.keymap.set({ 'i', 'n' }, '<C-l>', '<Esc>[sz=', { noremap = true, silent = true }) -- Correct last error
vim.keymap.set('i', '<C-^>', '<Esc>:b#<CR>', { noremap = true, silent = true, desc = "Go to previously edited buffer" })
vim.keymap.set({ 'n', 'v' }, 'Y', '"+y', { noremap = true, silent = true, desc = "Yank to clipboard" })
vim.keymap.set('n', 'YY', '"+yy', { noremap = true, silent = true, desc = "Yank line to clipboard" })
vim.keymap.set('i', '<M-p>', '<C-r>+', { noremap = true, silent = true, desc = "Paste clipboard" })
vim.keymap.set({ 'n', 'v' }, '<M-p>', '"+p', { noremap = true, silent = true, desc = "Paste clipboard" })
vim.keymap.set('n', '<M-P>', '"+P', { noremap = true, silent = true, desc = "Paste clipboard" })
vim.keymap.set('n', '<Leader>Z',
  function()
    vim.wo.spell = not vim.wo.spell
    local status = vim.wo.spell and "enabled" or "disabled"
    vim.notify("Spell checking " .. status)
  end,
  { noremap = true, silent = true, desc = "Toggle spell checker" })
vim.keymap.set('n', '<Leader>R', Utils.reload_modified_buffers,
  { noremap = true, silent = true, desc = "Reload modified buffers" })
vim.keymap.set('n', '<Leader>W', ':wa<CR>', { noremap = true, silent = true, desc = "Write modified buffers" })
vim.keymap.set('n', '<Leader>Q', ':qa!<CR>', { noremap = true, silent = true, desc = "Discard unsaved changes and exit" })
vim.keymap.set('n', '<Leader>X', ':confirm quitall<CR>',
  { noremap = true, silent = true, desc = "Write modified buffers and exit" })
vim.keymap.set('n', '<Leader>A', 'ggVG', { noremap = true, silent = true, desc = "Select all text in current buffer" })
vim.keymap.set('n', '<Leader>fn', function()
  local path = vim.fn.expand('%:p')
  vim.fn.setreg('+', path)
  vim.notify("File path copied to clipboard: " .. path)
end, { noremap = true, silent = true, desc = "Copy file path to clipboard" })
vim.keymap.set('c', '<C-w>', function()
  return vim.fn.expand('<cword>')
end, { expr = true, noremap = true, desc = "Insert the word under the cursor into the command prompt" })
vim.keymap.set('n', '<C-d>', 'dd', { noremap = true, silent = true, desc = "Delete line" })

local is_numbered = false -- Show line numbers
local is_relative = true  -- Use relative line numbers
local function set_numbered()
  if is_numbered then
    vim.wo.relativenumber = is_relative
    vim.wo.number = not is_relative
    vim.notify((is_relative and "Relative" or "Absolute") .. " line numbering enabled")
  else
    vim.wo.relativenumber = false
    vim.wo.number = false
    vim.notify("Line numbering disabled")
  end
end
vim.keymap.set('n', '<Leader>ol', function()
  is_numbered = not is_numbered
  set_numbered()
end, { noremap = true, silent = true, desc = "Toggle line numbering" })
vim.keymap.set('n', '<Leader>or', function()
  is_relative = not is_relative
  set_numbered()
end, { noremap = true, silent = true, desc = "Toggle relative line numbering" })
vim.keymap.set('v', '<Leader>ed', ':s/^\\s*$\\n//g<CR>', { noremap = true, silent = true, desc = "Delete blank lines" })
vim.keymap.set('n', '<Leader>fl', function()
  if vim.bo.modified then
    vim.cmd("write")
  end
  local file_path = vim.fn.expand('%:p') -- Get the full path of the current file
  M = assert(loadfile(file_path))()
  vim.notify("Module loaded into global variable 'M'", vim.log.levels.INFO)
end, { noremap = true, silent = true, desc = "Load current module file into global variable 'M'" })

-- Block commands
vim.keymap.set({ 'n', 'v' }, '<Leader>mb', Utils.break_block,
  { noremap = true, silent = true, desc = "Add/remove line breaks in the paragraph/selection at the cursor" })
vim.keymap.set({ 'n', 'v' }, '<Leader>mq', Utils.quote_block,
  { noremap = true, silent = true, desc = "Quote/unquote paragraph/selection at the cursor" })
vim.keymap.set({ 'n', 'v' }, '<Leader>mw', Utils.wrap_block,
  { noremap = true, silent = true, desc = "Wrap paragraph/selection at the cursor column" })
vim.keymap.set({ 'n', 'v' }, '<Leader>mn', Utils.number_block,
  { silent = true, noremap = true, desc = "Number/unnumber non-indented lines" })
vim.keymap.set({ 'n', 'v' }, '<Leader>mr', Utils.renumber_block,
  { silent = true, noremap = true, desc = "Renumber numbered lines" })

-- Help commands
vim.keymap.set('n', '<M-h>', Utils.toggle_help_window, { desc = "Toggle help window" })

-- Open help for word or selection under cursor
vim.keymap.set({ 'n', 'v' }, '<C-M-h>', function()
  local mode = vim.fn.mode()
  local query = nil
  if mode == 'n' then
    query = vim.fn.expand('<cword>')
  elseif mode == 'v' or mode == 'V' then
    query = Utils.get_visual_selection()
  end
  if query and query ~= '' then
    Utils.find_help(query)
  else
    vim.notify("No word or selection to search in help", vim.log.levels.ERROR)
  end
end, { desc = "Open help for word under cursor or selected text" })

-- Windows commands
local function close_window()
  -- Close the current window, prompt user to save if it has been modified, if it's the last window delete the buffer.
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
vim.keymap.set('n', '<Leader>D', ':bdelete!<CR>', { noremap = true, silent = false, desc = "Discard buffer" })
vim.keymap.set('n', '<Leader>wo', '<C-w>o', { noremap = true, silent = true, desc = "Leave only this window open" })
vim.keymap.set('n', '<Leader>wm', '<C-w>_', { noremap = true, silent = true, desc = "Maximize window" })
vim.keymap.set('n', '<Leader>wn', ':split<CR>', { noremap = true, silent = true, desc = "Open new window" })
vim.keymap.set('n', '<Leader>w=', '<C-w>=', { noremap = true, silent = true, desc = "Equalize window sizes" })

-- Window navigation with Ctrl + Arrow keys
vim.keymap.set('n', '<C-Up>', '<C-w>k', { noremap = true, silent = true })
vim.keymap.set('n', '<C-Down>', '<C-w>j', { noremap = true, silent = true })
vim.keymap.set('n', '<C-Left>', '<C-w>h', { noremap = true, silent = true })
vim.keymap.set('n', '<C-Right>', '<C-w>l', { noremap = true, silent = true })

-- Tab commands
vim.keymap.set('n', '<Leader>tn', ':tab split<CR>', { noremap = true, silent = true, desc = "Open buffer in new tab" })
vim.keymap.set('n', '<Leader>tc', ':tabclose<CR>', { noremap = true, silent = true, desc = "Close tab" })

-- Quickfix commands
vim.keymap.set('n', '<Leader>qc', ':cclose<CR>', { noremap = true, silent = true, desc = "Close Quickfix window" })
vim.keymap.set('n', '<Leader>qo', ':copen<CR>', { noremap = true, silent = true, desc = "Open Quickfix window" })
vim.keymap.set('n', '<Leader>qD', ':cexpr []<CR>',
  { noremap = true, silent = true, desc = "Delete all items from quickfix list" })
vim.keymap.set('n', '<Leader>qa', Utils.add_current_location_to_quickfix,
  { noremap = true, silent = true, desc = "Append location to quickfix list" })
vim.keymap.set('n', '<Leader>qd', Utils.delete_current_entry_from_quickfix,
  { noremap = true, silent = true, desc = "Delete current item from quickfix list" })
vim.keymap.set('n', '<Leader>qw', [[:execute 'vimgrep /' .. expand('<cword>') .. '/ %' | copen<CR>]],
  { noremap = true, silent = true, desc = "Open locations containing the word under the cursor in the quickfix list" })
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  callback = function()
    vim.keymap.set('n', '<C-d>', Utils.delete_current_entry_from_quickfix,
      { buffer = true, noremap = true, silent = true, desc = "Delete current item from quickfix list" })
  end,
})

-- Insert date
vim.keymap.set('i', '<M-d>', '<C-r>=strftime("%d-%b-%Y")<CR>', { noremap = true, silent = true, desc = "Insert date" })

-- Toggle word-wrap
vim.keymap.set('n', '<M-w>', function()
  vim.wo.wrap = not vim.wo.wrap
  vim.notify(vim.wo.wrap and "Word wrap enabled" or "Word wrap disabled")
end, { noremap = true, silent = true, desc = "Toggle word wrap" })
