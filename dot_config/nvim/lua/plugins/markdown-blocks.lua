return {
  'srackham/markdown-blocks.nvim',
  enabled = true,
  -- version = '*', -- Install latest tagged version
  config = function()
    local mb = require('markdown-blocks')

    -- Markdown mappings
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'markdown',
      callback = function()
        local wrap_column = 100
        vim.keymap.set({ 'n', 'v' }, '<Leader>mb', mb.line_breaks_toggle,
          { noremap = true, silent = true, desc = "Break/unbreak the paragraph/selection at the cursor" })
        vim.keymap.set({ 'n', 'v' }, '<Leader>mq', mb.quotes_toggle,
          { noremap = true, silent = true, desc = "Quote/unquote paragraph/selection at the cursor" })
        vim.keymap.set({ 'n', 'v' }, '<Leader>ml', mb.bullet_list_toggle,
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
        vim.keymap.set({ 'n', 'v' }, '<Leader>mn', mb.numbered_list_toggle,
          { silent = true, noremap = true, desc = "Toggle numbering non-indented lines" })
        vim.keymap.set({ 'n', 'v' }, '<Leader>mr', function() mb.delimiters_toggle('___', '___') end,
          { silent = true, noremap = true, desc = "Toggle ruler delimiters" })
        vim.keymap.set({ 'n', 'v' }, '<Leader>mQ',
          function() mb.delimiters_toggle('<blockquote>\n', '\n</blockquote>') end,
          { silent = true, noremap = true, desc = "Toggle HTML blockquote delimiters" })
        vim.keymap.set({ 'n', 'v' }, '<Leader>mf', function() mb.delimiters_toggle('```', '```') end,
          { silent = true, noremap = true, desc = "Toggle code fence delimiters" })
        vim.keymap.set({ 'n', 'v' }, '<Leader>mF', function()
            local lang = vim.fn.input("Language: ")
            mb.delimiters_toggle('```' .. lang, '```')
          end,
          {
            silent = true,
            noremap = true,
            desc =
            "Toggle code fence delimiters with language code"
          })
        vim.keymap.set({ 'n', 'v' }, '<M-/>', function() mb.delimiters_toggle('<!--', '-->') end,
          { silent = true, noremap = true, desc = "Toggle HTML block comment delimiters" })
        vim.keymap.set({ 'n', 'v' }, '<Leader>mc', mb.csv_to_markdown_table,
          { silent = true, noremap = true, desc = "Convert CSV paragraph/selection to a Markdown table" })
        vim.keymap.set({ 'n', 'v' }, '<Leader>mC', mb.markdown_table_to_csv,
          { silent = true, noremap = true, desc = "Convert Markdown table paragraph/selection to a CSV" })
      end,
    })
  end,
}
