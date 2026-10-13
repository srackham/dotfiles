-- prefix_keymaps.lua
--
-- A Telescope picker (cf. `builtin.keymaps`) that lists keymaps in two columns:
--
--     <lhs> │ <description>
--
-- Instead of fuzzy matching, the prompt is a *key prefix filter*: only mappings
-- whose lhs begins with what you typed are shown. With `mapleader = ","`, typing
-- `,a` shows `,acn │ New chat` for
--
--     vim.keymap.set({ "n", "v" }, "<Leader>acn", "<Cmd>Qanda /new_chat<CR>", { desc = "New chat" })
--
-- Typing a space ends the key prefix: the text after it fuzzy-matches descriptions,
-- e.g. `,a new` lists `,a…` mappings whose description fuzzy-matches "new".
-- (If your leader is <Space>, the leading space counts as part of the prefix.)
--
-- Rows are unique (by lhs + description) and <CR> executes the selected mapping.
--
-- Install: save as  lua/prefix_keymaps.lua  in your Neovim config, then:
--
--     vim.keymap.set("n", "<Leader>?", function() require("prefix_keymaps").pick() end,
--       { desc = "Keymaps by prefix" })
--
-- Options (all optional):
--     modes        string[]  modes to collect            (default { "n", "x" })
--     require_desc boolean   only list mappings with desc (default true)
--     default_text string    initial prompt text           (default "")
--
-- See also https://claude.ai/share/69286d0a-9846-48f8-a5be-815bfdac11fc

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local entry_display = require("telescope.pickers.entry_display")
local conf = require("telescope.config").values

local M = {}

--- Expand a literal "<leader>" typed in the prompt to the actual leader key.
local function normalize_prompt(prompt)
  local leader = vim.g.mapleader or "\\"
  return (prompt:gsub("<[Ll][Ee][Aa][Dd][Ee][Rr]>", function()
    return leader
  end))
end

--- Collect unique keymaps (global + buffer-local) for the requested modes.
local function collect(opts)
  local seen, results = {}, {}

  local function add(mode, km)
    local lhs = km.lhs or ""
    if lhs:find("^<Plug>") or lhs:find("^<SNR>") then
      return
    end
    local desc = km.desc
    if not desc or desc == "" then
      if opts.require_desc then
        return
      end
      desc = km.rhs or (km.callback and "<Lua function>") or ""
    end
    local key = lhs .. "\0" .. desc
    if seen[key] then
      return
    end
    seen[key] = true
    results[#results + 1] = {
      mode = mode,
      lhs = lhs,
      lhsraw = km.lhsraw,
      desc = desc,
    }
  end

  for _, mode in ipairs(opts.modes) do
    -- buffer-local first so they win when de-duplicating
    for _, km in ipairs(vim.api.nvim_buf_get_keymap(0, mode)) do
      add(mode, km)
    end
    for _, km in ipairs(vim.api.nvim_get_keymap(mode)) do
      add(mode, km)
    end
  end

  table.sort(results, function(a, b)
    if a.lhs ~= b.lhs then
      return a.lhs < b.lhs
    end
    return a.desc < b.desc
  end)

  return results
end

--- Split a prompt into (key prefix, description query) at the first space.
--- If the leader is a space, a leading space is part of the key prefix.
local function parse_prompt(prompt)
  local p = normalize_prompt(prompt)
  local start = 1
  if (vim.g.mapleader or "\\") == " " and p:sub(1, 1) == " " then
    start = 2
  end
  local space = p:find(" ", start, true)
  if not space then
    return p, ""
  end
  return p:sub(1, space - 1), p:sub(space + 1)
end

--- Sorter that keeps entries whose lhs starts with the key prefix and, when a
--- space has been typed, whose description fuzzy-matches the text after it.
local function prefix_sorter()
  local fzy = sorters.get_fzy_sorter()

  local function prefix_matches(prefix, entry, line)
    if prefix == "" then
      return true
    end
    local lhs = entry and entry.lhs or line
    local raw = entry and entry.lhsraw
    return vim.startswith(lhs, prefix) or (raw ~= nil and vim.startswith(raw, prefix))
  end

  return sorters.Sorter:new({
    discard = true,
    scoring_function = function(_, prompt, line, entry)
      local prefix, query = parse_prompt(prompt)
      if not prefix_matches(prefix, entry, line) then
        return -1
      end
      if query == "" then
        return 1 -- prefix only: keep (stable order)
      end
      -- Fuzzy-match the description; fzy returns -1 when there is no match,
      -- and lower scores rank higher.
      return fzy.scoring_function(fzy, query, entry and entry.desc or "")
    end,
    tiebreak = function(current, existing)
      return (current.index or 0) < (existing.index or 0)
    end,
    highlighter = function(_, prompt, display)
      local prefix, query = parse_prompt(prompt)
      local highlights = {}
      if prefix ~= "" and vim.startswith(display, prefix) then
        highlights[#highlights + 1] = { start = 1, finish = #prefix }
      end
      if query ~= "" then
        -- The description starts right after the first column separator.
        local _, sep_end = display:find(" │ ", 1, true)
        if sep_end then
          local desc = display:sub(sep_end + 1)
          for _, pos in ipairs(fzy:highlighter(query, desc) or {}) do
            if type(pos) == "number" then
              highlights[#highlights + 1] = { start = sep_end + pos, finish = sep_end + pos }
            end
          end
        end
      end
      return highlights
    end,
  })
end

function M.pick(opts)
  opts = vim.tbl_extend("force", {
    modes = { "n", "x" },
    require_desc = true,
    default_text = "",
  }, opts or {})

  local keymaps = collect(opts)
  if #keymaps == 0 then
    vim.notify("No keymaps found", vim.log.levels.INFO)
    return
  end

  local width = 0
  for _, km in ipairs(keymaps) do
    width = math.max(width, vim.fn.strdisplaywidth(km.lhs))
  end

  local displayer = entry_display.create({
    separator = " │ ",
    items = { { width = width }, { remaining = true } },
  })

  pickers
    .new(opts, {
      prompt_title = "Keymaps by prefix",
      default_text = opts.default_text,
      finder = finders.new_table({
        results = keymaps,
        entry_maker = function(km)
          return {
            value = km,
            ordinal = km.lhs,
            lhs = km.lhs,
            lhsraw = km.lhsraw,
            desc = km.desc,
            mode = km.mode,
            display = function(entry)
              return displayer({
                { entry.lhs, "TelescopeResultsIdentifier" },
                { entry.desc, "TelescopeResultsComment" },
              })
            end,
          }
        end,
      }),
      sorter = prefix_sorter(),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          if not selection then
            return
          end
          actions.close(prompt_bufnr)

          local keys = selection.lhsraw
              or vim.api.nvim_replace_termcodes(selection.lhs, true, false, true)
          -- Visual-mode mappings need the last selection restored first.
          if selection.mode == "x" or selection.mode == "v" or selection.mode == "s" then
            keys = "gv" .. keys
          end
          -- "t": handle as typed (so the mapping fires); remap enabled.
          vim.api.nvim_feedkeys(keys, "t", false)
        end)
        return true
      end,
    })
    :find()
end

return M
