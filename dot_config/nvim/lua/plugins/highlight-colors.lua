return {
  'brenoprata10/nvim-highlight-colors',
  config = function()
    vim.opt.termguicolors = true -- Ensure termguicolors is enabled if not already
    require('nvim-highlight-colors').setup({})
  end,
}
