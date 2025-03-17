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

vim.keymap.set('n', '<Esc><Esc>', ':nohlsearch<CR>:echo<CR>',
  { silent = true, desc = "Turn highlighing off and clear status line" })
vim.keymap.set('n', '<C-Space>', '<C-f>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-M-Space>', '<C-b>', { noremap = true, silent = true })
vim.keymap.set('n', 'U', '<C-r>', { noremap = true, silent = true, desc = "Redo last change" })
vim.keymap.set('n', '<Leader>N', ':enew | w ++p ', { noremap = true, silent = false, desc = "New file" })
vim.keymap.set({ 'i', 'n' }, '<C-l>', '<Esc>[sz=', { noremap = true, silent = true }) -- Correct last error
vim.keymap.set('i', '<C-^>', '<Esc>:b#<CR>', { noremap = true, silent = true, desc = "Go to previously edited buffer" })
vim.keymap.set('n', '<Leader>Z',
  function()
    vim.wo.spell = not vim.wo.spell
    local status = vim.wo.spell and "enabled" or "disabled"
    vim.notify("Spell checking " .. status)
  end,
  { noremap = true, silent = true, desc = "Toggle spell checker" })
vim.keymap.set('n', '<Leader>R',
  function()
    local buffers = vim.api.nvim_list_bufs()
    local msgs = {}
    for _, bufnr in ipairs(buffers) do
      if vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_buf_get_option(bufnr, 'modified') then
        local filename = vim.api.nvim_buf_get_name(bufnr)
        vim.api.nvim_buf_call(bufnr, function()
          vim.cmd('e!')
        end)
        table.insert(msgs, "Reloaded buffer: " .. filename)
      end
    end
    if #msgs > 0 then
      vim.notify(table.concat(msgs, "\n"))
    end
  end,
  { noremap = true, silent = true, desc = "Reload modified buffers" })
vim.keymap.set('n', '<Leader>W', ':wa<CR>', { noremap = true, silent = true, desc = "Write modified buffers" })
vim.keymap.set('n', '<Leader>Q', ':qa!<CR>', { noremap = true, silent = true, desc = "Discard unsaved changes and exit" })
vim.keymap.set('n', '<Leader>X', ':confirm quitall<CR>',
  { noremap = true, silent = true, desc = "Write modified buffers and exit" })
vim.keymap.set('n', '<Leader>A', 'ggVG', { noremap = true, silent = true, desc = "Select all text in current buffer" })
vim.keymap.set('n', '<Leader>fc', function()
  local path = vim.fn.expand('%:p')
  vim.fn.setreg('+', path)
  vim.notify("File path copied to clipboard: " .. path)
end, { noremap = true, silent = true, desc = "Copy file path to clipboard" })

-- Extra miscellaneous commands
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
vim.keymap.set('x', '<Leader>mn', [[:s/^\d\+\./\=line('.') - line("'<") + 1 . '.'<CR>]],
  { silent = true, noremap = true, desc = "Renumber selected Markdown list" })


-- Map Ctrl+C to copy to the clipboard
vim.keymap.set('v', '<C-c>', '"+y', { noremap = true, silent = true, desc = "Copy selection to clipboard" })
-- Map Ctrl+X to delete to the clipboard
vim.keymap.set('v', '<C-x>', '"+d', { noremap = true, silent = true, desc = "Cut selection to clipboard" })
-- Map Ctrl+V to paste from the clipboard
vim.keymap.set('n', '<M-v>', '<C-v>', { noremap = true, silent = true, desc = "Enter visual block mode" })
vim.keymap.set('i', '<M-v>', '<C-v>', { noremap = true, silent = true, desc = "Enter control character" })
vim.keymap.set('n', '<C-v>', '"+Pl', { noremap = true, silent = true, desc = "Paste clipboard" })
vim.keymap.set('v', '<C-v>', 'd"+Pl', { noremap = true, silent = true, desc = "Paste clipboard" })
vim.keymap.set('i', '<C-v>', '<C-r>+', { noremap = true, silent = true, desc = "Paste clipboard" })

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
vim.keymap.set('n', '<Leader>qd', ':cexpr []<CR>',
  { noremap = true, silent = true, desc = "Delete all items from quickfix list" })

local function add_current_location_to_quickfix()
  local current_file = vim.fn.expand('%:p')
  local current_line = vim.fn.line('.')
  local current_col = vim.fn.col('.')
  local current_text = vim.fn.getline('.')
  local new_item = {
    filename = current_file,
    lnum = current_line,
    col = current_col,
    text = current_text
  }
  local qf_list = vim.fn.getqflist()
  table.insert(qf_list, new_item)
  vim.fn.setqflist(qf_list)
end
vim.keymap.set('n', '<Leader>qa', add_current_location_to_quickfix,
  { noremap = true, silent = true, desc = "Append location to quickfix list" })

-- Insert date
vim.keymap.set('i', '<M-d>', '<C-r>=strftime("%d-%b-%Y")<CR>', { noremap = true, silent = true, desc = "Insert date" })

-- Insert UTF8 characters with Alt+U leader
-- Latin long vowels
vim.keymap.set('i', '<M-u>a', 'ā', { noremap = true, silent = true })
vim.keymap.set('i', '<M-u>e', 'ē', { noremap = true, silent = true })
vim.keymap.set('i', '<M-u>i', 'ī', { noremap = true, silent = true })
vim.keymap.set('i', '<M-u>o', 'ō', { noremap = true, silent = true })
vim.keymap.set('i', '<M-u>u', 'ū', { noremap = true, silent = true })
-- Miscelaneous characters
vim.keymap.set('i', '<M-u> ', ' ', { noremap = true, silent = true }) -- Non-breaking space (U+00A0)
vim.keymap.set('i', '<M-u>c', '†', { noremap = true, silent = true })
vim.keymap.set('i', '<M-u>h', '…', { noremap = true, silent = true })
vim.keymap.set('i', '<M-u>m', '—', { noremap = true, silent = true })
vim.keymap.set('i', '<M-u>n', '≠', { noremap = true, silent = true })
vim.keymap.set('i', '<M-u>t', '✓', { noremap = true, silent = true })
vim.keymap.set('i', '<M-u>v', '⋮', { noremap = true, silent = true })
vim.keymap.set('i', '<M-u>x', '✗', { noremap = true, silent = true })

-- Toggle word-wrap
vim.keymap.set('n', '<M-w>', function()
  vim.wo.wrap = not vim.wo.wrap
  vim.notify(vim.wo.wrap and "Word wrap enabled" or "Word wrap disabled")
end, { noremap = true, silent = true, desc = "Toggle word wrap" })
