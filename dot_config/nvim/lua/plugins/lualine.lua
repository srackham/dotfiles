return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup({
      options = {
        theme = 'dracula',
      },
      sections = {
        lualine_c = {
          {
            'filename',
            path = 1 -- 0 = filename only, 1 = relative path, 2 = absolute path
          }
        }
      }
    })
  end,
}
