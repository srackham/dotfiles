-- ~/.config/nvim/lua/typos.lua

local M = {}

local dict = require("typos_dict")

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

local function load_chunk(chunk, delay_ms)
  vim.defer_fn(function()
    for _, pair in ipairs(chunk) do
      local typo, correction = pair[1], pair[2]
      vim.cmd("iabbrev " .. typo .. " " .. correction)
    end
  end, delay_ms)
end

function M.load(user_dict)
  user_dict = user_dict or {}
  local chunk_size = 100
  local chunks = {}
  local current_chunk = {}

  local abbreviations = concat_tables(dict, user_dict)
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
  for i, chunk in ipairs(chunks) do
    load_chunk(chunk, (i - 1) * 10) -- 10ms delay between chunks
  end
end

return M
