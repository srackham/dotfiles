return {
  "lewis6991/gitsigns.nvim",
  config = function()
    require("gitsigns").setup()
    vim.keymap.set("n", "<Leader>gb", ":Gitsigns toggle_current_line_blame<CR>", {})
    vim.keymap.set("n", "<Leader>gp", ":Gitsigns preview_hunk<CR>", {})
    vim.keymap.set("n", "<Leader>gr", ":Gitsigns reset_hunk<CR>", {})
    vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { fg = "#999999" })
  end,
}
