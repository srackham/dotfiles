return {
  'srackham/markdown-blocks.nvim',
  enabled = true,
  version = '*', -- Install latest tagged version
  config = function()
    local mb = require('markdown-blocks')
    vim.keymap.set({ 'n', 'v' }, '<Leader>mb', mb.break_block,
      { noremap = true, silent = true, desc = "Break/unbreak the paragraph/selection at the cursor" })
    vim.keymap.set({ 'n', 'v' }, '<Leader>mq', mb.quote_block,
      { noremap = true, silent = true, desc = "Quote/unquote paragraph/selection at the cursor" })
    vim.keymap.set({ 'n', 'v' }, '<Leader>mw', mb.wrap_block,
      { noremap = true, silent = true, desc = "Wrap paragraph/selection at the cursor column" })
    vim.keymap.set({ 'n', 'v' }, '<Leader>mW', function()
      local col = tonumber(vim.fn.input('Wrap at column: '))
      if col then mb.wrap_block(col) end
    end, { noremap = true, silent = true, desc = "Prompted wrap paragraph/selection" })
    vim.keymap.set({ 'n', 'v' }, '<Leader>mu', mb.unwrap_block,
      { noremap = true, silent = true, desc = "Unwrap paragraph/selection" })
    vim.keymap.set({ 'n', 'v' }, '<Leader>mn', mb.number_block,
      { silent = true, noremap = true, desc = "Number/unnumber non-indented lines" })
    vim.keymap.set({ 'n', 'v' }, '<Leader>mr', mb.renumber_block,
      { silent = true, noremap = true, desc = "Renumber numbered lines" })
  end,
}
