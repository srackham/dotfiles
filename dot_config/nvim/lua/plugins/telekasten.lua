return {
  'renerocksai/telekasten.nvim',
  dependencies = { 'nvim-telescope/telescope.nvim' },
  enabled = true,
  config = function()
    require('telekasten').setup({
      home = vim.fn.expand("~/doc"), -- Put the name of your notes directory here
    })
  end,
}
