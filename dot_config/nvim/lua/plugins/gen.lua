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
    local function delete_prompt(name)
      gen.prompts[name] = nil
    end

    local function rename_prompt(from, to)
      gen.prompts[to] = gen.prompts[from]
      delete_prompt(from)
    end

    gen.prompts["Spelling"] = {
      prompt = "Correct spelling and minor grammar mistakes in the given text. Do not change the meaning, style or formatting.\n\n$text",
      replace = true,
    }
    gen.prompts["Explain_Code"] = {
      prompt = "Explain the following $filetype code:\n\n```\n$text\n```",
    }
    gen.prompts["Meaning"] = {
      prompt = "Explain the meaning of the following text:\n$text",
    }
    gen.prompts["Synonyms"] = {
      prompt = "List synonyms for the following word: $text",
    }
    gen.prompts["Latin_to_English"] = {
      prompt = "Translate the following Latin text to English:\n\n$text",
    }
    rename_prompt("Enhance_Grammar_Spelling", "Grammar_and_Spelling")

    -- Custom key mappings
    local function execute_prompt(prompt)
      -- If in normal mode select the word at the cursor.
      local mode = vim.api.nvim_get_mode().mode
      if mode == "n" then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("viw:Gen " .. prompt .. "<CR>", true, false, true), "n", false)
      else
        vim.cmd("Gen " .. prompt)
      end
    end

    vim.keymap.set({ "n", "v" }, "<leader>ll", ":Gen<CR>", { desc = "Gen.nvim command palette" })
    vim.keymap.set({ "n", "v" }, "<M-\\>", ":Gen<CR>", { desc = "Gen.nvim command palette" })
    vim.keymap.set({ "n", "v" }, "<leader>lc", ":Gen Chat<CR>", { desc = "Gen.nvim chat" })
    vim.keymap.set({ "n", "v" }, "<leader>lm", gen.select_model, { desc = "Gen.nvim model" })
    vim.keymap.set({ "n", "v" }, "<leader>ls", ":Gen Spelling<CR>", { desc = "Gen.nvim spelling correction" })
    vim.keymap.set({ "n", "v" }, "<leader>lS", function()
      execute_prompt "Synonyms"
    end, { desc = "Gen.nvim list synonyms" })
  end,
}
