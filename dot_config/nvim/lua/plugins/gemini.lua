return {
  'meinside/gemini.nvim',
  dependencies = { { 'nvim-lua/plenary.nvim' } },
  config = function()
    require 'gemini'.setup {
      configFilepath = vim.fn.stdpath('config') .. '/lua/plugins/gemini.json',
    }
  end,
}
