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
      on_attach = function(bufnr)
        vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
        vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
      end,
    })
    vim.keymap.set('n', '<leader>O', '<cmd>AerialToggle!<CR>')
  end,
}
