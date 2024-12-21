-- Auto-save on focus lost
vim.api.nvim_create_autocmd('FocusLost', {
  pattern = '*',
  command = 'silent! wa'
})

-- Allow lots of time to enter multi-character commands in insert-mode
vim.api.nvim_create_autocmd('InsertEnter', {
  callback = function()
    vim.opt.timeoutlen = 5000
  end,
})

vim.api.nvim_create_autocmd('InsertLeave', {
  callback = function()
    vim.opt.timeoutlen = 1500
  end,
})
