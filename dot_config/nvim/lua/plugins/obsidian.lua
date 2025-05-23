return {
  "epwalsh/obsidian.nvim",
  enabled = false,
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "doc",
        path = "~/doc",
      },
    },
  },
}
