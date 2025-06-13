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
map_next_prev(
  ']d', function() vim.diagnostic.goto_next({ float = false }) end,
  '[d', function() vim.diagnostic.goto_prev({ float = false }) end,
  "diagnostic message")
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
map_next_prev(']s', 'normal! ]s', '[s', 'normal! [s', "misspelt word")
map_next_prev('g,', 'normal! g,', 'g;', 'normal! g;', "change")
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
vim.keymap.set('n', '<Leader>eh', ':nohlsearch<CR>:echo<CR>', -- Turn of search highlighting and clear status line
  { silent = true, desc = "Turn highlighting off and clear status line" })
vim.keymap.set('n', 'U', '<C-r>', { noremap = true, silent = true, desc = "Redo last change" })
vim.keymap.set('i', '<C-^>', '<Esc>:b#<CR>', { noremap = true, silent = true, desc = "Go to previously edited buffer" })
vim.keymap.set('n', '\\', '<Esc>:b#<CR>', { noremap = true, silent = true, desc = "Go to previously edited buffer" })
vim.keymap.set('n', '<Leader>ew', ':wa<CR>', { noremap = true, silent = true, desc = "Write modified buffers" })
vim.keymap.set('n', '<M-w>', ':wa<CR>', { noremap = true, silent = true, desc = "Write modified buffers" })
vim.keymap.set('n', '<Leader>eq', ':qa!<CR>',
  { noremap = true, silent = true, desc = "Discard unsaved changes and exit" })
vim.keymap.set('n', '<M-q>', ':qa!<CR>', { noremap = true, silent = true, desc = "Discard unsaved changes and exit" })
vim.keymap.set('n', '<Leader>ex', ':wqa<CR>', { noremap = true, silent = true, desc = "Write modified buffers and exit" })
vim.keymap.set('n', '<M-x>', ':wqa<CR>', { noremap = true, silent = true, desc = "Write modified buffers and exit" })
vim.keymap.set('n', '<Leader>sa', 'ggVG', { noremap = true, silent = true, desc = "Select all text in current buffer" })
vim.keymap.set('n', '<M-a>', 'ggVG', { noremap = true, silent = true, desc = "Select all text in current buffer" })
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

vim.keymap.set({ 'i', 'n' }, '<C-l>', function()
  local md_link = Utils.convert_clipboard_url_to_markdown_link()
  if md_link ~= '' then
    vim.fn.setreg('+', md_link)
    vim.fn.setreg('"', md_link)
    if vim.fn.mode() == 'i' then
      local keys = vim.api.nvim_replace_termcodes("<C-o>p", true, false, true)
      vim.api.nvim_feedkeys(keys, "i", false)
    else
      vim.cmd('normal! p')
    end
  end
end, { noremap = true, silent = true, desc = "Convert URL on the clipboard to a Markdown link" })

-- Preview Markdown files in the browser with the Chrome Markdown Viewer extension
-- https://chromewebstore.google.com/detail/markdown-viewer/ckkdlimhmcjmikdlpkmbgfkaikojcbjk
vim.keymap.set('n', ',mp', function()
  -- Open current file in browser, suppressing all output
  os.execute('brave "' .. vim.fn.expand('%:p') .. '" > /dev/null 2>&1 &')
end, { desc = 'Open current file in Brave browser' })

-- Clipboard copy and paste commands
vim.keymap.set({ 'n', 'v' }, 'Y', '"+y', { noremap = true, silent = true, desc = "Yank to clipboard" })
vim.keymap.set('n', 'YY', '"+yy', { noremap = true, silent = true, desc = "Yank line to clipboard" })
vim.keymap.set({ 'i', 'c' }, '<M-p>', '<C-r>+', { noremap = true, silent = false, desc = "Paste clipboard after cursor" })
vim.keymap.set({ 'n', 'v' }, '<M-p>', '"+p', { noremap = true, silent = true, desc = "Paste clipboard after cursor" })
vim.keymap.set('n', '<M-P>', '"+P', { noremap = true, silent = true, desc = "Paste clipboard before cursor" })
vim.keymap.set({ 'n', 'i' }, '<C-M-p>', '<Esc>o<Esc>"+p',
  { noremap = true, silent = true, desc = "Paste clipboard line-wise" })

-- Edit commands
vim.keymap.set('v', '<Leader>ed', ':s/^\\s*$\\n//g<CR>',
  { noremap = true, silent = true, desc = "Delete blank lines in selection" })
vim.keymap.set('n', '<Leader>et', ':%s/\\s\\+$//e<CR>',
  { noremap = true, silent = true, desc = "Trim spaces from the ends of lines" })

-- Help commands
vim.keymap.set('n', '<Leader>ht', Utils.toggle_help_window, { desc = "Toggle help window" })
vim.keymap.set('n', '<C-M-h>', Utils.toggle_help_window, { desc = "Toggle help window" })

-- Open help for word or selection under cursor
vim.keymap.set({ 'n', 'v' }, '<Leader>hw', function()
  local query = Utils.get_selection_or_word()
  if query ~= '' then
    Utils.find_help(query)
  else
    vim.notify("No word or selection to search in help", vim.log.levels.ERROR)
  end
end, { desc = "Open help for word under cursor or selected text" })

-- Spelling commands
local spellfile_path = vim.fn.expand(vim.opt.spellfile:get()[1])
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = spellfile_path,
  command = 'mkspell! ' .. spellfile_path, -- Automatically reloads in all buffers with spelling enabled
  desc = "Recompile the spelling word list file on save"
})

vim.keymap.set({ 'i', 'n' }, '<C-s>', '<Esc>]sz=',
  { noremap = true, silent = true, desc = "Correct next misspelt word" })
vim.keymap.set({ 'i', 'n' }, '<C-M-s>', '<Esc>[sz=',
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
vim.keymap.set('n', '<M-s>', toggle_spell_checker, { noremap = true, silent = true, desc = "Toggle spell checker" })

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
vim.keymap.set('n', '<Leader>wd', ':bdelete!<CR>', { noremap = true, silent = false, desc = "Discard buffer" })
vim.keymap.set('n', '<M-d>', ':bdelete!<CR>', { noremap = true, silent = false, desc = "Discard buffer" })
vim.keymap.set('n', '<Leader>wc', close_window, { noremap = true, silent = false, desc = "Close window" })
vim.keymap.set('n', '<M-c>', close_window, { noremap = true, silent = false, desc = "Close window" })
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
    vim.keymap.set('n', 'dd', Utils.delete_current_entry_from_quickfix,
      { buffer = true, noremap = true, silent = true, desc = "Delete current item from quickfix list" })
  end,
})

-- Insert date
vim.keymap.set('i', '<M-d>', '<C-r>=strftime("%d-%b-%Y")<CR>', { noremap = true, silent = true, desc = "Insert date" })

-- Toggle word-wrap
vim.keymap.set('n', '<Leader>ww', function()
  vim.wo.wrap = not vim.wo.wrap
  vim.notify(vim.wo.wrap and "Word wrap enabled" or "Word wrap disabled")
end, { noremap = true, silent = true, desc = "Toggle word wrap" })

-- Terminal execution commands
-- These commands save modified buffers and then execute CLI commands in the tmux terminal pane.
-- NOTE: These command should logically reside in tmux but, due to Neovim async behaviour,
-- modified files might not be saved prior to the execution of tmux terminal pane commands.

vim.keymap.set('n', '<leader>xe', function() Utils.send_keys_to_terminal('Up Enter') end,
  { noremap = true, silent = true, desc = "Save and execute last terminal pane command" })
vim.keymap.set('n', '<M-e>', function() Utils.send_keys_to_terminal('Up Enter') end,
  { noremap = true, silent = true, desc = "Save and execute last terminal pane command" })

vim.keymap.set('n', '<leader>xg', function() Utils.send_keys_to_terminal('lazygit Enter', { focus_pane_id = 2 }) end,
  { noremap = true, silent = true, desc = "Save and execute lazygit in the terminal pane" })
vim.keymap.set('n', '<M-g>', function() Utils.send_keys_to_terminal('lazygit Enter', { focus_pane_id = 2 }) end,
  { noremap = true, silent = true, desc = "Save and execute lazygit in the terminal pane" })

vim.keymap.set('n', '<leader>xr', function() Utils.send_keys_to_terminal('C-r', { focus_pane_id = 2 }) end,
  { noremap = true, silent = true, desc = "Save and open command-line recall in the terminal pane" })
vim.keymap.set('n', '<M-r>', function() Utils.send_keys_to_terminal('C-r', { focus_pane_id = 2 }) end,
  { noremap = true, silent = true, desc = "Save and open command-line recall in the terminal pane" })

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
