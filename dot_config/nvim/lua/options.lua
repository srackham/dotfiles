local g = require('globals')

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.timeoutlen = 1500

vim.opt.wrap = true -- Enable soft wrapping
vim.opt.linebreak = true -- Prevent breaking words
vim.opt.columns = g.columns -- Set text width
vim.opt.showbreak = '↪ ' -- Characters to indicate wrapped lines

vim.opt.spellsuggest = 'best,9' -- Limit the number os spelling suggestions
