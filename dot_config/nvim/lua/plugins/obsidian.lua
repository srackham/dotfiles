return {
  "obsidian-nvim/obsidian.nvim", -- A community fork of epwalsh/obsidian.nvim
  version = "*",                 -- Use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    local obsidian = require 'obsidian'
    obsidian.setup {
      workspaces = {
        {
          -- PKM notes
          name = "notes",
          path = "~/share/notes",
        },
        {
          -- Legacy and non-PKM-related documents
          name = "doc",
          path = "~/share/doc",
        },
      },
      attachments = {
        img_folder = "attachments",
        img_name_func = function()
          return "" -- No default file name
        end,
        -- FIX: Leave path separators in encoded paths (see https://github.com/obsidian-nvim/obsidian.nvim/issues/119)
        img_text_func = function(client, path)
          path = client:vault_relative_path(path) or path
          local caption = vim.fs.basename(tostring(path))
          caption = caption:match("^(.*)%.([^%.]*)$") or caption -- Strip file name extension
          local encoded_path = vim.uri_from_fname(tostring(path))
          encoded_path = encoded_path:match("^file://(.*)")      -- Strip leading 'file://'
          return string.format("![%s](%s)", caption, encoded_path)
        end,
      },
      templates = {
        folder = "templates",
        date_format = "%Y-%m-%d-%a",
        time_format = "%H:%M",
      },
      completion = {
        blink = true,  -- Enables completion using blink.cmp
        min_chars = 0, -- Completion trigger length
      },
      daily_notes = {
        folder = "daily",
        workdays_only = false,
      },
      note_id_func = function(title)
        if title ~= nil then
          return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-_]", ""):lower()
        end
      end,
    }
    vim.keymap.set('n', '<Leader>os', "<Cmd>ObsidianTOC<CR>", { desc = "Markdown section headers picker" })
    vim.keymap.set('n', '<Leader>od', "<Cmd>ObsidianToday<CR>", { desc = "New daily note for today" })
    vim.keymap.set('n', '<Leader>oi', "<Cmd>ObsidianPasteImg<CR>", { desc = "Insert image from clipboard" })
    vim.keymap.set('n', '<Leader>on', "<Cmd>ObsidianNew<CR>", { desc = "New note" })
    vim.keymap.set('n', '<Leader>oN', "<Cmd>ObsidianTemplate<CR>", { desc = "New note from template" })
    vim.keymap.set('n', '<Leader>oo', "<Cmd>ObsidianOpen<CR>", { desc = "Open note in Obsidian application" })
    vim.keymap.set('n', '<Leader>of', "<Cmd>ObsidianQuickSwitch<CR>", { desc = "Notes file picker" })
    vim.keymap.set('n', '<Leader>og', "<Cmd>ObsidianSearch<CR>", { desc = "Search notes files with ripgrep" })
    vim.keymap.set('n', '<Leader>ot', "<Cmd>ObsidianTags<CR>", { desc = "Search for tagged notes" })
    -- Links related commands
    vim.keymap.set('n', '<Leader>ll', "<Cmd>ObsidianLinks<CR>", { desc = "Links picker" })
    vim.keymap.set('n', '<Leader>lb', "<Cmd>ObsidianBacklinks<CR>", { desc = "Backlinks picker" })
    vim.keymap.set('v', '<Leader>le', "<Cmd>ObsidianLink<CR>",
      { desc = "Replace selected note ID, path or alias with a link to an existing note" })
    vim.keymap.set('v', '<Leader>ln', "<Cmd>ObsidianLinkNew<CR>",
      { desc = "Replace selected note title of with a link to a new note" })
  end,
}
