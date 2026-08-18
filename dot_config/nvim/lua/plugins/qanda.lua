return {
  -- "srackham/qanda.nvim",
  dir = "/home/srackham/projects/qanda.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  enabled = true,
  config = function()

    local qanda = require "qanda"

    -- Override default options here --
    qanda.setup {
      data_dir = "~/share/data/qanda_nvim",
      user_prompt_lines = 5,
      system_message_lines = 5,
      provider_options = {
        ollama = { temperature = 0.4 },
      },
      confirm_chat_file_deletion = false,
      filter_mode = "substring",
    }

    -- Key mappings for builtin commands --
    vim.keymap.set({ "n", "v" }, "<S-Tab>", "<Cmd>Qanda /chat_window<CR>", { desc = "Qanda.nvim open user Chat window" })
    vim.keymap.set({ "n", "v" }, "<Leader>lq", "<Cmd>Qanda /prompt_window<CR>", { desc = "Qanda.nvim open Prompt window" })
    vim.keymap.set({ "n", "v", "i" }, "<C-Del>", "<Cmd>Qanda /new_prompt<CR>", { desc = "Qanda.nvim open new prompt" })
    vim.keymap.set(
      { "n", "v" },
      "<Leader>lp",
      "<Cmd>Qanda /prompt_template_picker<CR>",
      { desc = "Qanda.nvim open prompts template picker" }
    )
    vim.keymap.set({ "n", "v" }, "<Leader>la", "<Cmd>Qanda /chat_window<CR>", { desc = "Qanda.nvim open Chat window" })
    vim.keymap.set({ "n", "v" }, "<Leader>lc", "<Cmd>Qanda /chat_picker<CR>", { desc = "Qanda.nvim open Chat picker" })
    vim.keymap.set({ "n", "v" }, "<Leader>ln", "<Cmd>Qanda /new_chat<CR>", { desc = "Qanda.nvim new chat" })
    vim.keymap.set(
      { "n", "v" },
      "<Leader>ls",
      "<Cmd>Qanda /system_template_picker<CR>",
      { desc = "Qanda.nvim open System template picker" }
    )
    vim.keymap.set({ "n", "v" }, "<leader>lm", "<Cmd>Qanda /model_picker<CR>", { desc = "Qanda.nvim model selection" })
    vim.keymap.set({ "n", "v" }, "<leader>lP", "<Cmd>Qanda /provider_picker<CR>", { desc = "Qanda.nvim provider selection" })
    vim.keymap.set({ "n", "v" }, "<leader>lr", "<Cmd>Qanda /recent_models<CR>", { desc = "Qanda.nvim recent model selection" })
    vim.keymap.set({ "n", "v" }, "<leader>li", "<Cmd>Qanda /status<CR>", { desc = "Qanda.nvim status information" })
    vim.keymap.set({ "n", "v" }, "<leader>lk", "<Cmd>Qanda /abort<CR>", { desc = "Qanda.nvim abort the current request" })
    vim.keymap.set(
      { "n", "v" },
      "<leader>ld",
      "<Cmd>Qanda /dump_diagnostics<CR>",
      { desc = "Qanda.nvim display request/response diagnostics" }
    )
    vim.keymap.set({ "n", "v" }, "<leader>lt", "<Cmd>Qanda /turn_picker<CR>", { desc = "Qanda.nvim open turn picker" })

    -- Key mappings for prompt templates --
    vim.keymap.set({ "n", "v" }, "<C-q>", ":Qanda !Query<CR>", { desc = "Qanda.nvim ask a question" })
    -- English
    vim.keymap.set({ "n", "v" }, "<Leader>aem", ":Qanda !Word meaning<CR>", { desc = "Qanda.nvim word meaning" })
    vim.keymap.set({ "n", "v" }, "<Leader>aep", ":Qanda !Word pronunciation<CR>", { desc = "Qanda.nvim word pronunciation" })
    vim.keymap.set({ "n", "v" }, "<Leader>aea", ":Qanda !Antonyms<CR>", { desc = "Qanda.nvim antonyms for a word" })
    vim.keymap.set({ "n", "v" }, "<Leader>aes", ":Qanda !Synonyms<CR>", { desc = "Qanda.nvim synonyms for a word" })
    vim.keymap.set({ "n", "v" }, "<Leader>aeS", ":Qanda !Spell a word<CR>", { desc = "Qanda.nvim spell a word" })
    -- Latin
    vim.keymap.set({ "n", "v" }, "<Leader>alm", ":Qanda !Latin word meaning<CR>", { desc = "Qanda.nvim Latin word meaning" })
    vim.keymap.set({ "n", "v" }, "<Leader>alp", ":Qanda !Latin word pronunciation<CR>", { desc = "Qanda.nvim Latin word pronunciation" })
    -- Spanish
    vim.keymap.set({ "n", "v" }, "<Leader>asm", ":Qanda !Spanish word meaning<CR>", { desc = "Qanda.nvim Spanish word meaning" })
    vim.keymap.set(
      { "n", "v" },
      "<Leader>asp",
      ":Qanda !Spanish word pronunciation<CR>",
      { desc = "Qanda.nvim Spanish word pronunciation" }
    )

  end,
}
