vim.g.editorconfig = false -- Disable .editorconfig files globally

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.timeoutlen = 10000
vim.opt.scrolloff = 5

vim.opt.wrap = true -- Enable soft wrapping
vim.opt.linebreak = true -- Prevent breaking words
vim.opt.showbreak = '↪ ' -- Characters to indicate wrapped lines

vim.opt.spellsuggest = 'best,9' -- Limit the number os spelling suggestions

vim.opt.cursorline = true
vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#303030' })

vim.opt.swapfile = false
vim.opt.undofile = true -- Persistent undo across sessions
vim.opt.spellfile = vim.fn.expand('$HOME/doc/nvim/spell/en.utf-8.add')
