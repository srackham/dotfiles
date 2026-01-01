return {
  -- "David-Kunz/gen.nvim",
  -- "srackham/gen.nvim",
  dir = "/home/srackham/projects/forks/gen.nvim",
  enabled = true,
  config = function()

    local gen = require "gen"

    -- Non-default options
    gen.setup {
      model = "qwen3-coder:480b-cloud", -- The default model to use.
      display_mode = "horizontal-split", -- The display mode. Can be "float" or "split" or "horizontal-split" or "vertical-split".
      show_prompt = true, -- Shows the prompt submitted to Ollama. Can be true (3 lines) or "full".
    }

    -- Custom prompts
    gen.prompts["Enhance_Grammar_Spelling"].replace = false -- Don't automatically replace
    gen.prompts["Fix_Spelling"] = {
      prompt = "Fix spelling errors in the following text, just output the final text without additional quotes around it:\n$text",
      replace = true,
    }
    gen.prompts["Explain_Code"] = {
      prompt = "Explain the following code:\n```$filetype\n$text\n```",
    }

    -- Custom key mappings
    vim.keymap.set({ "n", "v" }, "<leader>lp", ":Gen<CR>", { desc = "Gen.nvim command palette" })
    vim.keymap.set({ "n", "v" }, "<leader>lc", ":Gen Chat<CR>", { desc = "Gen.nvim chat" })
    vim.keymap.set({ "n", "v" }, "<leader>ls", ":Gen Enhance_Grammar_Spelling<CR>", { desc = "Gen.nvim spelling and grammar" })
    vim.keymap.set({ "n", "v" }, "<leader>lm", function()
      gen.select_model()
    end, { desc = "Gen.nvim model" })
  end,
}
