return {
  "junegunn/vim-easy-align",
  config = function()
    vim.keymap.set('n', 'ga', '<Plug>(EasyAlign)', { desc = "EasyAlign (normal mode)" })
    vim.keymap.set('x', 'ga', '<Plug>(EasyAlign)', { desc = "EasyAlign (visual mode)" })
  end,
}
