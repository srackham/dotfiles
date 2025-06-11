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
    }
    vim.keymap.set('n', '<Leader>nd', "<Cmd>ObsidianToday<CR>", { desc = "New daily note for today" })
    vim.keymap.set('n', '<Leader>ni', "<Cmd>ObsidianPasteImg<CR>", { desc = "Insert image from clipboard" })
    vim.keymap.set('n', '<Leader>nn', "<Cmd>ObsidianNew<CR>", { desc = "New note" })
    vim.keymap.set('n', '<Leader>no', "<Cmd>ObsidianOpen<CR>", { desc = "Open note in Obsidian application" })
    vim.keymap.set('n', '<Leader>nf', "<Cmd>ObsidianQuickSwitch<CR>", { desc = "Notes file picker" })
    vim.keymap.set('n', '<Leader>ng', "<Cmd>ObsidianSearch<CR>", { desc = "Search notes files with ripgrep" })
    vim.keymap.set('n', '<Leader>nt', "<Cmd>ObsidianTemplate<CR>", { desc = "New note from template" })
    -- Links related commands
    vim.keymap.set('n', '<Leader>ll', "<Cmd>ObsidianLinks<CR>", { desc = "Links picker" })
    vim.keymap.set('n', '<Leader>lb', "<Cmd>ObsidianBacklinks<CR>", { desc = "Backlinks picker" })
    vim.keymap.set('v', '<Leader>le', "<Cmd>ObsidianLink<CR>",
      { desc = "Replace selected note ID, path or alias with a link to an existing note" })
    vim.keymap.set('v', '<Leader>ln', "<Cmd>ObsidianLinkNew<CR>",
      { desc = "Replace selected note title of with a link to a new note" })
  end,
}
