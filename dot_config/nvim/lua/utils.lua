--- Module initialisation
local M = {}

--- Checks if the current Vim mode is Visual ('v' or 'V').
--- @return boolean true if in visual mode, false otherwise.
function M.is_visual_mode()
  return vim.fn.mode() == 'v' or vim.fn.mode() == 'V'
end

--- Escapes Vim special regular expression characters plus the `/` character.
--- @param s string The string to escape.
--- @return string The escaped string.
function M.escape_regexp(s)
  return vim.fn.escape(s, '\\/.*$^~[]')
end

--- Adds a local path to Lua's `package.path` for `require`.
--- Allows requiring Lua modules located in the specified directory.
--- @param path string The directory path to prepend to `package.path`.
function M.add_to_path(path)
  -- vim.opt.runtimepath:prepend(path) -- THIS DOESN'T SEEM NECESSARY
  package.path = path .. '/?.lua;' .. path .. '/?/init.lua;' .. package.path
end

--- Reloads all modified buffers from disk.
--- This discards any unsaved changes in those buffers, restoring them
--- to their last saved state. Notifies the user about reloaded files.
function M.reload_modified_buffers()
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
    vim.notify(table.concat(msgs, '\n'))
  end
end

--- Move the cursor with relative row and column numbers.
--- For example `move_cursor(-1, 0)` moves the cursor up one row.
--- Ignore cursor out of bounds errors.
function M.move_cursor(row_delta, col_delta)
  local pos = vim.api.nvim_win_get_cursor(0)
  local new_row = pos[1] + row_delta
  local new_col = pos[2] + col_delta
  pcall(function()
    vim.api.nvim_win_set_cursor(0, { new_row, new_col })
  end)
end

--- Gets the text currently selected in Visual mode.
--- Temporarily yanks the selection to the default register, retrieves it,
--- and then restores the original register content and visual selection state.
--- @return string The visually selected text.
function M.get_visual_selection()
  -- Save the current register content and mode
  local original_register = vim.fn.getreg('"')
  local original_mode = vim.fn.mode()

  -- Yank the selected text into the default register
  vim.cmd('noau normal! "vy')

  -- Retrieve the yanked text from the default register
  local selection = vim.fn.getreg('"')

  -- Restore the original register content
  vim.fn.setreg('"', original_register)

  -- Restore visual mode if it was active
  if original_mode:match('[vV]') then
    vim.cmd('normal! gv')
  end

  return selection
end

--- Gets the current visual selection or the word under the cursor.
--- If in Visual mode (v or V), returns the selection using `M.get_visual_selection`.
--- If in Normal mode (n), returns the word under the cursor (`<cword>`).
--- Returns an empty string in other modes or if `M.get_visual_selection` fails.
--- @return string The selected text or the word under the cursor.
function M.get_selection_or_word()
  local mode = vim.fn.mode()
  local result = ''
  if mode == 'n' then
    result = vim.fn.expand('<cword>')
  elseif mode == 'v' or mode == 'V' then
    result = M.get_visual_selection()
  end
  return result
end

--- Searches for and opens Vim help for a given query.
--- Executes `:help query`. If the command fails (e.g., help topic not found),
--- it shows an error notification.
--- @param query string The help topic to search for.
function M.find_help(query)
  -- Attempt to execute the command with pcall
  local success, _ = pcall(function()
    vim.cmd('help ' .. query)
  end)
  if not success then
    vim.notify("Failed to open help for: " .. query, vim.log.levels.ERROR)
  end
end

--- Toggles the Vim help window.
--- If a help window (`'filetype' == 'help'`) is open, it closes it,
--- remembering the buffer. If no help window is open, it reopens the
--- previously closed help buffer in a split, or opens the default
--- help page (`:help`) if no help buffer was previously remembered.
function M.toggle_help_window()
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
end

--- Adds the current cursor location to the quickfix list.
--- Captures the current filename, line number, column number, and line text
--- and appends it as a new entry to the quickfix list.
function M.add_current_location_to_quickfix()
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

--- Deletes the quickfix entry corresponding to the current cursor line in the quickfix window.
--- Removes the item from the quickfix list and updates the list.
--- Attempts to keep the cursor on the same line number or moves it to the
--- preceding item if the last item was deleted. Opens the quickfix window.
function M.delete_current_entry_from_quickfix()
  local ol = vim.fn.line('.')
  local qf = vim.fn.getqflist()
  local ls = #qf
  if ol > 0 and ol <= ls then
    table.remove(qf, ol)
    vim.fn.setqflist(qf, 'r')
    local nls = #qf
    if nls > 0 then
      local tl = math.min(ol, nls)
      vim.cmd('cwindow')
      pcall(vim.api.nvim_win_set_cursor, 0, { tl, 0 })
    else
      vim.cmd('cwindow')
    end
  end
end

--- Prepends an indentation string to each line in a table of strings.
--- Modifies the input table `lines` in place.
--- @param lines table An array of strings representing lines of text.
--- @param indent string The string to prepend to each line.
function M.indent_lines(lines, indent)
  for i, line in ipairs(lines) do
    lines[i] = indent .. line
  end
end

--- Wraps a string `s` at a specified column width.
--- Respects word boundaries. Multiple whitespace characters are collapsed
--- into a single space between words. Effectively trims leading/trailing
--- whitespace from the input string during processing.
--- @param s string The string to wrap.
--- @param wrap_column number The maximum column width for the wrapped lines.
--- @return table An array of strings representing the wrapped lines.
function M.wrap_str(s, wrap_column)
  local result = {} -- Array to store wrapped lines
  local line = ''   -- Current line being built

  -- Iterate through words in the string
  for word in s:gmatch('%S+') do
    -- Check if adding the word exceeds the column limit
    if #line + #word + 1 > wrap_column then
      table.insert(result, line) -- Save the current line
      line = word                -- Start a new line with the current word
    else
      -- Add the word to the current line (with a space if needed)
      if #line > 0 then
        line = line .. ' ' .. word
      else
        line = word
      end
    end
  end

  -- Add any remaining text in the last line to the result
  if #line > 0 then
    table.insert(result, line)
  end

  return result
end

--- @diagnostic disable: undefined-doc-param
--- Wraps/unwraps each paragraph in the lines array and returns the updated lines.
--- @param lines string[] The lines to wrap/unwrap.
--- @param opts table Options table with fields:
--- @param opts.column_number number The wrap column number (defaults to 0).
--- @param opts.unwrap boolean Unwrap instead of wrapping (defaults to false).
--- @return string[] The wrapped/unwrapped lines.
function M.wrap_paragraphs(lines, opts)
  opts = opts or {}
  local column_number = opts.column_number or 0
  local unwrap = opts.unwrap or false
  local result = {}
  local paragraph = {}

  -- Wrap `paragraph` and append to `result`
  local function wrap_paragraph()
    if #paragraph == 0 then
      return
    end

    -- Join all lines into a single string
    local joined_text = table.concat(paragraph, ' ')
    local wrapped_lines
    if unwrap then
      wrapped_lines = { joined_text }
    else
      -- Split the text at the wrap column into an array of wrapped lines
      local indent = joined_text:match('^(%s*)')
      wrapped_lines = M.wrap_str(joined_text, column_number - #indent)

      -- Indent all lines with the same indent as the first line
      M.indent_lines(wrapped_lines, indent)
    end

    -- Append wrapped paragraph to result
    for _, line in ipairs(wrapped_lines) do
      table.insert(result, line)
    end

    paragraph = {}
  end

  for _, line in ipairs(lines) do
    if line == '' then -- Paragraph break
      wrap_paragraph()
      table.insert(result, line)
    else
      table.insert(paragraph, line)
    end
  end
  wrap_paragraph()
  return result
end

--- Gets the lines spanned by the most recent visual selection.
--- Must be called while in visual mode or immediately after exiting it
--- (it exits visual mode itself to set the '< and '> marks).
--- Shows an error notification if not currently in visual mode.
--- @return table|nil lines An array of strings containing the selected lines, or nil on error.
--- @return number start_line The 1-based start line number of the selection, or 0 on error.
--- @return number end_line The 1-based end line number of the selection, or 0 on error.
function M.get_selected_lines()
  if not M.is_visual_mode() then
    vim.notify('This function must be executed in visual mode', vim.log.levels.ERROR)
    return nil, 0, 0
  end

  -- Exit visual mode (synchronously) to set `<` and `>` marks.
  vim.cmd('normal! ' .. vim.api.nvim_replace_termcodes('<Esc>', true, false, true))

  -- Get the current buffer
  local buf = vim.api.nvim_get_current_buf()

  -- Get the start and end marks of the visual selection
  local start_line = vim.api.nvim_buf_get_mark(buf, '<')[1] -- '<' is the start of the visual selection
  local end_line = vim.api.nvim_buf_get_mark(buf, '>')[1]   -- '>' is the end of the visual selection

  -- Get the lines in the selected range
  local selected_lines = vim.api.nvim_buf_get_lines(buf, start_line - 1, end_line, false)

  -- Return values in the new order: selected_lines, start_line, end_line
  return selected_lines, start_line, end_line
end

--- Gets the lines belonging to the paragraph under the cursor.
--- A paragraph is defined as consecutive non-blank lines surrounded by blank lines
--- or buffer boundaries. Shows an error if the cursor is currently on a blank line.
--- @return table|nil lines An array of strings containing the paragraph lines, or nil on error.
--- @return number start_line The 1-based start line number of the paragraph, or 0 on error.
--- @return number end_line The 1-based end line number of the paragraph, or 0 on error.
function M.get_paragraph()
  -- Check we are not at a blank line
  if vim.api.nvim_get_current_line():match('%S') == nil then
    vim.notify("No paragraph found", vim.log.levels.ERROR)
    return nil, 0, 0
  end

  -- Get the current paragraph's range
  local start_line = vim.fn.search('^\\s*$', 'bW') + 1 -- Find the start line of the paragraph (1-based)
  local end_line = vim.fn.search('^\\s*$', 'W') - 1    -- Find the last line of the paragraph (1-based)

  -- NOTE: vim.fn.search returns 0 if a match is not found (start_line=1, end_line=-1).
  if end_line == -1 then
    end_line = vim.api.nvim_buf_line_count(0) -- Correct end_line
  end


  -- Get all lines in the paragraph
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

  return lines, start_line, end_line
end

--- Replaces a range of lines in the current buffer with new lines.
--- Replaces the lines from `start_line` to `end_line` (inclusive, 1-based)
--- with the content of the `lines` table. Sets the cursor position to the
--- beginning of the last inserted line.
--- @param lines table An array of strings to insert.
--- @param start_line number The 1-based starting line number of the range to replace.
--- @param end_line number The 1-based ending line number of the range to replace.
function M.set_lines(lines, start_line, end_line)
  vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, lines)
  local cursor_line = start_line + #lines - 1
  vim.api.nvim_win_set_cursor(0, { cursor_line, 0 })
end

--- Selects a range of lines in Visual Line mode ('V').
--- Assumes 1-based line numbering.
--- @param start_line number The 1-based starting line number to select.
--- @param end_line number The 1-based ending line number to select.
function M.set_selection(start_line, end_line)
  local cmd = string.format('normal! %dGV%dG', start_line, end_line)
  vim.api.nvim_exec(cmd, false)
end

---@class SendKeysOptions
---@field editor_pane_id? number The tmux pane ID of the Neovim editor (default: 1).
---@field terminal_pane_id? number The tmux pane ID of the target terminal (default: 2).
---@field focus_pane_id? number The tmux pane ID to focus after sending keys (default: editor_pane_id).

--- Saves modified buffers and executes specified keys in a target tmux terminal pane.
--- The `send_keys_to_terminal` function resolves potential save/execute race conditions.
--- The core problem is that the Neovim `wa` command might return control before the
--- data has actually been fully written to the disk and propagated through the NFS
--- client's cache, and potentially acknowledged/visible via the NFS server.
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
function M.send_keys_to_terminal(keys, opts)
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

--- Parse a CSV line into fields, handling optional double-quoted fields.
-- Handles commas and escaped quotes inside quoted fields according to standard CSV rules.
-- @param line string: The CSV line to parse.
-- @return table: An array of parsed fields as strings.
local function parse_csv_line(line)
  local res = {}
  local i = 1
  local len = #line
  while i <= len do
    local c = line:sub(i, i)
    local field = ""
    if c == '"' then
      -- Quoted field
      i = i + 1
      while i <= len do
        c = line:sub(i, i)
        if c == '"' then
          if line:sub(i + 1, i + 1) == '"' then
            -- Escaped quote
            field = field .. '"'
            i = i + 2
          else
            -- End of quoted field
            i = i + 1
            break
          end
        else
          field = field .. c
          i = i + 1
        end
      end
      -- Skip comma after quoted field, if present
      if line:sub(i, i) == ',' then
        i = i + 1
      end
    else
      -- Unquoted field
      while i <= len and line:sub(i, i) ~= ',' do
        field = field .. line:sub(i, i)
        i = i + 1
      end
      -- Skip comma after field, if present
      if line:sub(i, i) == ',' then
        i = i + 1
      end
      -- Trim whitespace
      field = field:match("^%s*(.-)%s*$")
    end
    table.insert(res, field)
  end
  return res
end

--- Convert a CSV string to a Markdown table.
-- Assumes the first line contains headers. Handles fields optionally quoted with double quotes.
-- @param csv string: The CSV data as a string.
-- @return string: The resulting Markdown table as a string.
function M.csv_to_markdown(csv)
  local lines = {}
  for line in csv:gmatch("[^\r\n]+") do
    table.insert(lines, line)
  end

  if #lines == 0 then
    return ""
  end

  local header = parse_csv_line(lines[1])
  local markdown = "| " .. table.concat(header, " | ") .. " |\n"
  markdown = markdown .. "|" .. string.rep("---|", #header) .. "\n"

  for i = 2, #lines do
    local row = parse_csv_line(lines[i])
    markdown = markdown .. "| " .. table.concat(row, " | ") .. " |\n"
  end

  return markdown
end

--- Convert a Markdown table string to CSV.
-- @param Markdown: The Markdown table as a string.
-- @return string: The resulting CSV as a string.
function M.markdown_to_csv(md)
  local csv_lines = {}
  local lines = {}
  -- Split the input into lines
  for line in md:gmatch("[^\r\n]+") do
    table.insert(lines, line)
  end
  -- Process each relevant line
  for i, line in ipairs(lines) do
    -- Skip the separator (second line)
    if i ~= 2 then
      -- Remove leading/trailing pipes and whitespace
      line = line:gsub("^%s*|", ""):gsub("|%s*$", "")
      -- Split by pipes
      local cells = {}
      for cell in line:gmatch("[^|]+") do
        -- Trim whitespace from cell
        cell = cell:match("^%s*(.-)%s*$")
        -- Escape double quotes and wrap in double quotes
        cell = '"' .. cell:gsub('"', '""') .. '"'
        table.insert(cells, cell)
      end
      -- Concatenate cells with commas
      table.insert(csv_lines, table.concat(cells, ","))
    end
  end
  -- Join lines with newlines
  return table.concat(csv_lines, "\n")
end

--- Converts a URL and optional link text to a Markdown link string.
-- If `text` is nil or empty, the URL itself is used as the link text.
--
-- Rules:
--  * If `url` starts with '/', returns `[text](file://url)`
--  * If `url` starts with '~', replaces '~' with $HOME and returns `[text](file://expanded_url)`
--  * If `url` starts with 'http:' or 'https:', returns `[text](url)`
--  * Otherwise, returns `[text](https://url)`
--
-- @param url string: The URL or path to link to.
-- @param text string|nil: The link text (optional).
-- @return string: The formatted Markdown link.
function M.url_to_markdown_link(url, text)
  if text == nil or text == "" then
    text = url
  end

  if string.sub(url, 1, 1) == "/" then
    return string.format("[%s](file://%s)", text, url)
  end

  if string.sub(url, 1, 1) == "~" then
    local home = os.getenv("HOME") or "~"
    local expanded_url = home .. string.sub(url, 2)
    return string.format("[%s](file://%s)", text, expanded_url)
  end

  if string.sub(url, 1, 5) == "http:" or string.sub(url, 1, 6) == "https:" then
    return string.format("[%s](%s)", text, url)
  end

  return string.format("[%s](https://%s)", text, url)
end

--- Paste the clipboard (`+` register) as a Markdown link at the cursor.
-- Disables abbreviation expansion during insertion, restores it after.
-- Switches to insert mode if not already, inserts the link, and leaves you in insert mode.
-- @param text string|nil: The link text (optional).
function M.paste_clipboard_as_markdown_link(text)
  local url = vim.fn.getreg("+")
  if url == nil or url == "" then
    vim.notify("Clipboard is empty!", vim.log.levels.WARN)
    return
  end

  local link = M.url_to_markdown_link(url, text)

  -- Save current 'paste' setting
  local paste_was_on = vim.o.paste
  -- Enable 'paste' to disable abbreviations
  vim.o.paste = true

  local function restore_paste()
    vim.o.paste = paste_was_on
  end

  if vim.fn.mode() ~= "i" then
    -- Enter insert mode, then schedule the insertion for after the mode change
    vim.api.nvim_feedkeys("i", "n", false)
    vim.schedule(function()
      vim.api.nvim_feedkeys(link, "i", false)
      restore_paste()
    end)
  else
    -- Already in insert mode, just insert the link
    vim.api.nvim_feedkeys(link, "i", false)
    restore_paste()
  end
end

return M
