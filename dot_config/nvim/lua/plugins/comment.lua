return {
  'numToStr/Comment.nvim',
  config = function()
    require('Comment').setup()

    vim.keymap.set('n', '<C-_>', function()
      local count = vim.v.count
      local api = require('Comment.api')
      if count == 0 then
        api.toggle.linewise.current()
      else
        api.toggle.linewise.count(count)
      end
    end, { noremap = true, silent = true, desc = "Toggle line comment (with optional count)" })
  end,

  vim.keymap.set('x', '<C-_>', function()
    local api = require('Comment.api')
    local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
    vim.api.nvim_feedkeys(esc, 'nx', false)
    api.toggle.linewise(vim.fn.visualmode())
  end, { noremap = true, silent = true, desc = "Toggle block comment for selection" })

}
