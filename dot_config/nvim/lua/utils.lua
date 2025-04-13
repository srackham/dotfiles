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

function M.wrap_paragraph()
  -- Get the cursor column for wrapping
  local wrap_column = vim.fn.col('.') - 1 -- Convert to 0-based index

  -- Get the current paragraph's range
  local start_line = vim.fn.search('^\\s*$', 'bW') + 1 -- Find the start of the paragraph
  local end_line = vim.fn.search('^\\s*$', 'W')        -- Find the end of the paragraph

  if start_line > end_line then
    print("No paragraph found")
    return
  end

  -- Get all lines in the paragraph
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

  -- Join all lines into a single string
  local joined_text = table.concat(lines, ' ')

  -- Initialize variables for wrapping
  local wrapped_lines = {}
  local remaining_text = joined_text

  while #remaining_text > 0 do
    -- Get a chunk of text up to the target column
    local chunk = remaining_text:sub(1, wrap_column + 1)

    -- Find the last space in the chunk to wrap at a word boundary
    local last_space = chunk:reverse():find('%s')
    if last_space then
      chunk = chunk:sub(1, #chunk - last_space)
      remaining_text = remaining_text:sub(#chunk + 2) -- Skip the space
    else
      -- If no spaces are found, break at the column limit
      remaining_text = remaining_text:sub(wrap_column + 2)
    end

    table.insert(wrapped_lines, chunk)
  end

  -- Replace the original paragraph with wrapped lines (including last line)
  vim.api.nvim_buf_set_lines(0, start_line - 1, end_line - 1, false, wrapped_lines)
end

return M
