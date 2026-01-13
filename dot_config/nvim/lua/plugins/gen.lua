return {
  -- "David-Kunz/gen.nvim",
  -- "srackham/gen.nvim",
  dir = "/home/srackham/projects/forks/gen.nvim",
  enabled = true,
  config = function()

    local gen = require "gen"

    -- Non-default options
    gen.setup {
      model = "qwen3-coder:480b-cloud",
      display_mode = "vertical-split-right",
      show_prompt = 10,
      show_model = true,
      no_auto_close = true,
      custom_prompts_only = true,
      response_register = "+", -- Copy response to clipboard
      text_selection_only = true,
    }

    -- Custom key mappings
    vim.keymap.set({ "n", "v" }, "<leader>lc", ":Gen<CR>", { desc = "Gen.nvim command palette" })
    vim.keymap.set({ "n", "v" }, "<M-\\>", ":Gen<CR>", { desc = "Gen.nvim command open prompts palette" })
    vim.keymap.set({ "n", "v" }, "<leader>la", ":Gen Ask_a_question<CR>", { desc = "Gen.nvim ask a question" })
    vim.keymap.set({ "n", "v" }, "<leader>ls", ":Gen Synonyms<cr>", { desc = "Gen.nvim list synonyms" })
    vim.keymap.set({ "n", "v" }, "<leader>ld", ":Gen Dictionary<CR>", { desc = "Gen.nvim dictionary lookup" })
    vim.keymap.set({ "n", "v" }, "<leader>lp", ":Gen Pronunciation<CR>", { desc = "Gen.nvim word pronunciation" })
    vim.keymap.set({ "n", "v" }, "<leader>l.", ":Gen .<CR>", { desc = "Gen.nvim repeat previous command" })
    vim.keymap.set({ "n", "v" }, "<leader>lm", gen.select_model, { desc = "Gen.nvim model" })
  end,
}
