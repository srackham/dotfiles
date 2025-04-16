-- Module initialisation
local M = {}

-- Add local development paths so they can be loaded using `require`
function M.add_to_path(path)
  -- vim.opt.runtimepath:prepend(path) -- THIS DOESN'T SEEM NECESSARY
  package.path = path .. '/?.lua;' .. path .. '/?/init.lua;' .. package.path
end

-- `reload_modified_buffers` reloads all modified buffers from disk restoring the buffer to the last saved state.
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
    vim.notify(table.concat(msgs, "\n"))
  end
end

-- `get_visual_selection` returns a string containing selected text.
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

-- `find_help` searches for help on the `query` string.
-- If found then open it in a help window, if not print and error message.
function M.find_help(query)
  -- Attempt to execute the command with pcall
  local success, _ = pcall(function()
    vim.cmd('help ' .. query)
  end)
  if not success then
    vim.notify("Failed to open help for: " .. query, vim.log.levels.ERROR)
  end
end

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

-- Delete the current item from the quickfix list.
-- The cursor remains at the same cursor position, or is moved to the the preceeding item if it was at the last item.
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

function M.indent_lines(lines, indent)
  for i, line in ipairs(lines) do
    lines[i] = indent .. line
  end
end

-- Wrap string `s` at column number `colnr`.
--
-- -  Word boundaries are respected.
-- -  Multiple white-space is replaced by a single space character.
-- -  Leading and trailing paragraphs white-space is removed.
--
function M.wrap_str(s, colnr)
  local result = {} -- Array to store wrapped lines
  local line = ""   -- Current line being built

  -- Iterate through words in the string
  for word in s:gmatch("%S+") do
    -- Check if adding the word exceeds the column limit
    if #line + #word + 1 > colnr then
      table.insert(result, line) -- Save the current line
      line = word                -- Start a new line with the current word
    else
      -- Add the word to the current line (with a space if needed)
      if #line > 0 then
        line = line .. " " .. word
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

-- Returns three values:
--
-- 1. A Lua string array containing the lines spanned by the selection
-- 2. The selection start line number
-- 3. The selection end line number
function M.get_selected_lines()
  local is_visual_mode = vim.fn.mode() == 'v' or vim.fn.mode() == 'V'
  if not is_visual_mode then
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

-- Returns three values:
--
-- 1. A Lua string array containing the paragraph lines
-- 2. The paragraph start line number
-- 3. The paragraph end line number
function M.get_paragraph()
  -- Check we are not at a blank line
  if vim.api.nvim_get_current_line():match("%S") == nil then
    vim.notify("No paragraph found", vim.log.levels.ERROR)
    return nil, 0, 0
  end

  -- Get the current paragraph's range
  local start_line = vim.fn.search('^\\s*$', 'bW') + 1 -- Find the start line of the paragraph (1-based)
  local end_line = vim.fn.search('^\\s*$', 'W') - 1    -- Find the last line of the paragraph (1-based)

  -- NOTE: `start_line` is 1 if paragraph begins at the start of the buffer;
  --       `end_line` is -1 if the paragraph is at the end of the buffer.

  -- Get all lines in the paragraph
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

  return lines, start_line, end_line
end

-- `start_line` and `end_line` are 1-based
function M.set_lines(lines, start_line, end_line)
  -- Replace the original paragraph with wrapped lines
  vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, lines)

  -- Set cursor end position on the last line of the block.
  local cursor_line = start_line + #lines - 1
  vim.api.nvim_win_set_cursor(0, { cursor_line, 0 })
end

function M.map_block(mapfn)
  local is_visual_mode = vim.fn.mode() == 'v' or vim.fn.mode() == 'V'
  local lines, start_line, end_line
  if is_visual_mode then
    lines, start_line, end_line = M.get_selected_lines()
  else
    lines, start_line, end_line = M.get_paragraph()
  end
  if lines == nil then
    return
  end
  local mapped_lines = mapfn(lines)
  M.set_lines(mapped_lines, start_line, end_line)
end

-- Wraph the current paragraph at the current cursor column position.
function M.wrap_block()
  -- Get the cursor column for wrapping
  local wrap_column = vim.fn.col('.') -- 1-based

  M.map_block(function(lines)
    -- Join all lines into a single string
    local joined_text = table.concat(lines, ' ')

    -- Split the text at the wrap column into an array of wrapped lines
    local wrapped_lines = M.wrap_str(joined_text, wrap_column)

    -- Indent all lines with the same indent as the first line
    local indent = joined_text:match('^(%s*)')
    M.indent_lines(wrapped_lines, indent)
    return wrapped_lines
  end)
end

-- Quote/unquote the current paragraph.
function M.quote_block()
  M.map_block(function(lines) -- Check if the first line starts with '>' followed by zero or more whitespace characters
    if lines[1]:match('^%s*>%s*') then
      -- If the first line starts with '>', remove it along with the whitespace on this and all subsequent lines
      for i, line in ipairs(lines) do
        if line:match('^%s*>%s*') then
          lines[i] = line:gsub('^%s*>%s*', '') -- Remove '>' and any following whitespace
        end
      end
    else
      -- If the first line does not start with '>', prepend '> ' to every line
      for i, line in ipairs(lines) do
        lines[i] = '> ' .. line
      end
    end
    return lines
  end)
end

-- Add/remove line breaks to/from the current paragraph.
function M.break_block()
  local is_visual_mode = vim.fn.mode() == 'v' or vim.fn.mode() == 'V'

  M.map_block(function(lines) -- Check if the first line starts with '>' followed by zero or more whitespace characters
    -- Check if the first line ends with '\' preceded by zero or more whitespace characters
    if lines[1]:match("%s*\\$") then
      -- If the first line ends with '\', remove it and the whitespace on this and all subsequent lines
      for i, line in ipairs(lines) do
        if line:match("%s*\\$") then
          lines[i] = line:gsub("%s*\\$", "") -- Remove '\' and preceding whitespace
        end
      end
    else
      -- If the first line does not end with '\', append ' \' to lines that do not already end with '\'
      for i, line in ipairs(lines) do
        if not line:match("\\$") then
          lines[i] = line .. " \\"
        end
      end
    end
    -- Ensure the last line of a paragraph does not get a break
    if not is_visual_mode then
      lines[#lines] = lines[#lines]:gsub("%s*\\$", "") -- Remove '\' and any preceding whitespace from the last element
    end
    return lines
  end)
end

return M
