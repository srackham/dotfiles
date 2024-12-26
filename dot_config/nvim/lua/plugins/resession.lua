return {
  'stevearc/resession.nvim',
  opts = {},
  config = function()
    local resession = require('resession')
    resession.setup()
    vim.keymap.set('n', '<Leader>Ss', resession.save, { desc = "Save session" })
    vim.keymap.set('n', '<Leader>Sl', resession.load, { desc = "Load session" })
    vim.keymap.set('n', '<Leader>Sd', resession.delete, { desc = "Delete session" })
    -- Create one session per directory
    vim.api.nvim_create_autocmd('VimEnter', {
      callback = function()
        -- Only load the session if nvim was started with no args
        if vim.fn.argc(-1) == 0 then
          -- Save these to a different directory, so our manual sessions don't get polluted
          resession.load(vim.fn.getcwd(), { dir = 'dirsession', silence_errors = true })
        end
      end,
      nested = true,
    })
    -- Save the session when nvim closes
    vim.api.nvim_create_autocmd('VimLeavePre', {
      callback = function()
        resession.save(vim.fn.getcwd(), { dir = 'dirsession', notify = false })
      end,
    })
  end
}
