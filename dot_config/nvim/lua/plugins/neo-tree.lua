return {
  'nvim-neo-tree/neo-tree.nvim',
  enabled = false,
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  config = function()
    vim.keymap.set('n', '<C-e>', ':Neotree filesystem reveal toggle left<CR>')
  end,
}
