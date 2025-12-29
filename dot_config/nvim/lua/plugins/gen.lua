return {
  "David-Kunz/gen.nvim",
  enabled = true,
  opts = {
    model = "qwen3-coder:480b-cloud", -- The default model to use.
    display_mode = "horizontal-split", -- The display mode. Can be "float" or "split" or "horizontal-split" or "vertical-split".
    show_prompt = true, -- Shows the prompt submitted to Ollama. Can be true (3 lines) or "full".
    no_auto_close = true, -- Never closes the window automatically.
  },
  keys = {
    { "<leader>lg", ":Gen<CR>", mode = { "n", "v" }, desc = "Gen.nvim generate" },
    { "<leader>lc", ":Gen Chat<CR>", mode = { "n", "v" }, desc = "Gen.nvim chat" },
    { "<leader>ls", ":Gen Enhance_Grammar_Spelling<CR>", mode = { "n", "v" }, desc = "Gen.nvim spelling and grammar" },
    {
      "<leader>lm",
      function()
        require("gen").select_model()
      end,
      mode = { "n", "v" },
      desc = "Gen.nvim model",
    },
  },
}
