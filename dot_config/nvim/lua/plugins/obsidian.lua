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
        -- Legacy and non-PKM relates documents
        name = "doc",
        path = "~/share/doc",
      },
    },
    completion = {
      blink = true,  -- Enables completion using blink.cmp
      min_chars = 0, -- Trigger completion at 2 chars.
    },
    daily_notes = {
      folder = "daily",
      workdays_only = false,
    },
  },
}
