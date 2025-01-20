return {
  'stevearc/aerial.nvim',
  opts = {},
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons'
  },
  config = function()
    require('aerial').setup({
      layout = {
        max_width = { 60, 0.5 },
        min_width = 40,
      },
      disable_max_lines = 20000,
      disable_max_size = 2000000, -- 2MB
      on_attach = function(bufnr)
        vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
        vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
      end,
    })
    vim.keymap.set('n', '<leader>oo', '<cmd>AerialToggle!<CR>', { desc = "Toggle outline window" })
  end,
}
