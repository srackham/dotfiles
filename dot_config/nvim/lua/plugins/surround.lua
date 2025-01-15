return {
  'kylechui/nvim-surround',
  event = 'VeryLazy',
  config = function()
    require('nvim-surround').setup()
    vim.keymap.set('n', '<Leader>ss', '<Plug>(nvim-surround-normal)',
      { noremap = false, silent = true, desc = "Surround text object with character" })
    vim.keymap.set('v', '<Leader>sv', '<Plug>(nvim-surround-visual)',
      { noremap = false, silent = true, desc = "Surround selection with character" })
    vim.keymap.set('n', '<Leader>sd', '<Plug>(nvim-surround-delete)',
      { noremap = false, silent = true, desc = "Delete surrounding characters" })
    vim.keymap.set('n', '<Leader>sc', '<Plug>(nvim-surround-change)',
      { noremap = false, silent = true, desc = "Change surrounding characters" })
  end
}
