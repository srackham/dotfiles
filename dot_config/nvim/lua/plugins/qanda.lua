return {
  -- "srackham/qanda.nvim",
  dir = "/home/srackham/projects/qanda.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  enabled = true,
  config = function()

    local qanda = require "qanda"

    -- Override default options --
    qanda.setup {
      data_dir = "~/projects/qanda.nvim/data",
      user_prompt_lines = 5,
      system_prompt_lines = 5,
      model_options = {
        ollama = { temperature = 0.4 },
        openrouter = {},
      },
      confirm_chat_file_deletion = false,
    }

    -- Key mappings for builtin commands --
    vim.keymap.set("n", "<Tab>", "<Cmd>Qanda /prompt_window<CR>", { desc = "Qanda.nvim open user prompt window" })
    vim.keymap.set({ "n", "v" }, "<Leader>lq", "<Cmd>Qanda /prompt_window<CR>", { desc = "Qanda.nvim open Prompt window" })
    vim.keymap.set({ "n", "v", "i" }, "<C-Del>", "<Cmd>Qanda /new_prompt<CR>", { desc = "Qanda.nvim open new prompt" })
    vim.keymap.set({ "n", "v" }, "<Leader>lp", "<Cmd>Qanda /prompt_picker<CR>", { desc = "Qanda.nvim open prompts picker" })
    vim.keymap.set({ "n", "v" }, "<Leader>la", "<Cmd>Qanda /chat_window<CR>", { desc = "Qanda.nvim open Chat window" })
    vim.keymap.set({ "n", "v" }, "<Leader>lc", "<Cmd>Qanda /chat_picker<CR>", { desc = "Qanda.nvim open Chat picker" })
    vim.keymap.set({ "n", "v" }, "<Leader>ln", "<Cmd>Qanda /new_chat<CR>", { desc = "Qanda.nvim new chat" })
    vim.keymap.set({ "n", "v" }, "<Leader>ls", "<Cmd>Qanda /system_message_picker<CR>", { desc = "Qanda.nvim open System Messages picker" })
    vim.keymap.set({ "n", "v" }, "<leader>lm", "<Cmd>Qanda /model_selector<CR>", { desc = "Qanda.nvim model selection" })
    vim.keymap.set({ "n", "v" }, "<leader>lP", "<Cmd>Qanda /provider_selector<CR>", { desc = "Qanda.nvim provider selection" })
    vim.keymap.set({ "n", "v" }, "<leader>lr", "<Cmd>Qanda /recent_models<CR>", { desc = "Qanda.nvim recent model selection" })
    vim.keymap.set({ "n", "v" }, "<leader>li", "<Cmd>Qanda /status<CR>", { desc = "Qanda.nvim status information" })
    vim.keymap.set({ "n", "v" }, "<leader>lk", "<Cmd>Qanda /abort<CR>", { desc = "Qanda.nvim abort the current request" })
    vim.keymap.set(
      { "n", "v" },
      "<leader>ld",
      "<Cmd>Qanda /dump_diagnostics<CR>",
      { desc = "Qanda.nvim insert request and response registers" }
    )
    vim.keymap.set({ "n", "v" }, "<leader>lt", "<Cmd>Qanda /turn_picker<CR>", { desc = "Qanda.nvim open turn picker" })

    -- Key mappings for commonly used prompts --
    -- Convention: 2nd letter in uppercase
    vim.keymap.set({ "n", "v" }, "<Leader>lD", "<Cmd>Qanda Dictionary definition<CR>", { desc = "Qanda.nvim dictionary definition" })
    vim.keymap.set({ "n", "v" }, "<Leader>lL", "<Cmd>Qanda Latin word meaning<CR>", { desc = "Qanda.nvim Latin word to English" })
    vim.keymap.set({ "n", "v" }, "<Leader>lS", "<Cmd>Qanda Synonyms<CR>", { desc = "Qanda.nvim synonyms for word" })

    vim.keymap.set("n", "<Leader>lo", 'o<Esc>"' .. qanda.Config.response_register .. "p", {
      desc = "Open line below and paste the model response",
    })
    vim.keymap.set("n", "<Leader>lO", 'O<Esc>"' .. qanda.Config.response_register .. "p", {
      desc = "Open line above and paste the model response",
    })

    vim.keymap.set({ "n", "v" }, "<Leader>lf", function()
      require("telescope.builtin").find_files {
        cwd = qanda.prompts_dir,
        prompt_title = "Find prompts files",
      }
    end, { desc = "Qanda.nvim find prompts files" })

    vim.keymap.set({ "n", "v" }, "<Leader>lg", function()
      require("telescope.builtin").live_grep {
        cwd = qanda.Config.prompts_dir,
        prompt_title = "Live Grep prompts files",
      }
    end, { desc = "Qanda.nvim live-grep prompts files" })

  end,
}
