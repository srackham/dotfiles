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
    vim.keymap.set({ "n", "v" }, "<C-Del>", "<Cmd>Qanda /new_prompt<CR>", { desc = "Qanda.nvim open new prompt" })
    vim.keymap.set({ "n", "v" }, "<S-Tab>", "<Cmd>Qanda /chat_window<CR>", { desc = "Qanda.nvim open user Chat window" })
    vim.keymap.set({ "n", "v" }, "aa", "<Cmd>Qanda /repeat<CR>", { desc = "Qanda.nvim execute previous command" })
    vim.keymap.set({ "n", "v" }, "acd", "<Cmd>Qanda /delete_old_chats<CR>", { desc = "Qanda.nvim delete old chats" })
    vim.keymap.set({ "n", "v" }, "acm", "<Cmd>Qanda /toggle_chat_window_mode<CR>", { desc = "Qanda.nvim toggle Chat window mode" })
    vim.keymap.set({ "n", "v" }, "acn", "<Cmd>Qanda /new_chat<CR>", { desc = "Qanda.nvim new chat" })
    vim.keymap.set({ "n", "v" }, "acp", "<Cmd>Qanda /chat_picker<CR>", { desc = "Qanda.nvim open Chat picker" })
    vim.keymap.set({ "n", "v" }, "acw", "<Cmd>Qanda /chat_window<CR>", { desc = "Qanda.nvim open Chat window" })
    vim.keymap.set({ "n", "v" }, "add", "<Cmd>Qanda /dump_diagnostics<CR>", { desc = "Qanda.nvim display request/response diagnostics" })
    vim.keymap.set({ "n", "v" }, "ai", "<Cmd>Qanda /status<CR>", { desc = "Qanda.nvim status information" })
    vim.keymap.set({ "n", "v" }, "ak", "<Cmd>Qanda /abort<CR>", { desc = "Qanda.nvim abort the current request" })
    vim.keymap.set({ "n", "v" }, "amp", "<Cmd>Qanda /provider_picker<CR>", { desc = "Qanda.nvim model provider selection" })
    vim.keymap.set({ "n", "v" }, "amr", "<Cmd>Qanda /recent_models<CR>", { desc = "Qanda.nvim recent model selection" })
    vim.keymap.set({ "n", "v" }, "ams", "<Cmd>Qanda /model_picker<CR>", { desc = "Qanda.nvim model selection" })
    vim.keymap.set({ "n", "v" }, "apn", "<Cmd>Qanda /new_prompt<CR>", { desc = "Qanda.nvim open new prompt" })
    vim.keymap.set({ "n", "v" }, "apt", "<Cmd>Qanda /prompt_template_picker<CR>", { desc = "Qanda.nvim open prompts template picker" })
    vim.keymap.set({ "n", "v" }, "apw", "<Cmd>Qanda /prompt_window<CR>", { desc = "Qanda.nvim open Prompt window" })
    vim.keymap.set({ "n", "v" }, "ast", "<Cmd>Qanda /system_template_picker<CR>", { desc = "Qanda.nvim open System template picker" })
    vim.keymap.set({ "n", "v" }, "atp", "<Cmd>Qanda /turn_picker<CR>", { desc = "Qanda.nvim open turn picker" })

    -- Key mappings for prompt templates --
    vim.keymap.set({ "n", "v" }, "aq", ":Qanda !Query<CR>", { desc = "Qanda.nvim ask a question" })
    -- English
    vim.keymap.set({ "n", "v" }, "aea", ":Qanda !Antonyms<CR>", { desc = "Qanda.nvim antonyms for a word" })
    vim.keymap.set({ "n", "v" }, "aem", ":Qanda !Word meaning<CR>", { desc = "Qanda.nvim word meaning" })
    vim.keymap.set({ "n", "v" }, "aep", ":Qanda !Word pronunciation<CR>", { desc = "Qanda.nvim word pronunciation" })
    vim.keymap.set({ "n", "v" }, "aes", ":Qanda !Synonyms<CR>", { desc = "Qanda.nvim synonyms for a word" })
    vim.keymap.set({ "n", "v" }, "aew", ":Qanda !Spell a word<CR>", { desc = "Qanda.nvim spell a word" })
    -- Latin
    vim.keymap.set({ "n", "v" }, "alm", ":Qanda !Latin text meaning<CR>", { desc = "Qanda.nvim Latin text meaning" })
    vim.keymap.set({ "n", "v" }, "alp", ":Qanda !Latin text pronunciation<CR>", { desc = "Qanda.nvim Latin text pronunciation" })
    -- Spanish
    vim.keymap.set({ "n", "v" }, "asm", ":Qanda !Spanish text meaning<CR>", { desc = "Qanda.nvim Spanish text meaning" })
    vim.keymap.set({ "n", "v" }, "asp", ":Qanda !Spanish text pronunciation<CR>", { desc = "Qanda.nvim Spanish text pronunciation" })

  end,
}
