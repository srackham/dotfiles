return {
  "renerocksai/telekasten.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  enabled = false, -- 24-May-2025: disabled because it interfered with Markdown syntax highlighting
  config = function()
    require("telekasten").setup {
      home = vim.fn.expand "~/doc", -- Put the name of your notes directory here
    }
  end,
}
