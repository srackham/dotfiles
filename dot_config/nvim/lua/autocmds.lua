-- Auto-save on focus lost
vim.api.nvim_create_autocmd('FocusLost', {
  pattern = '*',
  command = 'silent! wa'
})

-- Text file options
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'markdown', 'text' },
  callback = function()
    vim.opt_local.spell = true
    -- Soft-wrapped line navigation for markdown and text files
    vim.keymap.set('n', 'j', 'gj', { buffer = true })
    vim.keymap.set('n', 'k', 'gk', { buffer = true })
    vim.keymap.set('n', '0', 'g0', { buffer = true })
    vim.keymap.set('n', '$', 'g$', { buffer = true })
  end
})

-- Disable automatic line comment insertion
-- See https://stackoverflow.com/questions/76259118/neovim-vim-optremove-doesnt-actually-change-the-option
vim.api.nvim_create_autocmd({ 'FileType' }, {
  callback = function()
    vim.cmd('set formatoptions-=ro')
  end,
})
