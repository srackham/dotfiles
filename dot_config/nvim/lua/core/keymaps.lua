vim.api.nvim_set_keymap('n', 'U', '<C-r>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', ',c', ':w<CR>:bd<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', ',q', ':wa<CR>:q<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', ',f', ':Telescope find_files<CR>', { noremap = true, silent = true })
