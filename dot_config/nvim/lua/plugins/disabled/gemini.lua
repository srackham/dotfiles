return {
  'kiddos/gemini.nvim',
  config = function()
    require('gemini').setup({
      completion = {
        enabled = false,
        blacklist_filetypes = { 'help', 'json', 'yaml', 'toml' },
        blacklist_filenames = {},
        completion_delay = 1000,
        move_cursor_end = true,
        insert_result_key = '<C-y>',
      },
    })
  end
}
