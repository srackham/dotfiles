return {
  "obsidian-nvim/obsidian.nvim", -- A community fork of epwalsh/obsidian.nvim
  version = "*",                 -- Use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
    'nvim-telescope/telescope.nvim',
  },
  opts = {
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
  },
}
