return {
  'srackham/markdown-blocks.nvim',
  enabled = true,
  version = '*', -- Install latest tagged version
  config = function()
    local mb = require('markdown-blocks')
    local wrap_column = 50
    vim.keymap.set({ 'n', 'v' }, '<Leader>mb', mb.break_block,
      { noremap = true, silent = true, desc = "Break/unbreak the paragraph/selection at the cursor" })
    vim.keymap.set({ 'n', 'v' }, '<Leader>mq', mb.quote_block,
      { noremap = true, silent = true, desc = "Quote/unquote paragraph/selection at the cursor" })
    vim.keymap.set({ 'n', 'v' }, '<Leader>mw', function()
      require('floating-input').input({ prompt = "Wrap column number: ", default = tostring(wrap_column) }, function(col)
        col = tonumber(col)
        if col then
          mb.wrap_block(col)
          wrap_column = col
        end
      end, {})
    end, { noremap = true, silent = true, desc = "Wrap paragraph/selection" })
    vim.keymap.set({ 'n', 'v' }, '<Leader>mu', mb.unwrap_block,
      { noremap = true, silent = true, desc = "Unwrap paragraph/selection" })
    vim.keymap.set({ 'n', 'v' }, '<Leader>mn', mb.number_block,
      { silent = true, noremap = true, desc = "Number/unnumber non-indented lines" })
    vim.keymap.set({ 'n', 'v' }, '<Leader>mr', mb.renumber_block,
      { silent = true, noremap = true, desc = "Renumber numbered lines" })
  end,
}
