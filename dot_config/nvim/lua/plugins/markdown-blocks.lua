return {
  'srackham/markdown-blocks.nvim',
  enabled = true,
  -- version = '*', -- Install latest tagged version
  config = function()
    -- Enable mappings only in Markdown buffers
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'markdown',
      callback = function()
        local mb = require('markdown-blocks')
        local wrap_column = 100
        vim.keymap.set({ 'n', 'v' }, '<Leader>mb', mb.break_block,
          { noremap = true, silent = true, desc = "Break/unbreak the paragraph/selection at the cursor" })
        vim.keymap.set({ 'n', 'v' }, '<Leader>mq', mb.quote_block,
          { noremap = true, silent = true, desc = "Quote/unquote paragraph/selection at the cursor" })
        vim.keymap.set({ 'n', 'v' }, '<Leader>ml', mb.list_block,
          { noremap = true, silent = true, desc = "Toggle list item bullets in paragraph/selection at the cursor" })
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
          { silent = true, noremap = true, desc = "Toggle numbering non-indented lines" })
        vim.keymap.set({ 'n', 'v' }, '<Leader>mr', function() mb.delimit_block('___', '___') end,
          { silent = true, noremap = true, desc = "Surround paragraph/selection with rulers" })
        vim.keymap.set({ 'n', 'v' }, '<Leader>mQ', function() mb.delimit_block('<blockquote>', '</blockquote>') end,
          { silent = true, noremap = true, desc = "Surround paragraph/selection with HTML blockquote" })
        vim.keymap.set({ 'n', 'v' }, '<Leader>mf', function() mb.delimit_block('```', '```') end,
          { silent = true, noremap = true, desc = "Surround paragraph/selection with code fence" })
        vim.keymap.set({ 'n', 'v' }, '<Leader>mF', function()
            local lang = vim.fn.input("Language: ")
            mb.delimit_block('```' .. lang, '```')
          end,
          {
            silent = true,
            noremap = true,
            desc =
            "Surround paragraph/selection with code fence (prompt for language code)"
          })
        vim.keymap.set({ 'n', 'v' }, '<Leader>mc', mb.csv_to_markdown_table,
          { silent = true, noremap = true, desc = "Convert CSV paragraph/selection to a Markdown table" })
        vim.keymap.set({ 'n', 'v' }, '<Leader>mC', mb.markdown_table_to_csv,
          { silent = true, noremap = true, desc = "Convert Markdown table paragraph/selection to a CSV" })
      end,
    })
  end,
}
