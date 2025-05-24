return {
  'lewis6991/gitsigns.nvim',
  config = function()
    local gitsigns = require('gitsigns')
    gitsigns.setup()

    -- Navigation
    vim.keymap.set('n', ']g', function()
      if vim.wo.diff then
        vim.cmd.normal({ ']g', bang = true })
      else
        gitsigns.nav_hunk('next')
      end
    end, { desc = "Next hunk" })

    vim.keymap.set('n', '[g', function()
      if vim.wo.diff then
        vim.cmd.normal({ '[g', bang = true })
      else
        gitsigns.nav_hunk('prev')
      end
    end, { desc = "Previous hunk" })

    -- Actions
    vim.keymap.set('n', '<Leader>gb', gitsigns.toggle_current_line_blame, { desc = "Toggle line blame" })
    vim.keymap.set('n', '<Leader>gd', gitsigns.toggle_deleted, { desc = "Toggle deleted lines" })
    vim.keymap.set('n', '<Leader>gp', gitsigns.preview_hunk, { desc = "Preview hunk" })
    vim.keymap.set('n', '<Leader>gR', gitsigns.reset_buffer, { desc = "Reset all hunks in current buffer" })
    vim.keymap.set('n', '<Leader>gr', gitsigns.reset_hunk, { desc = "Reset hunk" })
    vim.keymap.set('n', '<Leader>gS', gitsigns.stage_buffer, { desc = "Stage all hunks in current buffer" })
    vim.keymap.set('n', '<Leader>gs', gitsigns.stage_hunk, { desc = "Stage hunk" })
    vim.keymap.set('n', '<Leader>gt', gitsigns.toggle_signs, { desc = "Toggle Git signs" })
    vim.keymap.set('n', '<Leader>gu', gitsigns.undo_stage_hunk, { desc = "Undo staged hunk" })

    vim.api.nvim_set_hl(0, 'GitSignsCurrentLineBlame', { fg = '#999999' })

    -- 24-May-2025: TODO: drop unused code
    -- -- Turn Git signs off by default for Markdown files
    -- vim.api.nvim_create_autocmd('FileType', {
    --   pattern = 'markdown',
    --   callback = function() gitsigns.toggle_signs(false) end,
    -- })
  end,
}
