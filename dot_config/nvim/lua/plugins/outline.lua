return {
  "hedyhli/outline.nvim",
  config = function()
    vim.keymap.set("n", "<leader>co", "<Cmd>OutlineOpen!<CR><Cmd>OutlineFocus<CR>", { desc = "Toggle outline focus" })
    vim.keymap.set("n", "<M-o>", "<Cmd>OutlineOpen!<CR><Cmd>OutlineFocus<CR>", { desc = "Toggle outline focus" })
    require("outline").setup {
      -- Your setup opts here (leave empty to use defaults)
      keymaps = {
        up_and_jump = '<C-p>',
        down_and_jump = '<C-n>',
      },
    }
  end,
}
