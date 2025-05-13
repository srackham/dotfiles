--[[
05-May-2025: TLDR: Nice idea but it misses so many of my spelling errors. Maybe I need to wait for an AI powered grammar/spelling checker.
Ultimately I think the answer to spelling/grammar correction will come from AI because it can understand both context and grammar.

- AI plugins like this are really promising: [AdrianMosnegutu/docscribe.nvim: A Neovim plugin for generating inline documentation for your functions using LLMs.](https://github.com/AdrianMosnegutu/docscribe.nvim?tab=readme-ov-file)

05-May-2025: This module was inspired by [mistake.nvim: a spelling auto correct plugin for Neovim including over 20k entries](https://github.com/ck-zhang/mistake.nvim/tree/main?tab=readme-ov-file) but it's has a number of limitations (see ## Todo at start of neovim-notes.md).

TODO:
09-May-2025: This should be turned into a Telescope-based function M.pick() that allows you to select abbreviations.
M.pick() would be used by M.edit() and M.delete() to edit and delete the selected abbreviation (Enter to edit, Del to delete, Esc to cancel).
A M.create() function that prompts you to create an abbreviation.
Input facilitated by https://github.com/liangxianzhe/floating-input.nvim
Maybe something simple with inputs like:

  hm Home Manager     # Create/update
  hm                  # Delete hm or warn if does not exist

Store persistent abbreviation data in `vim.fn.stdpath('data') .. '/abbreviations.nvim' (` ~/.local/share/nvim/abbreviations.nvim`) with the following `write_table` function:

```lua
function write_table(tbl, filename)
    local file, err = io.open(filename, "w")
    if not file then error(err) end
    file:write("return {\n")
    for _, pair in ipairs(tbl) do
        file:write(string.format('  {%q, %q},\n', pair[1], pair[2]))
    end
    file:write("}\n")
    file:close()
end
```

### Example Usage

```lua
local data = {
    {"fo","of"},
    {"authorixation","authorization"},
    {"liek","like"},
}
write_table(data, "mytable.lua")
-- Now you can: local t2 = require("mytable")
```

Here’s how to read the table back again:

```lua
local path = vim.fn.stdpath('data') .. '/abbreviations.lua'
local abbreviations = dofile(path)
```
This will load the table exactly as it was written, because dofile executes the file and returns the value after return. No manual parsing or string manipulation is needed.

Interim:

- Add `dicts` setup option to load builtin dictionaries M.dicts e.g. setup({dicts={'typos'}}) requires typos.lua (require('abbreviations.typos)).
- The M.load function can override setup dicts e.g. load({dicts={'typos'}})
- Once it's all finished turn it into a plugin
- Add `,aT` command to toggle and load abbreviations as well as spell checking???.
- The builtin typos abbreviations are optional: set `M.typos_dict = {}`to exclude the builtin typos dictionary abbreviations.`

- Here's a list of some other typos databases: https://titan.dcs.bbk.ac.uk/~ROGER/corpora.html

]]

local M = {}

M.dict = {}
M.user_dict = {}
M.typos_dict = require('typos_dict')

local function concat_tables(t1, t2)
  -- Create a new table to hold the result
  local result = {}
  -- Copy elements from t1
  for i = 1, #t1 do
    result[i] = t1[i]
  end
  -- Append elements from t2
  for i = 1, #t2 do
    result[#result + 1] = t2[i]
  end
  return result
end

function M.setup(opts)
  opts = opts or {}
  M.user_dict = opts.user_dict or {}
end

function M.clear()
  vim.cmd('iabclear')
  M.dict = {}
  vim.notify("Abbreviations cleared", vim.log.levels.INFO)
end

function M.toggle()
  if #M.dict > 0 then
    M.clear()
  else
    M.load({ notify = true })
  end
end

function M.load(opts)
  opts = opts or {}
  local chunk_size = 100
  local chunks = {}
  local current_chunk = {}

  M.dict = concat_tables(M.typos_dict, M.user_dict)
  for i, pair in ipairs(M.dict) do
    table.insert(current_chunk, pair)
    if i % chunk_size == 0 then
      table.insert(chunks, current_chunk)
      current_chunk = {}
    end
  end

  -- Add the last chunk if not empty
  if #current_chunk > 0 then
    table.insert(chunks, current_chunk)
  end

  -- Schedule each chunk with increasing delay
  if opts.notify then
    vim.notify("Loading abbreviations...", vim.log.levels.INFO)
  end
  for i, chunk in ipairs(chunks) do
    local delay_ms = (i - 1) * 10 -- 10ms delay between chunks
    vim.defer_fn(function()
      for _, pair in ipairs(chunk) do
        local typo, correction = pair[1], pair[2]
        vim.cmd('iabbrev ' .. typo .. ' ' .. correction)
      end
      if i == #chunks then -- Last chunk
        if opts.notify then
          vim.notify(#M.dict .. " abbreviations loaded", vim.log.levels.INFO)
        end
      end
    end, delay_ms)
  end
end

return M
