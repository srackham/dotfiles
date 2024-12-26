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

-- Enable spell checking for .md and .txt files by default
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.md', '*.txt' },
  callback = function()
    vim.opt_local.spell = true
  end
})

-- Disable automatic line comment insertion
-- See https://stackoverflow.com/questions/76259118/neovim-vim-optremove-doesnt-actually-change-the-option
vim.api.nvim_create_autocmd({ 'FileType' }, {
  callback = function()
    vim.cmd('set formatoptions-=ro')
  end,
})
