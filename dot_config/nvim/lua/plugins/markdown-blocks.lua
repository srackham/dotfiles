return {
  'srackham/markdown-blocks.nvim',
  enabled = true,
  -- version = '*', -- Install latest tagged version
  config = function()
    local mb = require('markdown-blocks')
    local wrap_column = 50
    vim.keymap.set({ 'n', 'v' }, '<Leader>mb', mb.break_block,
      { noremap = true, silent = true, desc = "Break/unbreak the paragraph/selection at the cursor" })
    vim.keymap.set({ 'n', 'v' }, '<Leader>mq', mb.quote_block,
      { noremap = true, silent = true, desc = "Quote/unquote paragraph/selection at the cursor" })
    vim.keymap.set({ 'n', 'v' }, '<Leader>mw', function()
      local col = vim.fn.input("Wrap at column number: ", tostring(wrap_column))
      if col == '' then
        return
      end
      col = tonumber(col)
      if col then
        mb.wrap_block(col)
        wrap_column = col
      end
    end, { noremap = true, silent = true, desc = "Wrap paragraph/selection" })
    vim.keymap.set({ 'n', 'v' }, '<Leader>mu', mb.unwrap_block,
      { noremap = true, silent = true, desc = "Unwrap paragraph/selection" })
    vim.keymap.set({ 'n', 'v' }, '<Leader>mn', mb.number_block,
      { silent = true, noremap = true, desc = "Number/unnumber non-indented lines" })
    vim.keymap.set({ 'n', 'v' }, '<Leader>mN', mb.renumber_block,
      { silent = true, noremap = true, desc = "Renumber numbered lines" })
    vim.keymap.set({ 'n', 'v' }, '<Leader>mr', mb.ruled_block,
      { silent = true, noremap = true, desc = "Surround paragraph/selection with rulers" })
    vim.keymap.set({ 'n', 'v' }, '<Leader>mf', mb.code_block,
      { silent = true, noremap = true, desc = "Surround paragraph/selection with code fence" })
    vim.keymap.set({ 'n', 'v' }, '<Leader>mF', function()
        local lang = vim.fn.input("Language: ")
        mb.code_block(lang)
      end,
      { silent = true, noremap = true, desc = "Surround paragraph/selection with code fence (prompt for language code)" })
    vim.keymap.set({ 'n', 'v' }, '<Leader>mc', mb.csv_to_markdown_table,
      { silent = true, noremap = true, desc = "Convert CSV paragraph/selection to a Markdown table" })
    vim.keymap.set({ 'n', 'v' }, '<Leader>mC', mb.markdown_table_to_csv,
      { silent = true, noremap = true, desc = "Convert Markdown table paragraph/selection to a CSV" })
  end,
}
