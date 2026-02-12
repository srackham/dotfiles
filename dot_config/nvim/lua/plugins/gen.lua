return {
  -- "David-Kunz/gen.nvim",
  -- "srackham/gen.nvim",
  dir = "/home/srackham/projects/forks/gen.nvim",
  enabled = true,
  config = function()

    local gen = require "gen"

    -- Non-default options
    gen.setup {
      -- model = "qwen3-coder:480b-cloud",
      -- model = "glm-4.7:cloud",
      model = "minimax-m2.1:cloud",
      show_prompt = 10,
      show_model = true,
      no_auto_close = true,
      custom_prompts_only = true,
      response_register = "+", -- Copy response to clipboard
      text_selection_only = true,
      log_rollover = "daily",
      prompt_picker_layout = { width = 0.8, height = 0.7 },
      -- response_window_layout = { width = 0.9, height = 0.8 }, -- Floating response window layout
      response_window_layout = { display_mode = "vertical-split-right" },
      scratchpad_layout = { display_mode = "float", width = 0.7, height = 0.4 },
      -- scratchpad_layout = { display_mode = "vertical-split-right" },
      model_options = { think = false }, -- Suppress "thinking" field in message responses
    }

    -- Custom key mappings
    vim.keymap.set({ "n", "v" }, "<leader>zp", ":Gen<CR>", { desc = "Gen.nvim open prompts picker" })
    vim.keymap.set({ "n", "v" }, "<Leader>zr", "<Cmd>Gen /responses<CR>", { desc = "Gen.nvim open responses window" })
    vim.keymap.set({ "n", "v" }, "<Leader>zs", "<Cmd>Gen /scratchpad<CR>", { desc = "Gen.nvim open scratchpad window" })
    vim.keymap.set({ "n", "v" }, "<leader>za", ":Gen Ask_a_question<CR>", { desc = "Gen.nvim ask a question" })
    vim.keymap.set({ "n", "v" }, "<leader>zy", ":Gen Synonyms<cr>", { desc = "Gen.nvim list synonyms" })
    vim.keymap.set({ "n", "v" }, "<leader>zd", ":Gen Dictionary_definition<CR>", { desc = "Gen.nvim dictionary lookup" })
    vim.keymap.set({ "n", "v" }, "<leader>z.", ":Gen .<CR>", { desc = "Gen.nvim repeat previous command" })
    vim.keymap.set({ "n", "v" }, "<leader>zP", "<Cmd>Gen /prompts-files<CR>", { desc = "Gen.nvim prompts file manager" })
    vim.keymap.set({ "n", "v" }, "<leader>zm", "<Cmd>Gen /models<CR>", { desc = "Gen.nvim model selection" })
    vim.keymap.set(
      { "n", "v" },
      "<leader>zx",
      "<Cmd>Gen /reset<CR>",
      { desc = "Gen.nvim reset the model context and clear the response window" }
    )
    vim.keymap.set({ "n", "v" }, "<leader>zl", function()
      vim.cmd("edit " .. gen.log_filename(gen))
    end, { desc = "Gen.nvim open current log file" })
    vim.keymap.set({ "n", "v" }, "<Leader>zF", function()
      require("telescope.builtin").find_files {
        cwd = gen.logs_dir,
        prompt_title = "Find log files",
      }
    end, { desc = "Gen.nvim find log files" })
    vim.keymap.set({ "n", "v" }, "<Leader>zG", function()
      require("telescope.builtin").live_grep {
        cwd = gen.logs_dir,
        prompt_title = "Live Grep log files",
      }
    end, { desc = "Gen.nvim live-grep log files" })

    vim.keymap.set({ "n", "v" }, "<Leader>zf", function()
      require("telescope.builtin").find_files {
        cwd = gen.prompts_dir,
        prompt_title = "Find prompts files",
      }
    end, { desc = "Gen.nvim find prompts files" })
    vim.keymap.set({ "n", "v" }, "<Leader>zg", function()
      require("telescope.builtin").live_grep {
        cwd = gen.prompts_dir,
        prompt_title = "Live Grep prompts files",
      }
    end, { desc = "Gen.nvim live-grep prompts files" })
  end,
}
