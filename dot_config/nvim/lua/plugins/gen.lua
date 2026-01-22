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
      -- model = "glm-4.7:cloud",
      -- model = "minimax-m2.1:cloud",
      -- display_mode = "vertical-split-right",
      show_prompt = 10,
      show_model = true,
      no_auto_close = true,
      custom_prompts_only = true,
      response_register = "+", -- Copy response to clipboard
      text_selection_only = true,
      log_rollover = "daily",
      response_window_layout = { width = 0.9, height = 0.8 }, -- Floating response window layout
      prompt_picker_layout = { width = 0.8, height = 0.7 },
    }

    -- Custom key mappings
    vim.keymap.set({ "n", "v" }, "<leader>lc", ":Gen<CR>", { desc = "Gen.nvim open prompts picker" })
    vim.keymap.set({ "n", "v" }, "<leader>la", ":Gen Ask_a_question<CR>", { desc = "Gen.nvim ask a question" })
    vim.keymap.set({ "n", "v" }, "<leader>ls", ":Gen Synonyms<cr>", { desc = "Gen.nvim list synonyms" })
    vim.keymap.set({ "n", "v" }, "<leader>ld", ":Gen Dictionary<CR>", { desc = "Gen.nvim dictionary lookup" })
    vim.keymap.set({ "n", "v" }, "<leader>l.", ":Gen .<CR>", { desc = "Gen.nvim repeat previous command" })
    vim.keymap.set({ "n", "v" }, "<leader>lm", gen.select_model, { desc = "Gen.nvim model selection" })
    vim.keymap.set({ "n", "v" }, "<leader>lo", "<Cmd>Gen /open<CR>", { desc = "Gen.nvim open the response window" })
    vim.keymap.set({ "n", "v" }, "<leader>lp", "<Cmd>Gen /prompts<CR>", { desc = "Gen.nvim prompts file manager" })
    vim.keymap.set(
      { "n", "v" },
      "<leader>lr",
      "<Cmd>Gen /reset<CR>",
      { desc = "Gen.nvim reset the model context and clear the response window" }
    )
    vim.keymap.set({ "n", "v" }, "<M-\\>", "<Cmd>Gen /toggle<CR>", { desc = "Gen.nvim toggle response window" })
    vim.keymap.set({ "n" }, "<leader>ll", function()
      vim.cmd("edit " .. gen.log_file(gen))
    end, { desc = "Gen.nvim open current log file" })
    vim.keymap.set({ "n", "v" }, "<Leader>lg", function()
      require("telescope.builtin").live_grep {
        cwd = gen.logs_dir,
      }
    end, { desc = "Gen.nvim live-grep log files" })
    vim.keymap.set({ "n", "v" }, "<Leader>lf", function()
      require("telescope.builtin").find_files {
        cwd = gen.logs_dir,
        sort_mtime = true,
      }
    end, { desc = "Gen.nvim find log files" })
  end,
}
