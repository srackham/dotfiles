return {
  'folke/persistence.nvim',
  config = function()
    local persistence = require('persistence')
    persistence.setup()
    vim.api.nvim_create_autocmd('VimEnter', {
      callback = function()
        if vim.fn.argc(-1) == 0 then -- Only load the session if nvim was started with no args
          persistence.load()         -- Load the session for the current directory
        end
      end,
      nested = true,
    })
    vim.keymap.set("n", "<leader>rl", function() persistence.load() end,
      { desc = "Load the session for the current directory" })
    vim.keymap.set("n", "<leader>rL", function() persistence.select() end,
      { desc = "Select a session to load" })
  end,
}
