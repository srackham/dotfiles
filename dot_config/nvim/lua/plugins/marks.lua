return {
  'chentoast/marks.nvim',
  event = 'VeryLazy',
  opts = {},
  config = function()
    require 'marks'.setup {}
    vim.keymap.set('n', '<Leader>qm', '<Cmd>MarksQFListAll<CR>', { desc = "Copy all marks to quickfix list" })
  end,
}
