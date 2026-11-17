return {
  "gbprod/yanky.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    require("yanky").setup {
      ring = {
        history_length = 100,
        storage = "shada", -- or "sqlite" (requires kkharji/sqlite.lua)
      },
    }

    -- Load the Telescope extension
    require("telescope").load_extension "yank_history"

    -- Recommended keymaps
    vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
    vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
    vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
    vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")
    vim.keymap.set("n", "<leader>fy", "<cmd>Telescope yank_history<cr>", { desc = "Yank History" })
  end,
}
