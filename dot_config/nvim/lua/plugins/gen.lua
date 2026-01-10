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
      show_prompt = true, -- Shows the prompt submitted to Ollama. Can be true (3 lines) or "full".
      show_model = true,
      no_auto_close = true, -- Don't close the generation window.
      custom_prompts_only = true,
    }

    -- Custom key mappings
    vim.keymap.set({ "n", "v" }, "<leader>lp", ":Gen<CR>", { desc = "Gen.nvim command palette" })
    vim.keymap.set({ "n", "v" }, "<M-\\>", ":Gen<CR>", { desc = "Gen.nvim command open prompts palette" })
    vim.keymap.set({ "n", "v" }, "<leader>la", ":Gen Ask a question<CR>", { desc = "Gen.nvim ask a question" })
    vim.keymap.set({ "n", "v" }, "<leader>lm", gen.select_model, { desc = "Gen.nvim model" })
    vim.keymap.set({ "n", "v" }, "<leader>ls", ":Gen Writing: Spelling and grammar<CR>", { desc = "Gen.nvim spelling correction" })
    vim.keymap.set({ "n", "v" }, "<leader>lS", ":Gen Synonyms<cr>", { desc = "Gen.nvim list synonyms" })
    vim.keymap.set({ "n", "v" }, "<leader>ld", ":Gen Dictionary<CR>", { desc = "Gen.nvim dictionary lookup" })
  end,
}
