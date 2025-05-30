return {
  "obsidian-nvim/obsidian.nvim", -- A community fork of epwalsh/obsidian.nvim
  version = "*",                 -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
    'nvim-telescope/telescope.nvim', -- Optional, for search and quick-switch functionality.
  },
  opts = {
    workspaces = {
      {
        name = "doc",
        path = "~/share/doc",
      },
    },
    completion = {
      blink = true,  -- Enables completion using blink.cmp
      min_chars = 2, -- Trigger completion at 2 chars.
    },
  },
}
