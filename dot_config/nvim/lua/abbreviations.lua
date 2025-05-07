--[[
TODO:
05-May-2025: TLDR: Nice idea but it misses so many of my spelling errors. Maybe I need to wait for an AI powered grammar/spelling checker.

05-May-2025: This module was inspired by [mistake.nvim: a spelling auto correct plugin for Neovim including over 20k entries](https://github.com/ck-zhang/mistake.nvim/tree/main?tab=readme-ov-file) but it's has a number of limitations (see ## Todo at start of neovim-notes.md).

NOTE: Ultimately I think the answer to spelling/grammar correction will come from AI because it can understand both context and grammar.

- AI plugins like this are really promising: [AdrianMosnegutu/docscribe.nvim: A Neovim plugin for generating inline documentation for your functions using LLMs.](https://github.com/AdrianMosnegutu/docscribe.nvim?tab=readme-ov-file)


- Change name to abbreviations.nvim (typos.nvim is taken).
- Once it's all finished turn it into a plugin
- Add `,at` `,aT` and `,al` commands to toggle and load abbreviations (`,aT` toggles abbreviations and spell checking).
- Maybe the commands should include enabling/disabling spell checking.
- Setup should optionally load (you may want to explicitly load).
- Load(abbreviations,opts) opts is options table.

- opts.notify boolean Display status messages while loading cf. <Leader>ct.
  "Abbreviations loading..."
  "Abbreviations loaded"
  Implemented with a `last_chunk` flag.

- The builtin typos abbreviations are optional: set `M.typos_dict = {}`to exclude the builtin typos dictionary abbreviations.`

- Here's a list of some other: https://titan.dcs.bbk.ac.uk/~ROGER/corpora.html

Config:

function toggle_abbrviations()
  if loaded then
    vim.cmd('abclear')
  else
    typos.load(user_abbrevs)
  end
  loaded = not loaded
end


]]

local M = {}

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

function M.load(user_dict, opts)
  opts = opts or {}
  user_dict = user_dict or {}
  local chunk_size = 100
  local chunks = {}
  local current_chunk = {}

  local abbreviations = concat_tables(M.typos_dict, user_dict)
  for i, pair in ipairs(abbreviations) do
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
      if opts.notify and i == #chunks then
        vim.notify(#abbreviations .. " abbreviations loaded", vim.log.levels.INFO)
      end
    end, delay_ms)
  end
end

return M
