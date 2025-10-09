Utils = require 'utils' -- Load ./lua/utils.lua

-- Map custom next/previous navigation commands.
local execute_cmd_and_map_n = function(next_cmd, prev_cmd)
  return function()
    local n = type(next_cmd) == 'string' and function() vim.cmd(next_cmd) end or next_cmd
    local p = type(prev_cmd) == 'string' and function() vim.cmd(prev_cmd) end or prev_cmd
    vim.keymap.set('n', 'n', n, { noremap = true, silent = true })
    vim.keymap.set('n', 'N', p, { noremap = true, silent = true })
    n()
  end
end
local function map_next_prev(next_key, next_cmd, prev_key, prev_cmd, desc)
  vim.keymap.set('n', next_key, execute_cmd_and_map_n(next_cmd, prev_cmd),
    { noremap = true, silent = true, desc = "Go to next " .. desc })
  vim.keymap.set('n', prev_key, execute_cmd_and_map_n(prev_cmd, next_cmd),
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
map_next_prev(
  ']d', function() vim.diagnostic.jump({ count = 1, float = false }) end,
  '[d', function() vim.diagnostic.jump({ count = -1, float = false }) end,
  "diagnostic message")
map_next_prev(']g', 'Gitsigns next_hunk', '[g', 'Gitsigns prev_hunk', "Git hunk")
map_next_prev(
  ']q', function()
    pcall(function() vim.cmd('cnext') end)
  end,
  '[q', function()
    pcall(function() vim.cmd('cprev') end)
  end, "Quickfix")
map_next_prev(']t', 'tabnext', '[t', 'tabprevious', "tab")
map_next_prev(']w', 'wincmd w', '[w', 'wincmd W', "window")
map_next_prev(']s', 'normal! ]s', '[s', 'normal! [s', "misspelt word")
map_next_prev('g,', 'normal! g,', 'g;', 'normal! g;', "change") -- Adds n/N functionality to `g,` and `g;` commands

-- Adds n/N functionality to Markdown section navigation commands
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
vim.keymap.set('n', '<M-;>', ',', { noremap = true, silent = true, desc = "Page up" }) -- Because comma is the Leader
vim.keymap.set('n', '<Leader>eh', '<Cmd>nohlsearch<CR><Cmd>echo<CR>',                  -- Turn of search highlighting and clear status line
  { silent = true, desc = "Turn highlighting off and clear status line" })
vim.keymap.set('n', 'U', '<C-r>', { noremap = true, silent = true, desc = "Redo last change" })
vim.keymap.set('i', '<C-^>', '<Esc><Cmd>b#<CR>',
  { noremap = true, silent = true, desc = "Go to previously edited buffer" })
vim.keymap.set('n', '\\', '<Cmd>OutlineFocusCode<CR><Cmd>b#<CR>',
  { noremap = true, silent = true, desc = "Go to previously edited buffer" })
vim.keymap.set('n', '<Leader>,', '<Cmd>OutlineFocusCode<CR><Cmd>b#<CR>',
  { noremap = true, silent = true, desc = "Go to previously edited buffer" })
vim.keymap.set({ 'i', 'n' }, '<C-s>', '<Cmd>wa<CR>', { noremap = true, silent = true, desc = "Write modified buffers" })
vim.keymap.set('n', '<Leader>eQ', '<Cmd>qa!<CR>',
  { noremap = true, silent = true, desc = "Discard unsaved changes and exit" })
vim.keymap.set('n', '<C-d><C-d>', '<Cmd>qa!<CR>',
  { noremap = true, silent = true, desc = "Discard unsaved changes and exit" })
vim.keymap.set('n', '<Leader>eq', '<Cmd>wqa<CR>',
  { noremap = true, silent = true, desc = "Write modified buffers and exit" })
vim.keymap.set('n', '<C-c><C-c>', '<Cmd>wqa<CR>',
  { noremap = true, silent = true, desc = "Write modified buffers and exit" })
vim.keymap.set('n', '<Leader>md', '<Cmd>delmarks!<CR>', { silent = true, desc = "Delete local marks" })
vim.keymap.set('n', '<Leader>mD', '<Cmd>delmarks!<Bar>delmarks A-Z0-9<CR>',
  { silent = true, desc = "Delete global and local marks" })
vim.keymap.set('n', '<Leader>fn', function()
  local path = vim.fn.expand('%:p')
  vim.fn.setreg('+', path)
  vim.notify("File path copied to clipboard: " .. path)
end, { noremap = true, silent = true, desc = "Copy file path to clipboard" })
vim.keymap.set('c', '<C-w>', function()
  return vim.fn.expand('<cword>')
end, { expr = true, noremap = true, desc = "Insert the word under the cursor into the command prompt" })

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
vim.keymap.set('n', '<Leader>nt', function()
  is_numbered = not is_numbered
  set_numbered()
end, { noremap = true, silent = true, desc = "Toggle line numbering" })
vim.keymap.set('n', '<Leader>nr', function()
  is_relative = not is_relative
  set_numbered()
end, { noremap = true, silent = true, desc = "Toggle relative line numbering" })
vim.keymap.set('n', '<Leader>fl', function()
  if vim.bo.modified then
    vim.cmd('write')
  end

  local file_path = vim.fn.expand('%:p') -- Get the full path of the current file
  M = assert(loadfile(file_path))()
  vim.notify("Module loaded into global variable 'M'", vim.log.levels.INFO)
end, { noremap = true, silent = true, desc = "Load current module file into variable 'M'" })

vim.keymap.set({ 'i', 'n' }, '<C-M-l>', function()
  local md_link = Utils.convert_clipboard_url_to_markdown_link()
  if md_link ~= '' then
    vim.fn.setreg('+', md_link)
    vim.fn.setreg('"', md_link)
    if vim.fn.mode() == 'i' then
      Utils.feed_keys('<C-o>p', 'i')
    else
      vim.cmd('normal! p')
    end
  end
end, { noremap = true, silent = true, desc = "Convert URL on the clipboard to a Markdown link" })

vim.keymap.set('n', '<Leader>fR', function()
  local current_name = vim.fn.expand('%:t') -- current file name with extension
  local old_ext = vim.fn.expand('%:e')      -- current file extension (without dot)
  local input = vim.fn.input('New filename: ', current_name)
  if input ~= '' then
    -- If input has no extension, append old extension
    if not input:match('%.') and old_ext ~= '' then
      input = input .. '.' .. old_ext
    end
    Utils.rename_current_file(input)
  end
end, { noremap = true, silent = true, desc = "Rename current file" })

local function toggle_case_sensitivity()
  -- Use the raw Nvim API to get the value, which avoids the vim.opt.smartcase:get() warning
  local smartcase_enabled = vim.api.nvim_get_option_value("smartcase", {})
  if smartcase_enabled then
    vim.opt.smartcase = false
    vim.opt.ignorecase = false
    vim.notify("Search: Case Sensitive")
  else
    -- This combination enables the "smartcase" behavior.
    vim.opt.smartcase = true
    vim.opt.ignorecase = true
    vim.notify("Search: Smart Case")
  end
end
vim.keymap.set('n', '<Leader>fc', toggle_case_sensitivity,
  { desc = 'Toggle search case sensitivity (smartcase ↔ case sensitive)' })

-- Insert mode motion commands
vim.keymap.set('i', '<C-h>', '<C-o>h',
  { noremap = true, silent = true, desc = "Move cursor left one character (insert mode)" })
vim.keymap.set('i', '<C-l>', '<C-o>l',
  { noremap = true, silent = true, desc = "Move cursor right one character (insert mode)" })
vim.keymap.set('i', '<C-x>', '<C-o>x',
  { noremap = true, silent = true, desc = "Delete the character under cursor (insert mode)" })

-- Preview Markdown files in the browser with the Chrome Markdown Viewer extension
-- https://chromewebstore.google.com/detail/markdown-viewer/ckkdlimhmcjmikdlpkmbgfkaikojcbjk
vim.keymap.set('n', ',mp', function()
  -- Open current file in browser, suppressing all output
  os.execute('brave "' .. vim.fn.expand('%:p') .. '" > /dev/null 2>&1 &')
end, { desc = 'Open current file in Brave browser' })

-- Clipboard copy and paste commands
vim.keymap.set({ 'n', 'v' }, '<Leader>cc', '"+y', { noremap = true, silent = true, desc = "Copy to clipboard" })
vim.keymap.set({ 'n', 'v' }, 'Y', '"+y', { noremap = true, silent = true, desc = "Copy to clipboard" })
vim.keymap.set('n', '<Leader>cl', '"+yy', { noremap = true, silent = true, desc = "Copy line to clipboard" })
vim.keymap.set('n', 'YY', '"+yy', { noremap = true, silent = true, desc = "Copy line to clipboard" })

vim.keymap.set('v', '<Leader>ca', [[:<C-u>let @+ = @+ . join(getline("'<", "'>"), "\n") . "\n"<CR>]],
  { noremap = true, silent = true, desc = "Append selection to clipboard" })
vim.keymap.set('n', '<Leader>ca', [[:let @+ = @+ . getline(".") . "\n"<CR>]],
  { noremap = true, silent = true, desc = "Append line to clipboard" })

vim.keymap.set({ 'n', 'v' }, '<M-v>', '"+p', { noremap = true, silent = true, desc = "Paste clipboard after cursor" })
vim.keymap.set({ 'n', 'v' }, '<Leader>v', '"+p', { noremap = true, silent = true, desc = "Paste clipboard after cursor" })
vim.keymap.set('n', '<Leader>V', '"+P', { noremap = true, silent = true, desc = "Paste clipboard before cursor" })

-- Edit commands
vim.keymap.set('v', '<Leader>ed', [[:s/^\s*$\n//<CR>:nohlsearch<CR>]],
  { noremap = true, silent = true, desc = "Delete blank lines from selection" })
vim.keymap.set('v', '<Leader>eD', [[:s/\n\{1,}/\r\r/<CR>]],
  { noremap = true, silent = true, desc = "Separate lines in selection with single blank lines" })
vim.keymap.set('n', '<Leader>et', '<Cmd>%s/\\s\\+$//e<CR>',
  { noremap = true, silent = true, desc = "Trim spaces from the ends of lines" })

-- Help commands
vim.keymap.set('n', '<Leader>ht', Utils.toggle_help_window, { desc = "Toggle help window" })
vim.keymap.set({ 'n', 'v' }, '<Leader>hw', function()
  local query = Utils.get_selection_or_word()
  if query ~= '' then
    Utils.find_help(query)
  else
    vim.notify("No word or selection to search in help", vim.log.levels.ERROR)
  end
end, { desc = "Open help for word under cursor or selected text" })

-- Spelling commands
local spellfile_path = vim.api.nvim_get_option_value("spellfile", {})
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = spellfile_path,
  command = 'mkspell! ' .. spellfile_path, -- Automatically reloads in all buffers with spelling enabled
  desc = "Recompile the spelling word list file on save"
})

vim.keymap.set('n', '<Leader>sg', 'zg',
  { noremap = true, silent = true, desc = "Mark the spelling of the word under cursor as good" })
vim.keymap.set('n', '<Leader>sw', 'zw',
  { noremap = true, silent = true, desc = "Mark the spelling of the word under cursor as wrong" })
vim.keymap.set('n', '<Leader>ss', 'z=', { desc = "Correct misspelt word at cursor" })
vim.keymap.set('n', '<Leader>sn', execute_cmd_and_map_n(
    function() Utils.feed_keys(']sz=', 'n') end,
    function() Utils.feed_keys('[sz=', 'n') end
  ),
  { noremap = true, silent = true, desc = "Correct next misspelt word" })
vim.keymap.set('n', '<Leader>sp', execute_cmd_and_map_n(
    function() Utils.feed_keys('[sz=', 'n') end,
    function() Utils.feed_keys(']sz=', 'n') end
  ),
  { noremap = true, silent = true, desc = "Correct previous misspelt word" })
vim.keymap.set({ 'i', 'n' }, '<M-s>', '<Esc>[sz=',
  { noremap = true, silent = true, desc = "Correct previous misspelt word" })
vim.keymap.set('n', '<Leader>se', function()
  vim.cmd('edit ' .. spellfile_path)
end, { noremap = true, desc = "Edit spelling word list file" })
local function toggle_spell_checker()
  vim.wo.spell = not vim.wo.spell
  local status = vim.wo.spell and "enabled" or "disabled"
  vim.notify("Spell checking " .. status)
end
vim.keymap.set('n', '<Leader>st', toggle_spell_checker, { noremap = true, silent = true, desc = "Toggle spell checker" })

-- Buffer commands
vim.keymap.set('n', '<Leader>bd', '<Cmd>bd!<CR>',
  { noremap = true, silent = false, desc = "Discard current buffer" })
vim.api.nvim_set_keymap('n', '<Leader>bD', '<Cmd>%bd|e#|bd#<CR>',
  { noremap = true, silent = true, desc = "Discard all buffers except the current buffer" })

-- Windows commands
local function close_window()
  -- Close the current window. If the `close` command fails (it won't close the last window on a buffer) then,
  -- after checking the buffer hasn't been modified, close the window by deleting the buffer.
  local success = pcall(function() vim.cmd('close') end)
  if not success then
    local current_buf_id = vim.api.nvim_get_current_buf()
    local is_modified = vim.api.nvim_get_option_value('modified', { buf = current_buf_id })
    if is_modified then
      vim.notify("Cannot close window: buffer has unsaved changes", vim.log.levels.ERROR)
    else
      vim.cmd('bdelete')
    end
  end
end
vim.keymap.set('n', '<Leader>wc', close_window, { noremap = true, silent = false, desc = "Close window" })
vim.keymap.set('n', '<Leader>wo', '<C-w>o', { noremap = true, silent = true, desc = "Leave only this window open" })
vim.keymap.set('n', '<Leader>wm', '<C-w>_', { noremap = true, silent = true, desc = "Maximize window" })
vim.keymap.set('n', '<Leader>w=', '<C-w>=', { noremap = true, silent = true, desc = "Equalize window sizes" })
vim.keymap.set('n', '<Leader>wv', '<C-w>v', { noremap = true, silent = true, desc = "Split window vertically" })
vim.keymap.set('n', '<Leader>w|', '<C-w>v', { noremap = true, silent = true, desc = "Split window vertically" })
vim.keymap.set('n', '<Leader>wh', '<C-w>s', { noremap = true, silent = true, desc = "Split window horizontally" })
vim.keymap.set('n', '<Leader>w-', '<C-w>s', { noremap = true, silent = true, desc = "Split window horizontally" })

-- Window navigation with Ctrl + Arrow keys
vim.keymap.set('n', '<C-Up>', '<C-w>k', { noremap = true, silent = true })
vim.keymap.set('n', '<C-Down>', '<C-w>j', { noremap = true, silent = true })
vim.keymap.set('n', '<C-Left>', '<C-w>h', { noremap = true, silent = true })
vim.keymap.set('n', '<C-Right>', '<C-w>l', { noremap = true, silent = true })

-- Tab commands
vim.keymap.set('n', '<Leader>tn', '<Cmd>tab split<CR>',
  { noremap = true, silent = true, desc = "Open buffer in new tab" })
vim.keymap.set('n', '<Leader>tc', '<Cmd>tabclose<CR>', { noremap = true, silent = true, desc = "Close tab" })

-- Quickfix commands
vim.keymap.set('n', '<Leader>qc', '<Cmd>cclose<CR>', { noremap = true, silent = true, desc = "Close Quickfix window" })
vim.keymap.set('n', '<Leader>qo', '<Cmd>copen<CR>', { noremap = true, silent = true, desc = "Open Quickfix window" })
vim.keymap.set('n', '<Leader>qD', '<Cmd>cexpr []<CR>',
  { noremap = true, silent = true, desc = "Delete all items from quickfix list" })
vim.keymap.set('n', '<Leader>qa', Utils.add_current_location_to_quickfix,
  { noremap = true, silent = true, desc = "Append location to quickfix list" })
vim.keymap.set({ 'n', 'v' }, '<Leader>qw', function()
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
  -- Commands that only work inside the Quickfix list
  pattern = 'qf',
  callback = function()
    vim.keymap.set('n', '<Leader>qd', Utils.delete_current_entry_from_quickfix,
      { noremap = true, silent = true, desc = "Delete current item from quickfix list" })
  end,
})

-- Insert date
-- vim.keymap.set('i', '<M-;>', '<C-r>=strftime("%d-%b-%Y")<CR>', { noremap = true, silent = true, desc = "Insert date" })

-- Toggle word-wrap
vim.keymap.set('n', '<Leader>ww', function()
  vim.wo.wrap = not vim.wo.wrap
  vim.notify(vim.wo.wrap and "Word wrap enabled" or "Word wrap disabled")
end, { noremap = true, silent = true, desc = "Toggle window word wrap" })

-- Terminal execution commands
-- These commands save modified buffers and then execute CLI commands in the tmux terminal pane.
-- NOTE: These command should logically reside in tmux but, due to Neovim async behaviour,
-- modified files might not be saved prior to the execution of tmux terminal pane commands.

vim.keymap.set('n', '<leader>tx', function() Utils.send_keys_to_terminal('Up Enter') end,
  { noremap = true, silent = true, desc = "Execute last terminal command (pane 2)" })
vim.keymap.set({ 'i', 'n' }, '<M-S-r>', function() Utils.send_keys_to_terminal('Up Enter') end,
  { noremap = true, silent = true, desc = "Execute last terminal command (pane 2)" })

vim.keymap.set('n', '<leader>tr', function() Utils.send_keys_to_terminal('C-r', { focus_pane_id = 2 }) end,
  { noremap = true, silent = true, desc = "Open fzf command-line recall in the terminal (pane 2)" })
vim.keymap.set({ 'i', 'n' }, '<M-r>', function() Utils.send_keys_to_terminal('C-r', { focus_pane_id = 2 }) end,
  { noremap = true, silent = true, desc = "Open fzf command-line recall in the terminal (pane 2)" })

-- Abbreviations commands
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = vim.fn.stdpath("config") .. "/vim/init.vim",
  command = "abc | source <afile>",
  desc = "Source init.vim on save"
})

vim.keymap.set('n', '<Leader>al', function()
  vim.cmd('abc')
  vim.cmd('source ' .. vim.g.vim_init_file)
  vim.notify("Abbreviations loaded")
end, { expr = true, noremap = true, desc = "Load init.vim" })
vim.keymap.set('n', '<Leader>ae', function()
  vim.cmd('edit ' .. vim.g.vim_init_file)
end, { noremap = true, desc = "Edit init.vim" })
