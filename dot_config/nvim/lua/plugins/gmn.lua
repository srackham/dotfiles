return {
  'meinside/gmn.nvim',
  dependencies = { { 'nvim-lua/plenary.nvim' } },
  config = function()
    require 'gmn'.setup {
      configFilepath = vim.fn.stdpath('config') .. '/lua/plugins/gmn.json',
    }
  end,
}
