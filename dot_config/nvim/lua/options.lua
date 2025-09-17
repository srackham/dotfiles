vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.timeoutlen = 10000
vim.opt.scrolloff = 5
vim.opt.cmdwinheight = 30
vim.opt.wrap = true -- Enable soft wrapping
vim.opt.linebreak = true -- Prevent breaking words
vim.opt.showbreak = '↪ ' -- Characters to indicate wrapped lines
vim.opt.wrapscan = false -- So macros do not revisit previously searched text

vim.opt.spellsuggest = 'best,9' -- Limit the number os spelling suggestions
vim.opt.spellcapcheck = "" -- Disable the check for capitalization at the start of a sentence

vim.opt.cursorline = true
vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#303030' })

vim.opt.swapfile = false
vim.opt.undofile = true -- Persistent undo across sessions
vim.opt.spellfile = vim.fn.expand('$HOME/doc/nvim/spell/en.utf-8.add')

vim.api.nvim_set_hl(0, 'Search', { bg = '#5f5f00', fg = 'white' })
vim.api.nvim_set_hl(0, 'IncSearch', { bg = '#ffd787', fg = 'black' })
vim.api.nvim_set_hl(0, 'CurSearch', { bg = '#ffd787', fg = 'black' })

-- Filetype specific options
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  command = "resize 30",
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "make",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = false -- use actual tabs, not spaces
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "sh", "bash" },
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.expandtab = true -- use spaces instead of tabs
  end,
})
