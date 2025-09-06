-- Auto-save on focus lost
vim.api.nvim_create_autocmd('FocusLost', {
  pattern = '*',
  command = 'silent! wa'
})

-- Disable automatic line comment insertion for all filetypes
vim.api.nvim_create_autocmd({ 'FileType' }, {
  callback = function()
    vim.cmd('set formatoptions-=ro')
  end,
})

-- Text files
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'asciidoc', 'markdown', 'text' },
  callback = function()
    vim.opt_local.spell = true
    -- Soft-wrapped line navigation for markdown and text files
    vim.keymap.set('n', 'j', 'gj', { buffer = true })
    vim.keymap.set('n', 'k', 'gk', { buffer = true })
    vim.keymap.set('n', '0', 'g0', { buffer = true })
    vim.keymap.set('n', '$', 'g$', { buffer = true })
  end
})

-- Strip trailing white space from files before saving
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    vim.cmd([[%s/\s\+$//e]])
  end,
})
