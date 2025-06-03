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
