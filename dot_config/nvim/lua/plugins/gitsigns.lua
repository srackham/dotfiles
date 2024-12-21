return {
  "lewis6991/gitsigns.nvim",
  config = function()
    local gitsigns = require('gitsigns')
    gitsigns.setup()
    vim.keymap.set('n', '<Leader>gb', gitsigns.toggle_current_line_blame)
    vim.keymap.set('n', '<Leader>gd', gitsigns.diffthis)
    vim.keymap.set('n', '<Leader>gp', gitsigns.preview_hunk)
    vim.keymap.set('n', '<Leader>gR', gitsigns.reset_buffer)
    vim.keymap.set('n', '<Leader>gr', gitsigns.reset_hunk)
    vim.keymap.set('n', '<Leader>gS', gitsigns.stage_buffer)
    vim.keymap.set('n', '<Leader>gs', gitsigns.stage_hunk)
    vim.keymap.set('n', '<Leader>gu', gitsigns.undo_stage_hunk)
    vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { fg = "#999999" })
  end,
}
