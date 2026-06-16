return {
  "nvim-treesitter/nvim-treesitter",
  enabled = true,
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local ts = require "nvim-treesitter"
    ts.setup {}
    ts.install {
      "bash",
      "c",
      "css",
      "gleam",
      "go",
      "gotmpl",
      "html",
      "javascript",
      "json",
      "lua",
      "markdown",
      "markdown_inline",
      "powershell",
      "python",
      "query",
      "rust",
      "templ",
      "toml",
      "typescript",
      "vim",
      "vimdoc",
      "yaml",
    }
  end,
}
