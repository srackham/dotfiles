return {
  "meinside/gmn.nvim",
  enabled = false,
  dependencies = { { "nvim-lua/plenary.nvim" } },
  config = function()
    require("gmn").setup {
      configFilepath = vim.fn.stdpath "config" .. "/lua/plugins/gmn.json",
    }
  end,
}
