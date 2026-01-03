Utils = require "utils" -- Load ./lua/utils.lua

-- Map custom next/previous navigation commands.
local execute_cmd_and_map_n = function(next_cmd, prev_cmd)
  return function()
    local n = type(next_cmd) == "string" and function()
      vim.cmd(next_cmd)
    end or next_cmd
    local p = type(prev_cmd) == "string" and function()
      vim.cmd(prev_cmd)
    end or prev_cmd
    vim.keymap.set("n", "n", n, { noremap = true, silent = true })
    vim.keymap.set("n", "N", p, { noremap = true, silent = true })
    n()
  end
end
local function map_next_prev(next_key, next_cmd, prev_key, prev_cmd, desc)
  vim.keymap.set(
    { "n", "v" },
    next_key,
    execute_cmd_and_map_n(next_cmd, prev_cmd),
    { noremap = true, silent = true, desc = "Go to next " .. desc }
  )
  vim.keymap.set(
    { "n", "v" },
    prev_key,
    execute_cmd_and_map_n(prev_cmd, next_cmd),
    { noremap = true, silent = true, desc = "Go to previous " .. desc }
  )
end

-- Restore native n and N commands prior to the execution of search commands `/`, `*` and `#`.
local restore_next_prev = function()
  vim.keymap.set("n", "n", "n", { noremap = true, silent = true })
  vim.keymap.set("n", "N", "N", { noremap = true, silent = true })
end
vim.api.nvim_create_autocmd("CmdlineEnter", {
  pattern = { "/", "\\?" },
  callback = restore_next_prev,
})
vim.keymap.set("n", "*", function()
  restore_next_prev()
  return "*"
end, { expr = true })
vim.keymap.set("n", "#", function()
  restore_next_prev()
  return "#"
end, { expr = true })

-- Install custom next/previous commands.
map_next_prev(
  "<Leader>dn",
  function()
    vim.diagnostic.jump { count = 1, float = false }
  end,
  "<Leader>dp",
  function()
    vim.diagnostic.jump { count = -1, float = false }
  end,
  "diagnostic message"
)
map_next_prev("<Leader>gn", "Gitsigns next_hunk", "<Leader>gp", "Gitsigns prev_hunk", "Git hunk")
map_next_prev(
  "<Leader>qn",
  function()
    pcall(function()
      vim.cmd "cnext"
    end)
  end,
  "<Leader>qp",
  function()
    pcall(function()
      vim.cmd "cprev"
    end)
  end,
  "Quickfix"
)
map_next_prev("<Leader>wn", "wincmd w", "<Leader>wp", "wincmd W", "window")
map_next_prev("<Leader>sn", "normal! ]s", "<Leader>sp", "normal! [s", "misspelt word")
map_next_prev("g,", "normal! g,", "g;", "normal! g;", "change") -- Adds n/N functionality to `g,` and `g;` commands

-- Adds n/N functionality to Markdown section navigation commands
-- Builtin markdown section navigation commands have first to be explicitly deleted from the current buffer.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    pcall(vim.keymap.del, "n", "]]", { buffer = 0 })
    pcall(vim.keymap.del, "n", "[[", { buffer = 0 })
    map_next_prev(
      "<Leader>mn",
      function()
        vim.fn.search("^#\\{1,5}\\s\\+\\S", "W")
      end,
      "<Leader>mp",
      function()
        vim.fn.search("^#\\{1,5}\\s\\+\\S", "Wb")
      end,
      "markdown section"
    )
    map_next_prev(
      "]]",
      function()
        vim.fn.search("^#\\{1,5}\\s\\+\\S", "W")
      end,
      "[[",
      function()
        vim.fn.search("^#\\{1,5}\\s\\+\\S", "Wb")
      end,
      "markdown section"
    )
  end,
})

-- Miscellaneous commands
vim.keymap.set(
  "n",
  "<Leader>eh",
  "<Cmd>nohlsearch<CR><Cmd>echo<CR>", -- Turn off search highlighting and clear status line
  { silent = true, desc = "Turn highlighting off and clear status line" }
)
vim.keymap.set("n", "U", "<C-r>", { noremap = true, silent = true, desc = "Redo last change" })
vim.keymap.set(
  "n",
  "<Leader>,",
  "<Cmd>OutlineFocusCode<CR><Cmd>b#<CR>",
  { noremap = true, silent = true, desc = "Go to previously edited buffer" }
)
vim.keymap.set("n", "<Leader>ew", "<Cmd>wa<CR>", { noremap = true, silent = true, desc = "Write modified buffers" })
vim.keymap.set({ "i", "n" }, "<C-s>", "<Cmd>wa<CR>", { noremap = true, silent = true, desc = "Write modified buffers" })
vim.keymap.set("n", "<Leader>eQ", "<Cmd>qa!<CR>", { noremap = true, silent = true, desc = "Discard unsaved changes and exit" })
vim.keymap.set("n", "<Leader>eq", "<Cmd>wqa<CR>", { noremap = true, silent = true, desc = "Write modified buffers and exit" })
vim.keymap.set("n", "<Leader>md", "<Cmd>delmarks!<CR>", { silent = true, desc = "Delete local marks" })
vim.keymap.set("n", "<Leader>mD", "<Cmd>delmarks!<Bar>delmarks A-Z0-9<CR>", { silent = true, desc = "Delete global and local marks" })
vim.keymap.set("n", "<Leader>fn", function()
  local path = vim.fn.expand "%:p"
  vim.fn.setreg("+", path)
  vim.notify("File path copied to clipboard: " .. path)
end, { noremap = true, silent = true, desc = "Copy file path to clipboard" })
vim.keymap.set("c", "<C-w>", function()
  return vim.fn.expand "<cword>"
end, { expr = true, noremap = true, desc = "Insert the word under the cursor into the command prompt" })

local is_numbered = false -- Show line numbers
local is_relative = true -- Use relative line numbers
local function set_numbered()
  if is_numbered then
    vim.wo.relativenumber = is_relative
    vim.wo.number = not is_relative
    vim.notify((is_relative and "Relative" or "Absolute") .. " line numbering enabled")
  else
    vim.wo.relativenumber = false
    vim.wo.number = false
    vim.notify "Line numbering disabled"
  end
end
vim.keymap.set("n", "<Leader>lt", function()
  is_numbered = not is_numbered
  set_numbered()
end, { noremap = true, silent = true, desc = "Toggle line numbering" })
vim.keymap.set("n", "<Leader>lr", function()
  is_relative = not is_relative
  set_numbered()
end, { noremap = true, silent = true, desc = "Toggle relative line numbering" })
vim.keymap.set("n", "<Leader>fl", function()
  if vim.bo.modified then
    vim.cmd "write"
  end

  local file_path = vim.fn.expand "%:p" -- Get the full path of the current file
  M = assert(loadfile(file_path))()
  vim.notify("Module loaded into global variable 'M'", vim.log.levels.INFO)
end, { noremap = true, silent = true, desc = "Load current module file into variable 'M'" })

vim.keymap.set({ "i", "n" }, "<C-M-l>", function()
  local md_link = Utils.convert_clipboard_url_to_markdown_link()
  if md_link ~= "" then
    vim.fn.setreg("+", md_link)
    vim.fn.setreg('"', md_link)
    if vim.fn.mode() == "i" then
      Utils.feed_keys("<C-o>p", "i")
    else
      vim.cmd "normal! p"
    end
  end
end, { noremap = true, silent = true, desc = "Convert URL on the clipboard to a Markdown link" })

vim.keymap.set("n", "<Leader>fR", function()
  local current_name = vim.fn.expand "%:t" -- current file name with extension
  local old_ext = vim.fn.expand "%:e" -- current file extension (without dot)
  local input = vim.fn.input("New filename: ", current_name)
  if input ~= "" then
    -- If input has no extension, append old extension
    if not input:match "%." and old_ext ~= "" then
      input = input .. "." .. old_ext
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
    vim.notify("Search: Case Sensitive", vim.log.levels.INFO)
  else
    -- This combination enables the "smartcase" behavior.
    vim.opt.smartcase = true
    vim.opt.ignorecase = true
    vim.notify("Search: Smart Case", vim.log.levels.INFO)
  end
end
vim.keymap.set("n", "<Leader>fc", toggle_case_sensitivity, { desc = "Toggle search case sensitivity (smartcase ↔ case sensitive)" })

-- Formatter commands

-- DEPRECATED: 23-Dec-2025: Auto-format files on save
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = "*",
--   callback = function()
--     -- Ignore errors for file types without formatters
--     pcall(function()
--       vim.lsp.buf.format { async = false }
--     end)
--   end,
-- })

vim.keymap.set("n", "<Leader>cf", function()
  vim.lsp.buf.format { async = true }
end, { desc = "Format buffer" })

-- Use StyLua to format Lua files
local function format_with_stylua()
  -- Check if current buffer filetype is lua
  local filetype = vim.bo.filetype
  if filetype ~= "lua" then
    vim.notify("Stylua only formats Lua files", vim.log.levels.WARN)
    return
  end
  vim.cmd "update"
  local source_file = vim.api.nvim_buf_get_name(0)
  if source_file == "" then
    vim.notify("No file in current buffer", vim.log.levels.WARN)
    return
  end
  -- Save the current buffer then run the stylua command on the buffer file using the global configuration file.
  local config_file = vim.fn.stdpath "config" .. "/stylua.toml"
  local cmd = string.format('stylua --config-path "%s" "%s"', config_file, source_file)
  local result = vim.fn.system(cmd)
  if vim.v.shell_error == 0 then
    -- Reload the buffer to reflect changes
    vim.cmd "edit!"
    vim.notify("Stylua formatting applied", vim.log.levels.INFO)
  else
    vim.notify("Stylua failed: " .. result, vim.log.levels.ERROR)
  end
end
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    vim.keymap.set(
      "n",
      "<leader>cf",
      format_with_stylua,
      { buffer = true, noremap = true, silent = true, desc = "Format Lua file with StyLua" }
    )
  end,
})

-- Insert mode motion commands
vim.keymap.set("i", "<C-h>", "<C-o>h", { noremap = true, silent = true, desc = "Move cursor left one character (insert mode)" })
vim.keymap.set("i", "<C-l>", "<C-o>l", { noremap = true, silent = true, desc = "Move cursor right one character (insert mode)" })
vim.keymap.set("i", "<C-x>", "<C-o>x", { noremap = true, silent = true, desc = "Delete the character under cursor (insert mode)" })

-- Preview Markdown files in the browser with the Chrome Markdown Viewer extension
-- https://chromewebstore.google.com/detail/markdown-viewer/ckkdlimhmcjmikdlpkmbgfkaikojcbjk
vim.keymap.set("n", "<Leader>mv", function()
  -- Open current file in browser, suppressing all output
  os.execute('brave "' .. vim.fn.expand "%:p" .. '" > /dev/null 2>&1 &')
end, { desc = "View current file in Brave browser" })

-- Clipboard copy and paste commands
vim.keymap.set({ "n", "v" }, "Y", '"+y', { noremap = true, silent = true, desc = "Yank to clipboard" })
vim.keymap.set("n", "YY", '"+yy', { noremap = true, silent = true, desc = "Yank line to clipboard" })

vim.keymap.set(
  "n",
  "<Leader>ya",
  [[:let @+ = @+ . getline(".") . "\n"<CR>]],
  { noremap = true, silent = true, desc = "Append line to clipboard" }
)
vim.keymap.set(
  "v",
  "<Leader>ya",
  [[:<C-u>let @+ = @+ . join(getline("'<", "'>"), "\n") . "\n"<CR>]],
  { noremap = true, silent = true, desc = "Append selection to clipboard" }
)

vim.keymap.set({ "n", "v" }, "<Leader>p", '"+p', { noremap = true, silent = true, desc = "Paste clipboard after cursor" })
vim.keymap.set({ "n", "v" }, "<C-p>", '"+p', { noremap = true, silent = true, desc = "Paste clipboard after cursor" })
vim.keymap.set({ "n", "v" }, "<Leader>P", '"+P', { noremap = true, silent = true, desc = "Paste clipboard before cursor" })
vim.keymap.set({ "n", "v" }, "<C-M-p>", '"+P', { noremap = true, silent = true, desc = "Paste clipboard before cursor" })
vim.keymap.set("i", "<C-p>", "<C-R>+", { noremap = true, silent = true, desc = "Paste clipboard" })

-- Edit commands
vim.keymap.set(
  "v",
  "<Leader>ed",
  [[:s/^\s*$\n//<CR>:nohlsearch<CR>]],
  { noremap = true, silent = true, desc = "Delete blank lines from selection" }
)
vim.keymap.set(
  "v",
  "<Leader>eD",
  [[:s/\n\{1,}/\r\r/<CR>]],
  { noremap = true, silent = true, desc = "Separate lines in selection with single blank lines" }
)
vim.keymap.set("n", "<Leader>et", "<Cmd>%s/\\s\\+$//e<CR>", { noremap = true, silent = true, desc = "Trim spaces from the ends of lines" })

-- Help commands
vim.keymap.set("n", "<Leader>ht", Utils.toggle_help_window, { desc = "Toggle help window" })
vim.keymap.set({ "n", "v" }, "<Leader>hw", function()
  local query = Utils.get_selection_or_word()
  if query ~= "" then
    Utils.find_help(query)
  else
    vim.notify("No word or selection to search in help", vim.log.levels.ERROR)
  end
end, { desc = "Open help for word under cursor or selected text" })

-- Spelling commands
local spellfile_path = vim.api.nvim_get_option_value("spellfile", {})
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = spellfile_path,
  command = "mkspell! " .. spellfile_path, -- Automatically reloads in all buffers with spelling enabled
  desc = "Recompile the spelling word list file on save",
})

vim.keymap.set("n", "<Leader>sg", "zg", { noremap = true, silent = true, desc = "Mark the spelling of the word under cursor as good" })
vim.keymap.set("n", "<Leader>sw", "zw", { noremap = true, silent = true, desc = "Mark the spelling of the word under cursor as wrong" })
vim.keymap.set("n", "<Leader>ss", "z=", { desc = "Correct misspelt word at cursor" })
vim.keymap.set(
  "n",
  "<Leader>sN",
  execute_cmd_and_map_n(function()
    Utils.feed_keys("]sz=", "n")
  end, function()
    Utils.feed_keys("[sz=", "n")
  end),
  { noremap = true, silent = true, desc = "Correct next misspelt word" }
)
vim.keymap.set(
  "n",
  "<Leader>sP",
  execute_cmd_and_map_n(function()
    Utils.feed_keys("[sz=", "n")
  end, function()
    Utils.feed_keys("]sz=", "n")
  end),
  { noremap = true, silent = true, desc = "Correct previous misspelt word" }
)
vim.keymap.set({ "i", "n" }, "<M-s>", "<Esc>[sz=", { noremap = true, silent = true, desc = "Correct previous misspelt word" })
vim.keymap.set("n", "<Leader>se", function()
  vim.cmd("edit " .. spellfile_path)
end, { noremap = true, desc = "Edit spelling word list file" })
local function toggle_spell_checker()
  vim.wo.spell = not vim.wo.spell
  local status = vim.wo.spell and "enabled" or "disabled"
  vim.notify("Spell checking " .. status)
end
vim.keymap.set("n", "<Leader>st", toggle_spell_checker, { noremap = true, silent = true, desc = "Toggle spell checker" })

-- Buffer commands
vim.keymap.set("n", "<Leader>bd", "<Cmd>bd!<CR>", { noremap = true, silent = false, desc = "Discard current buffer" })
vim.api.nvim_set_keymap(
  "n",
  "<Leader>bD",
  "<Cmd>%bd|e#|bd#<CR>",
  { noremap = true, silent = true, desc = "Discard all buffers except the current buffer" }
)
vim.keymap.set("n", "<Leader>fD", function()
  local file = vim.api.nvim_buf_get_name(0)
  vim.api.nvim_buf_delete(0, { force = true })
  os.remove(file)
end, { noremap = true, silent = true, desc = "Discard the current buffer and delete the underlying file" })
local function sanitize_buffer()
  local cmds = {
    [[%s/\%u00A0/ /ge]], -- NBSP → space
    [[%s/\%u200B\|\%u200C\|\%u200D//ge]], -- zero-width chars
    [[%s/[“”]/"/ge]], -- smart double quotes
    [[%s/[‘’]/'/ge]], -- smart single quotes
    [[%s/[‐-–]/-/ge]], -- unicode dashes excluding the em dash
    [[%s/^\[\d\+\]([^)]\+)\r\?$//ge]], -- deletes entire lines matching the Markdown reference definitions [number](URL)
    [[%s/\[\d\+\]//ge]], -- delete Markdown reference links
  }
  for _, cmd in ipairs(cmds) do
    vim.cmd(cmd)
  end
end
vim.keymap.set(
  "n",
  "<Leader>bs",
  sanitize_buffer,
  { noremap = true, silent = false, desc = "Replace/delete Unicode characters and Markdown references in the current buffer" }
)

-- Windows commands
local function close_window()
  -- Close the current window. If the `close` command fails (it won't close the last window on a buffer) then,
  -- after checking the buffer hasn't been modified, close the window by deleting the buffer.
  local success = pcall(function()
    vim.cmd "close"
  end)
  if not success then
    local current_buf_id = vim.api.nvim_get_current_buf()
    local is_modified = vim.api.nvim_get_option_value("modified", { buf = current_buf_id })
    if is_modified then
      vim.notify("Cannot close window: buffer has unsaved changes", vim.log.levels.ERROR)
    else
      vim.cmd "bdelete"
    end
  end
end
vim.keymap.set("n", "<Leader>wc", close_window, { noremap = true, silent = false, desc = "Close window" })
vim.keymap.set("n", "<M-w>", close_window, { noremap = true, silent = false, desc = "Close window" })
vim.keymap.set("n", "<Leader>wo", "<C-w>o", { noremap = true, silent = true, desc = "Leave only this window open" })
vim.keymap.set("n", "<Leader>we", "<C-w>=", { noremap = true, silent = true, desc = "Equalize window sizes" })
vim.keymap.set("n", "<Leader>ws", "<C-w>v", { noremap = true, silent = true, desc = "Split horizontally (left/right)" })
vim.keymap.set("n", "<Leader>wv", "<C-w>s", { noremap = true, silent = true, desc = "Split vertically (top/bottom)" })
vim.keymap.set("n", "<Leader>w>", "<C-w>>", { noremap = true, silent = true, desc = "Increase window width" })
vim.keymap.set("n", "<Leader>w<", "<C-w><", { noremap = true, silent = true, desc = "Decrease window width" })
vim.keymap.set("n", "<Leader>w+", "<C-w>+", { noremap = true, silent = true, desc = "Increase window height" })
vim.keymap.set("n", "<Leader>w-", "<C-w>-", { noremap = true, silent = true, desc = "Decrease window height" })

local win_height_maximized = false
local win_height_saved = 0

local function toggle_maximize_height()
  local win = vim.api.nvim_get_current_win()
  if not win_height_maximized then
    -- Save current window height
    win_height_saved = vim.fn.winheight(win)
    -- Maximize window height
    vim.cmd "horizontal resize +999"
    win_height_maximized = true
  else
    -- Restore saved height
    vim.cmd("resize " .. win_height_saved)
    win_height_maximized = false
  end
end
vim.keymap.set("n", "<leader>wm", toggle_maximize_height, { noremap = true, silent = true, desc = "Toggle window maximum height" })

local win_width_maximized = false
local win_width_saved = 0

local function toggle_maximize_width()
  local win = vim.api.nvim_get_current_win()
  if not win_width_maximized then
    -- Save current window width
    win_width_saved = vim.fn.winwidth(win)
    -- Maximize window width
    vim.cmd "vertical resize +999"
    win_width_maximized = true
  else
    -- Restore saved width
    vim.cmd("vertical resize " .. win_width_saved)
    win_width_maximized = false
  end
end
vim.keymap.set("n", "<leader>wM", toggle_maximize_width, { noremap = true, silent = true, desc = "Toggle window maximum width" })

vim.keymap.set("n", "<Leader>ww", function()
  vim.wo.wrap = not vim.wo.wrap
  vim.notify(vim.wo.wrap and "Word wrap enabled" or "Word wrap disabled")
end, { noremap = true, silent = true, desc = "Toggle window word wrap" })

-- Function to toggle window orientation
local function toggle_window_orientation()
  -- Get the current window layout
  local layout = vim.fn.winlayout()
  -- Check if it's a horizontal split (row) or vertical split (col)
  if layout[1] == "row" then
    -- Change to vertical (stacked) layout
    vim.cmd "wincmd K"
  elseif layout[1] == "col" then
    -- Change to horizontal (side-by-side) layout
    vim.cmd "wincmd H"
  end
end

vim.keymap.set(
  "n",
  "<Leader>wl",
  toggle_window_orientation,
  { noremap = true, silent = true, desc = "Toggle window horizontal and vertical layout" }
)
vim.keymap.set("n", "<leader>wr", "<C-w>r", { noremap = true, silent = true, desc = "Rotate windows" })

-- Terminal commands
vim.keymap.set("n", "<Leader>to", "<Cmd>terminal<CR>i", { noremap = true, silent = true, desc = "Open a new terminal buffer" })
vim.keymap.set("t", "<C-n>", "<C-\\><C-n>", { noremap = true, silent = true, desc = "Switch from terminal mode to insert mode" })

-- Quickfix commands
vim.keymap.set("n", "<Leader>qc", "<Cmd>cclose<CR>", { noremap = true, silent = true, desc = "Close Quickfix window" })
vim.keymap.set("n", "<Leader>qo", "<Cmd>copen<CR>", { noremap = true, silent = true, desc = "Open Quickfix window" })
vim.keymap.set("n", "<Leader>dq", vim.diagnostic.setqflist, { desc = "Copy buffer diagnostics to the quickfix list" })
vim.keymap.set("n", "<Leader>qD", "<Cmd>cexpr []<CR>", { noremap = true, silent = true, desc = "Delete all items from quickfix list" })
vim.keymap.set(
  "n",
  "<Leader>qa",
  Utils.add_current_location_to_quickfix,
  { noremap = true, silent = true, desc = "Append location to quickfix list" }
)
vim.keymap.set({ "n", "v" }, "<Leader>qw", function()
  local visual_mode = Utils.is_visual_mode()
  local query = Utils.get_selection_or_word()
  if query ~= "" then
    query = Utils.escape_regexp(query)
    if not visual_mode then
      query = "\\<" .. query .. "\\>" -- Search for whole word
    end
    vim.cmd("vimgrep /" .. query .. "/ % | copen")
  else
    vim.notify("No word or selection at cursor", vim.log.levels.ERROR)
  end
end, {
  noremap = true,
  silent = true,
  desc = "Open quickfix list with current buffer locations matching the word or selection under the cursor",
})
vim.api.nvim_create_autocmd("FileType", {
  -- Commands that only work inside the Quickfix list
  pattern = "qf",
  callback = function()
    vim.keymap.set(
      "n",
      "<Leader>qd",
      Utils.delete_current_entry_from_quickfix,
      { noremap = true, silent = true, desc = "Delete current item from quickfix list" }
    )
  end,
})

-- Selection commands
vim.keymap.set("n", "<Leader>sa", "ggVG", { noremap = true, silent = true, desc = "Select buffer" })
vim.keymap.set("n", "<Leader>sf", "?^```<CR>jV/^```<CR>k", { noremap = true, silent = true, desc = "Select fenced block" })

-- Additional miscellaneous commands
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = vim.fn.stdpath "config" .. "/vim/init.vim",
  command = "abc | source <afile>",
  desc = "Source init.vim on save",
})

vim.keymap.set("n", "<Leader>ea", function()
  vim.cmd("edit " .. vim.g.vim_init_file)
end, { noremap = true, desc = "Edit init.vim" })

vim.keymap.set("n", "<C-j>", "<C-e>j", { silent = true, desc = "Scroll down one line" })
vim.keymap.set("n", "<C-k>", "<C-y>k", { silent = true, desc = "Scroll up one line" })
