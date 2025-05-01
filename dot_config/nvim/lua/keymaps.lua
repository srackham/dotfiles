Utils = require 'utils' -- Load ./lua/utils.lua

-- Map custom next/previous navigation commands.
local function map_next_prev(next_key, next_cmd, prev_key, prev_cmd, desc)
  local execute_cmd_and_map_n = function(cmd1, cmd2)
    return function()
      vim.keymap.set('n', 'n', cmd1, { noremap = true, silent = true })
      vim.keymap.set('n', 'N', cmd2, { noremap = true, silent = true })
      cmd1()
    end
  end
  local n = type(next_cmd) == 'string' and function() vim.cmd(next_cmd) end or next_cmd
  local p = type(prev_cmd) == 'string' and function() vim.cmd(prev_cmd) end or prev_cmd
  vim.keymap.set('n', next_key, execute_cmd_and_map_n(n, p),
    { noremap = true, silent = true, desc = "Go to next " .. desc })
  vim.keymap.set('n', prev_key, execute_cmd_and_map_n(p, n),
    { noremap = true, silent = true, desc = "Go to previous " .. desc })
end

-- Restore native n and N commands prior to the execution of search commands `/`, `*` and `#`.
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

-- Install custom next/previous commands.
map_next_prev(']d', vim.diagnostic.goto_next, '[d', vim.diagnostic.goto_prev, "diagnostic message")
map_next_prev(']g', 'Gitsigns next_hunk', '[g', 'Gitsigns prev_hunk', "Git hunk")
map_next_prev(
  ']q', function()
    local success, _ = pcall(vim.cmd, 'cnext')
    if not success then
      vim.cmd('cfirst')
    end
  end,
  '[q', function()
    local success, _ = pcall(vim.cmd, 'cprev')
    if not success then
      vim.cmd('clast')
    end
  end, "Quickfix")
map_next_prev(']t', 'tabnext', '[t', 'tabprevious', "tab")
map_next_prev(']w', 'wincmd w', '[w', 'wincmd W', "window")
map_next_prev(']z', 'normal! ]s', '[z', 'normal! [s', "misspelt word")
-- Builtin markdown section navigation commands have first to be explicitly deleted from the current buffer.
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    pcall(vim.keymap.del, 'n', ']]', { buffer = 0 })
    pcall(vim.keymap.del, 'n', '[[', { buffer = 0 })
    map_next_prev(
      ']]', function() vim.fn.search('^#\\{1,5}\\s\\+\\S', 'W') end,
      '[[', function() vim.fn.search('^#\\{1,5}\\s\\+\\S', 'Wb') end,
      "markdown section")
  end
})

-- Miscellaneous commands
vim.keymap.set('n', '<Esc><Esc>', ':nohlsearch<CR>:echo<CR>',
  { silent = true, desc = "Turn highlighing off and clear status line" })
vim.keymap.set('n', '<C-Space>', '<C-f>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-M-Space>', '<C-b>', { noremap = true, silent = true })
vim.keymap.set('n', 'U', '<C-r>', { noremap = true, silent = true, desc = "Redo last change" })
vim.keymap.set('n', '<Leader>N', ':enew | w ++p ', { noremap = true, silent = false, desc = "New file" })
vim.keymap.set({ 'i', 'n' }, '<C-l>', '<Esc>[sz=', { noremap = true, silent = true }) -- Correct last error
vim.keymap.set('i', '<C-^>', '<Esc>:b#<CR>', { noremap = true, silent = true, desc = "Go to previously edited buffer" })
vim.keymap.set('n', '<F9>', ':b#<CR>', { noremap = true, silent = true, desc = "Go to previously edited buffer" })
vim.keymap.set('i', '<F9>', '<Esc>:b#<CR>', { noremap = true, silent = true, desc = "Go to previously edited buffer" })
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
    vim.cmd('write')
  end
  local file_path = vim.fn.expand('%:p') -- Get the full path of the current file
  M = assert(loadfile(file_path))()
  vim.notify("Module loaded into global variable 'M'", vim.log.levels.INFO)
end, { noremap = true, silent = true, desc = "Load current module file into global variable 'M'" })

-- Help commands
vim.keymap.set('n', '<M-h>', Utils.toggle_help_window, { desc = "Toggle help window" })

-- Open help for word or selection under cursor
vim.keymap.set({ 'n', 'v' }, '<C-M-h>', function()
  local query = Utils.get_selection_or_word()
  if query ~= '' then
    Utils.find_help(query)
  else
    vim.notify("No word or selection to search in help", vim.log.levels.ERROR)
  end
end, { desc = "Open help for word under cursor or selected text" })

-- Windows commands
local function close_window()
  -- Close the current window. If the `close` command fails (it won't close the last window on a buffer) then,
  -- after checking the buffer hasn't been modified, close the window by deleting the buffer.
  local success = pcall(function() vim.cmd('close') end)
  if not success then
    local current_buf_id = vim.api.nvim_get_current_buf()
    local is_modified = vim.api.nvim_buf_get_option(current_buf_id, 'modified')
    if is_modified then
      vim.notify("Cannot close window: buffer has unsaved changes", vim.log.levels.ERROR)
    else
      vim.cmd('bdelete')
    end
  end
end
vim.keymap.set('n', '<Leader>D', ':bdelete!<CR>', { noremap = true, silent = false, desc = "Discard buffer" })
vim.keymap.set('n', '<Leader>C', close_window, { noremap = true, silent = false, desc = "Close window" })
vim.keymap.set('n', '<Leader>wc', close_window, { noremap = true, silent = false, desc = "Close window" })
vim.keymap.set('n', '<Leader>wo', '<C-w>o', { noremap = true, silent = true, desc = "Leave only this window open" })
vim.keymap.set('n', '<Leader>wm', '<C-w>_', { noremap = true, silent = true, desc = "Maximize window" })
vim.keymap.set('n', '<Leader>w=', '<C-w>=', { noremap = true, silent = true, desc = "Equalize window sizes" })
vim.keymap.set('n', '<Leader>wv', '<C-w>v', { noremap = true, silent = true, desc = "Split window vertically" })
vim.keymap.set('n', '<Leader>ws', '<C-w>s', { noremap = true, silent = true, desc = "Split window horizontally" })

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
vim.keymap.set({ 'n', 'v' }, '<Leader>qm', function()
    local visual_mode = Utils.is_visual_mode()
    local query = Utils.get_selection_or_word()
    if query ~= '' then
      query = Utils.escape_regexp(query)
      if not visual_mode then
        query = '\\<' .. query .. '\\>' -- Search for whole word
      end
      vim.cmd('vimgrep /' .. query .. '/ % | copen')
    else
      vim.notify("No word or selection at cursor", vim.log.levels.ERROR)
    end
  end,
  {
    noremap = true,
    silent = true,
    desc = "Open quickfix list with current buffer locations matching the word or selection under the cursor"
  })

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

-- Terminal execution commands
--[[
These commands same modified buffers and then execute CLI commands in the tmux terminal pane.
The `send_keys_to_terminal` function resolves potential save/execute race conditions.
The core problem is that the Neovim `wa` command might return control before the
data has actually been fully written to the disk and propagated through the NFS
client's cache, and potentially acknowledged/visible via the NFS server.
]]

---@class SendKeysOptions
---@field editor_pane_id? number The tmux pane ID of the Neovim editor (default: 1).
---@field terminal_pane_id? number The tmux pane ID of the target terminal (default: 2).
---@field focus_pane_id? number The tmux pane ID to focus after sending keys (default: editor_pane_id).

--- Saves modified buffers and executes specified keys in a target tmux terminal pane.
---
--- 1. Saves all modified Neovim buffers (`:wa`).
--- 2. Pauses briefly to allow NFS time to potentially sync after the save.
--- 3. Constructs and executes a series of tmux commands:
---    - Switches focus to the specified terminal pane (`terminal_pane_id`).
---    - Runs `sync` command to flush filesystem buffers.
---    - Pauses briefly again.
---    - Sends the provided `keys` string to the terminal pane.
---    - Switches focus back to the `focus_pane_id` (defaults to the editor pane).
--- 4. The tmux command sequence is run in the background (`&`) so Neovim remains responsive.
---@param keys string The literal keys to send to the terminal pane via `tmux send-keys`. Escape special characters as needed for `tmux send-keys`.
---@param opts? SendKeysOptions Optional configuration options table.
local function send_keys_to_terminal(keys, opts)
  opts = opts or {}
  local editor_pane_id = opts.editor_pane_id or 1 -- nvim pane ID
  local term_pane_id = opts.terminal_pane_id or 2 -- Terminal pane ID
  local focus_pane_id = opts.focus_pane_id or editor_pane_id
  -- Save all buffers
  vim.cmd('silent! wa')
  vim.fn.system('sleep 0.1') -- Give NFS a moment
  -- Construct and run the tmux commands
  local tmux_cmd = string.format(
    "tmux select-pane -Z -t %d ; tmux run-shell 'sync' ; tmux run-shell 'sleep 0.1' ; tmux send-keys -t %d %s ; tmux select-pane -Z -t %d",
    term_pane_id, term_pane_id, keys, focus_pane_id
  )
  -- Run in background so Neovim doesn't block
  vim.fn.system(tmux_cmd .. ' &')
end

vim.keymap.set('n', '<leader>xx', function() send_keys_to_terminal('Up Enter') end,
  { noremap = true, silent = true, desc = "Save and run last terminal pane command" })
vim.keymap.set('n', '<leader>xg', function() send_keys_to_terminal('lazygit Enter', { focus_pane_id = 2 }) end,
  { noremap = true, silent = true, desc = "Save and run lazygit in the terminal pane" })
