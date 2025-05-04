-- ~/.config/nvim/lua/typos.lua

local M = {}

local dict = require("typos_dict")

-- Add custom abbreviations here.
local user_dict = {
  ["<expr> dd"] = "strftime('%d-%b-%Y')",
  ["<expr> tt"] = "strftime('%H:%M')",
  ["<expr> dt"] = "strftime('%d-%b-%Y %H:%M')",
}

local function merge_tables(t1, t2)
  local result = {}
  for k, v in pairs(t1) do result[k] = v end
  for k, v in pairs(t2) do result[k] = v end
  return result
end

local function load_chunk(chunk, delay_ms)
  vim.defer_fn(function()
    for typo, correction in pairs(chunk) do
      vim.cmd("iabbrev " .. typo .. " " .. correction)
    end
  end, delay_ms)
end

function M.load()
  local chunk_size = 100
  local chunks = {}
  local current_chunk = {}
  local count = 0
  local abbreviations = merge_tables(user_dict, dict)

  for typo, correction in pairs(abbreviations) do
    count = count + 1
    current_chunk[typo] = correction
    if count % chunk_size == 0 then
      table.insert(chunks, current_chunk)
      current_chunk = {}
    end
  end

  -- Add the last chunk if not empty
  if next(current_chunk) ~= nil then
    table.insert(chunks, current_chunk)
  end

  -- Schedule each chunk with increasing delay
  for i, chunk in ipairs(chunks) do
    load_chunk(chunk, (i - 1) * 10) -- 10ms delay between chunks
  end
end

return M
