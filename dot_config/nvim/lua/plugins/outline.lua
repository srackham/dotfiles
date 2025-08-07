return {
  "hedyhli/outline.nvim",
  config = function()
    require("outline").setup {
      -- Your setup opts here (leave empty to use defaults)
      keymaps = {
        up_and_jump = '<C-p>',
        down_and_jump = '<C-n>',
      },
      symbol_folding = {
        -- Depth past which nodes will be folded by default. Set to false to unfold all on open.
        autofold_depth = 2,
      },
    }

    -- Key mappings
    local function toggle_outline()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
        if ft == 'Outline' then
          vim.cmd('OutlineFocus')
          return
        end
      end
      vim.cmd('Outline')
    end
    vim.keymap.set('n', '<Leader>co', toggle_outline, { desc = 'Toggle outline focus' })
    vim.keymap.set('n', '<M-o>', toggle_outline, { desc = 'Toggle outline focus' })
  end,
}
