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
vim.keymap.set('n', '<Leader>fn', function()
  local path = vim.fn.expand('%:p')
  vim.fn.setreg('+', path)
  vim.notify("File path copied to clipboard: " .. path)
end, { noremap = true, silent = true, desc = "Copy file path to clipboard" })
vim.keymap.set('c', '<C-w>', function()
  return vim.fn.expand('<cword>')
end, { expr = true, noremap = true, desc = "Insert the word under the cursor into the command prompt" })


-- Miscellaneous commands
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
vim.keymap.set('v', '<Leader>ed', ':s/^\\s*$\\n//g<CR>', { noremap = true, silent = true, desc = "Delete blank lines" })

-- Help commands
-- Toggle help window
vim.keymap.set('n', '<M-h>', function()
  -- Track the last help window and buffer
  local last_help = vim.w.last_help or { win = nil, buf = nil }
  -- Check if a help window is currently open
  local help_open = false
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == 'help' then
      help_open = true
      last_help.win = win
      last_help.buf = buf
      vim.api.nvim_win_close(win, true) -- Close the help window completely
      vim.w.last_help = last_help       -- Save the state of the help buffer
      return
    end
  end
  -- If no help window is open, restore or create a new one
  if not help_open then
    if last_help.buf and vim.api.nvim_buf_is_valid(last_help.buf) then
      vim.cmd('split')                           -- Open a vertical split for the help window
      vim.api.nvim_win_set_buf(0, last_help.buf) -- Restore the previous help buffer
    else
      vim.cmd('help')                            -- Open a new help window if no previous buffer exists
    end
  end
end, { desc = "Toggle help window" })

-- Open help for word or selection under cursor
vim.keymap.set({ 'n', 'v' }, '<C-M-h>', function()
  local mode = vim.fn.mode()
  local query = nil
  if mode == 'n' then
    -- In normal mode, get the word under the cursor
    query = vim.fn.expand('<cword>')
  elseif mode == 'v' then
    -- In visual mode, get the selected text
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    local lines = vim.fn.getline(start_pos[2], end_pos[2])
    if #lines > 0 then
      -- Extract the selected text from the first and last lines
      lines[1] = string.sub(lines[1], start_pos[3], -1)
      lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
      query = table.concat(lines, " ")
    end
  end
  if query and query ~= '' then
    vim.cmd('help ' .. query)
  else
    print("No word or selection to search in help!")
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

-- Toggle word-wrap
vim.keymap.set('n', '<M-w>', function()
  vim.wo.wrap = not vim.wo.wrap
  vim.notify(vim.wo.wrap and "Word wrap enabled" or "Word wrap disabled")
end, { noremap = true, silent = true, desc = "Toggle word wrap" })
