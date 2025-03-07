return {
  'chentoast/marks.nvim',
  event = 'VeryLazy',
  opts = {},
  config = function()
    require 'marks'.setup {}
    vim.keymap.set('n', '<Leader>md', '<Plug>(Marks-deletebuf)', { silent = true, desc = "Delete all marks in buffer" })
    vim.keymap.set('n', '<Leader>mq', '<Cmd>MarksQFListAll<CR>', { desc = "Copy all marks to quickfix list" })
    vim.keymap.set('n', '<Leader>mt', '<Cmd>MarksToggleSigns<CR>', { silent = true, desc = "Toggle marks signs" })
  end,
}
